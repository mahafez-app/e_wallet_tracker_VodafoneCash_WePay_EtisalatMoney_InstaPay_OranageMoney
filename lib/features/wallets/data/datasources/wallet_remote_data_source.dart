import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/data/models/wallet_dto.dart';
import '../../../../core/error/failures.dart';

abstract interface class WalletRemoteDataSource {
  Future<List<WalletDto>> addWallets({
    required String phoneNumber,
    required List<String> providerStrs,
    required String deviceId,
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
  Future<List<WalletDto>> addWallets({
    required String phoneNumber,
    required List<String> providerStrs,
    required String deviceId,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw const UnknownFailure(technicalMessage: 'User is not logged in');
    }

    // Check for existing wallets to prevent duplicates
    final existingQuery = await _firestore
        .collection('wallets')
        .where('ownerUid', isEqualTo: currentUser.uid)
        .where('phoneNumber', isEqualTo: phoneNumber)
        .where('provider', whereIn: providerStrs)
        .get();

    final existingProvidersSet = existingQuery.docs
        .map((doc) => doc.data()['provider'] as String)
        .toSet();

    final providersToCreate = providerStrs
        .where((p) => !existingProvidersSet.contains(p))
        .toList();

    if (providersToCreate.isEmpty) {
      throw const ValidationFailure(
        code: 'wallet-all-exists',
        technicalMessage: 'All selected wallets already exist for this number.',
      );
    }

    final batch = _firestore.batch();
    final List<WalletDto> createdWallets = [];
    final now = DateTime.now();

    for (final providerStr in providersToCreate) {
      final docRef = _firestore.collection('wallets').doc();
      final walletDto = WalletDto(
        id: docRef.id,
        phoneNumber: phoneNumber,
        provider: providerStr,
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
}
