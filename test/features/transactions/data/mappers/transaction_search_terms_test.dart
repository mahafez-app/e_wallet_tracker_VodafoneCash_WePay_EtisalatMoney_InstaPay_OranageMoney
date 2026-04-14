import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_tracker/features/transactions/data/mappers/transaction_search_terms.dart';

void main() {
  group('TransactionSearchTerms', () {
    test('normalizes digits only', () {
      expect(
        TransactionSearchTerms.normalizeDigits('+20 101-234-5678'),
        '201012345678',
      );
    });

    test('builds suffixes from length three to full number', () {
      expect(
        TransactionSearchTerms.counterpartySuffixes('01012345678'),
        <String>[
          '678',
          '5678',
          '45678',
          '345678',
          '2345678',
          '12345678',
          '012345678',
          '1012345678',
          '01012345678',
        ],
      );
    });

    test('returns empty suffixes for short numbers', () {
      expect(TransactionSearchTerms.counterpartySuffixes('12'), isEmpty);
    });
  });
}
