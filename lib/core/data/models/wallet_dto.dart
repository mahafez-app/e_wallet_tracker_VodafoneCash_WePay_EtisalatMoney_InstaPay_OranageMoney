import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/enums/wallet_provider.dart';

final class WalletDto {
  const WalletDto({
    required this.id,
    required this.phoneNumber,
    required this.provider,
    required this.deviceId,
    required this.ownerUid,
    required this.currentBalance,
    required this.createdAt,
    required this.lastBalanceAt,
    this.totalReceived = 0.0,
    this.totalSent = 0.0,
  });

  final String id;
  final String phoneNumber;
  final String provider;
  final String deviceId;
  final String ownerUid;
  final double currentBalance;
  final double totalReceived;
  final double totalSent;
  final DateTime lastBalanceAt;
  final DateTime createdAt;

  factory WalletDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WalletDto(
      id: doc.id,
      phoneNumber: data['phoneNumber'] as String? ?? '',
      provider: data['provider'] as String? ?? 'unknown',
      deviceId: data['deviceId'] as String? ?? '',
      ownerUid: data['ownerUid'] as String? ?? '',
      currentBalance: (data['currentBalance'] as num?)?.toDouble() ?? 0.0,
      totalReceived: (data['totalReceived'] as num?)?.toDouble() ?? 0.0,
      totalSent: (data['totalSent'] as num?)?.toDouble() ?? 0.0,
      lastBalanceAt: (data['lastBalanceAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'phoneNumber': phoneNumber,
      'provider': provider,
      'deviceId': deviceId,
      'ownerUid': ownerUid,
      'currentBalance': currentBalance,
      'totalReceived': totalReceived,
      'totalSent': totalSent,
      'lastBalanceAt': Timestamp.fromDate(lastBalanceAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      phoneNumber: phoneNumber,
      provider: WalletProvider.fromString(provider),
      deviceId: deviceId,
      ownerUid: ownerUid,
      currentBalance: currentBalance,
      totalReceived: totalReceived,
      totalSent: totalSent,
      lastBalanceAt: lastBalanceAt,
      createdAt: createdAt,
    );
  }
}
