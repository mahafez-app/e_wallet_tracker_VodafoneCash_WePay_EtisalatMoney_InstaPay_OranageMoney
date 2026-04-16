import 'package:equatable/equatable.dart';

/// Represents a failed SMS processing attempt that needs to be retried.
/// 
/// We store the raw SMS data because failures can happen before parsing
/// or wallet resolution.
final class PendingSmsRetryItem extends Equatable {
  const PendingSmsRetryItem({
    required this.id,
    required this.sender,
    required this.body,
    required this.smsReceivedAt,
    required this.userUid,
    required this.createdAt,
    required this.updatedAt,
    this.subscriptionId,
    this.walletId,
    this.providerName,
    this.retryCount = 0,
    this.lastError,
  });

  final String id;
  final String sender;
  final String body;
  final DateTime smsReceivedAt;
  final String userUid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? subscriptionId;
  final String? walletId;
  final String? providerName;
  final int retryCount;
  final String? lastError;

  @override
  List<Object?> get props => [
        id,
        sender,
        body,
        smsReceivedAt,
        userUid,
        createdAt,
        updatedAt,
        subscriptionId,
        walletId,
        providerName,
        retryCount,
        lastError,
      ];

  PendingSmsRetryItem copyWith({
    String? sender,
    String? body,
    DateTime? smsReceivedAt,
    String? userUid,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? subscriptionId,
    String? walletId,
    String? providerName,
    int? retryCount,
    String? lastError,
  }) {
    return PendingSmsRetryItem(
      id: id,
      sender: sender ?? this.sender,
      body: body ?? this.body,
      smsReceivedAt: smsReceivedAt ?? this.smsReceivedAt,
      userUid: userUid ?? this.userUid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      walletId: walletId ?? this.walletId,
      providerName: providerName ?? this.providerName,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'body': body,
      'smsReceivedAt': smsReceivedAt.toIso8601String(),
      'userUid': userUid,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'subscriptionId': subscriptionId,
      'walletId': walletId,
      'providerName': providerName,
      'retryCount': retryCount,
      'lastError': lastError,
    };
  }

  factory PendingSmsRetryItem.fromJson(Map<String, dynamic> json) {
    return PendingSmsRetryItem(
      id: json['id'] as String,
      sender: json['sender'] as String,
      body: json['body'] as String,
      smsReceivedAt: DateTime.parse(json['smsReceivedAt'] as String),
      userUid: json['userUid'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      subscriptionId: json['subscriptionId'] as int?,
      walletId: json['walletId'] as String?,
      providerName: json['providerName'] as String?,
      retryCount: json['retryCount'] as int? ?? 0,
      lastError: json['lastError'] as String?,
    );
  }
}
