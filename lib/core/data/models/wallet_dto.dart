import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/enums/wallet_provider.dart';

final class WalletDto extends WalletEntity {
  const WalletDto({
    required super.id,
    required super.phoneNumber,
    required super.provider,
    required super.deviceId,
    required super.ownerUid,
    required super.currentBalance,
    required super.createdAt,
    required super.lastBalanceAt,
    super.totalReceived = 0.0,
    super.totalSent = 0.0,
    super.subscriptionId,
  });

  factory WalletDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WalletDto(
      id: doc.id,
      phoneNumber: data['phoneNumber'] as String? ?? '',
      provider: WalletProvider.fromString(
        data['provider'] as String? ?? 'unknown',
      ),
      deviceId: data['deviceId'] as String? ?? '',
      ownerUid: data['ownerUid'] as String? ?? '',
      currentBalance: (data['currentBalance'] as num?)?.toDouble() ?? 0.0,
      totalReceived: (data['totalReceived'] as num?)?.toDouble() ?? 0.0,
      totalSent: (data['totalSent'] as num?)?.toDouble() ?? 0.0,
      lastBalanceAt:
          (data['lastBalanceAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      subscriptionId: data['subscriptionId'] as int?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'phoneNumber': phoneNumber,
      'provider': provider.name,
      'deviceId': deviceId,
      'ownerUid': ownerUid,
      'currentBalance': currentBalance,
      'totalReceived': totalReceived,
      'totalSent': totalSent,
      'lastBalanceAt': Timestamp.fromDate(lastBalanceAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'subscriptionId': subscriptionId,
    };
  }

  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      phoneNumber: phoneNumber,
      provider: provider,
      deviceId: deviceId,
      ownerUid: ownerUid,
      currentBalance: currentBalance,
      totalReceived: totalReceived,
      totalSent: totalSent,
      lastBalanceAt: lastBalanceAt,
      createdAt: createdAt,
      subscriptionId: subscriptionId,
    );
  }
}
