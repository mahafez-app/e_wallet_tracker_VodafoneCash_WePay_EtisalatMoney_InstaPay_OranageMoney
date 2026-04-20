import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_tracker/core/domain/enums/transaction_type.dart';
import 'package:wallet_tracker/core/utils/sms/parsers/vodafone_cash_sms_parser.dart';

void main() {
  const parser = VodafoneCashSmsParser();
  final now = DateTime(2026, 4, 20, 12);

  test('ignores insufficient balance alerts', () {
    final result = parser.parse(
      'لا يوجد رصيد كاف في حسابك. يمكنك تحويل 3652 جنية فقط بعد خصم 15 ج رسوم تحويل; رقم العملية 019289183176',
      now,
    );

    expect(result, isNull);
  });

  test('parses successful send sms', () {
    final result = parser.parse(
      'تم تحويل 6750 جنيه لرقم 01020565524 مصاريف الخدمة 1 جنيه '
      'رصيد حسابك فى فودافون كاش الحالي 7462.66. '
      'تاريخ العملية: 16:23 26-04-20 رقم العملية: 019320913232',
      now,
    );

    expect(result, isNotNull);
    expect(result!.type, TransactionType.send);
    expect(result.amount, 6750);
    expect(result.counterpartyNumber, '01020565524');
    expect(result.balance, 7462.66);
  });
}
