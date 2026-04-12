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
    required String deviceId,
  });

  Future<List<WalletDto>> getWallets();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  const WalletRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
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

    final providersToCreate = providers
        .where((p) => !existingProvidersSet.contains(p))
        .toList();

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
      final walletDto = WalletDto(
        id: docRef.id,
        phoneNumber: normalizedPhoneNumber,
        provider: WalletProvider.fromString(providerStr),
        deviceId: deviceId,
        ownerUid: currentUser.uid,
        currentBalance: 0.0,
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
