import 'package:food_app/models/token_model.dart';
import 'package:food_app/models/transaction.dart';

class TransactionsResponse {
  final List<TransactionModel>? transactions;
  final String? error;

  TransactionsResponse({ this.transactions,  this.error});

  static TransactionsResponse fromJson(Map<String, dynamic> json) {
    return TransactionsResponse(
      transactions:
          (json['transactions'] as List).map((item) => TransactionModel.fromJson(item)).toList(),
    );
  }

  static TransactionsResponse withError(String error) {
    return TransactionsResponse(error: error);
  }
}
