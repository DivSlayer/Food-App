import 'package:flutter/material.dart';
import 'package:food_app/models/address.dart';
import 'package:food_app/models/transaction.dart';
import 'package:food_app/resource/server_resource.dart';
import 'package:food_app/response_models/transaction_response.dart';
import 'package:food_app/utils/funcs.dart';

class TransactionService extends ChangeNotifier {
  final List<TransactionModel> transactionsList = [];
  final ServerResource _serverResource = ServerResource();
  static final TransactionService _instance = TransactionService._internal();

  factory TransactionService() {
    return _instance;
  }

  TransactionService._internal();

  Future<void> addTransaction({
    required TransactionModel transaction,
    required AddressModel address,
  }) async {
    try {
      print('inside transaction service: ${transaction.orders.length}');
      TransactionModel newTransaction = TransactionModel(
        orders: transaction.orders,
        totalPrice: calculatePrice(transaction.orders),
        serial: 1,
        paidTime: DateTime.now().toUtc(),
        status: TransactionStatus.pending,
        totalDuration: transaction.orders.fold(
          0,
          (prev, element) => prev + (element.food.preparationTime),
        ),
        deliveryCode: transaction.deliveryCode,
        changedAt: DateTime.now().toUtc(),
      );
      TransactionsResponse res = await _serverResource.addTransaction(
        newTransaction.toJson(),
        address,
      );
      if (res.transactions != null && res.error == null) {
        transactionsList.clear();
        transactionsList.addAll(res.transactions!);
      }
      notifyListeners();
    } catch (e) {
      // Handle errors appropriately
      print('Error adding food to order: $e');
    }
  }

  void removeTransaction(int serial) {
    try {
      transactionsList.removeWhere((transaction) => transaction.serial == serial);
      _serverResource.removeTransaction(serial);
      notifyListeners();
    } catch (e) {
      // Handle errors appropriately
      print('Error removing food from order: $e');
    }
  }

  Future<void> getTransactions() async {
    try {
      TransactionsResponse res = await _serverResource.getTransaction([]);
      transactionsList.clear();
      notifyListeners();
      transactionsList.addAll(res.transactions ?? []);
      notifyListeners();
    } catch (e) {
      // Handle errors appropriately
      print('Error fetching orders: $e');
    }
  }
}
