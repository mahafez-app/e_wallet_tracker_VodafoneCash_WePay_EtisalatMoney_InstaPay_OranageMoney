import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/data/models/wallet_dto.dart';
import '../../../../core/domain/enums/wallet_provider.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/egyptian_phone_number.dart';

abstract interface class WalletRemoteDataSource {
  Future<List<WalletDto>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    required Map<String, double> initialBalances,
    required String deviceId,
  });

  Future<List<WalletDto>> getWallets();

  Future<void> deleteWallet(String walletId);

  /// Associates a SIM subscription ID with a wallet so that future messages
  /// from that SIM are routed directly without ambiguity.
  Future<void> linkSubscriptionId({
    required String walletId,
    required int subscriptionId,
  });
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  const WalletRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  @override
  Future<List<WalletDto>> getWallets() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in');
    }

    final query = await _firestore
        .collection('wallets')
        .where('ownerUid', isEqualTo: currentUser.uid)
        .get();

    return query.docs.map((doc) => WalletDto.fromFirestore(doc)).toList();
  }

  @override
  Future<List<WalletDto>> addWallets({
    required String phoneNumber,
    required List<String> providers,
    required Map<String, double> initialBalances,
    required String deviceId,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in');
    }

    final normalizedPhoneNumber = EgyptianPhoneNumber.normalize(phoneNumber);
    final existingProvidersSet = await _findExistingProviders(
      ownerUid: currentUser.uid,
      normalizedPhoneNumber: normalizedPhoneNumber,
      providers: providers,
    );

    final providersToCreate =
        providers.where((p) => !existingProvidersSet.contains(p)).toList();

    if (providersToCreate.isEmpty) {
      throw const ValidationFailure(
        code: 'wallet-already-exists',
        technicalMessage:
            'A wallet already exists for this owner, provider, and phone number.',
      );
    }

    final batch = _firestore.batch();
    final List<WalletDto> createdWallets = [];
    final now = DateTime.now();

    for (final providerStr in providersToCreate) {
      final docRef = _firestore.collection('wallets').doc();
      final initialBalance = initialBalances[providerStr] ?? 0.0;
      final walletDto = WalletDto(
        id: docRef.id,
        phoneNumber: normalizedPhoneNumber,
        provider: WalletProvider.fromString(providerStr),
        deviceId: deviceId,
        ownerUid: currentUser.uid,
        currentBalance: initialBalance,
        totalReceived: 0.0,
        totalSent: 0.0,
        lastBalanceAt: now,
        createdAt: now,
      );
      batch.set(docRef, walletDto.toFirestore());
      createdWallets.add(walletDto);
    }

    await batch.commit();
    return createdWallets;
  }

  @override
  Future<void> deleteWallet(String walletId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in');
    }

    final walletRef = _firestore.collection('wallets').doc(walletId);
    final walletSnapshot = await walletRef.get();
    if (!walletSnapshot.exists) return;

    final wallet = WalletDto.fromFirestore(walletSnapshot);
    if (wallet.ownerUid != currentUser.uid) {
      throw const PermissionFailure(
        technicalMessage: 'Only the wallet owner can delete it.',
      );
    }

    final linksQuery = await _firestore
        .collectionGroup('wallets')
        .where('walletId', isEqualTo: walletId)
        .get();

    final workspaceIds = linksQuery.docs
        .map((doc) => doc.reference.parent.parent?.id)
        .whereType<String>()
        .toList();

    final referencesToDelete = <DocumentReference>[walletRef];

    for (final doc in linksQuery.docs) {
      referencesToDelete.add(doc.reference);
    }

    final txCollection = walletRef.collection('transactions');
    final transactions = await txCollection.get();

    for (final txDoc in transactions.docs) {
      referencesToDelete.add(txDoc.reference);
      final history = await txDoc.reference.collection('history').get();
      for (final h in history.docs) {
        referencesToDelete.add(h.reference);
      }
      final notes = await txDoc.reference.collection('notes').get();
      for (final n in notes.docs) {
        referencesToDelete.add(n.reference);
      }
    }

    await _deleteInBatches(referencesToDelete);

    for (final workspaceId in workspaceIds) {
      await _syncWorkspaceMetadata(workspaceId);
    }
  }

  @override
  Future<void> linkSubscriptionId({
    required String walletId,
    required int subscriptionId,
  }) async {
    await _firestore
        .collection('wallets')
        .doc(walletId)
        .update({'subscriptionId': subscriptionId});
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  Future<void> _deleteInBatches(List<DocumentReference> references) async {
    for (var i = 0; i < references.length; i += 450) {
      final batch = _firestore.batch();
      final end = (i + 450 > references.length) ? references.length : i + 450;
      for (final ref in references.sublist(i, end)) {
        batch.delete(ref);
      }
      await batch.commit();
    }
  }

  Future<void> _syncWorkspaceMetadata(String workspaceId) async {
    final workspaceRef = _firestore.collection('workspaces').doc(workspaceId);
    final walletsQuery = await workspaceRef.collection('wallets').get();
    final walletIds = walletsQuery.docs.map((doc) => doc.id).toList();

    if (walletIds.isEmpty) {
      await workspaceRef.update({'walletsCount': 0, 'latestActivityAt': null});
      return;
    }

    final snapshots = await Future.wait(
      walletIds.map((id) => _firestore.collection('wallets').doc(id).get()),
    );

    final wallets = snapshots
        .where((s) => s.exists)
        .map(WalletDto.fromFirestore)
        .toList();

    final latestActivityAt = wallets.isEmpty
        ? null
        : wallets
            .map((w) => w.lastBalanceAt)
            .reduce((a, b) => a.isAfter(b) ? a : b);

    await workspaceRef.update({
      'walletsCount': wallets.length,
      'latestActivityAt': latestActivityAt == null
          ? null
          : Timestamp.fromDate(latestActivityAt),
    });
  }

  Future<Set<String>> _findExistingProviders({
    required String ownerUid,
    required String normalizedPhoneNumber,
    required List<String> providers,
  }) async {
    final existingQuery = await _firestore
        .collection('wallets')
        .where('ownerUid', isEqualTo: ownerUid)
        .where('provider', whereIn: providers)
        .get();

    return existingQuery.docs
        .map(WalletDto.fromFirestore)
        .where(
          (wallet) =>
              EgyptianPhoneNumber.normalize(wallet.phoneNumber) ==
              normalizedPhoneNumber,
        )
        .map((wallet) => wallet.provider.toValue)
        .toSet();
  }
}
