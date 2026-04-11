import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/transaction_entity.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import '../../providers/transactions_providers.dart';

final transactionsControllerProvider =
    AsyncNotifierProvider.autoDispose.family<
      TransactionsController,
      List<TransactionEntity>,
      String?
    >(TransactionsController.new);

class TransactionsController extends AsyncNotifier<List<TransactionEntity>> {
  TransactionsController(this._walletId);

  final String? _walletId;

  @override
  Future<List<TransactionEntity>> build() async {
    final result = await ref.read(getTransactionsUseCaseProvider)(
      GetTransactionsParams(walletId: _walletId),
    );

    return result.fold(
      (failure) => throw failure,
      (transactions) => transactions,
    );
  }
}
