import 'package:flutter/material.dart';
import 'package:food_app/models/extra.dart';
import 'package:food_app/models/instruction.dart';
import 'package:food_app/models/order.dart';
import 'package:food_app/models/food.dart';
import 'package:food_app/services/db.dart';
import 'package:food_app/utils/funcs.dart';

class OrderService extends ChangeNotifier {
  final List<OrderModel> _orders = [];
  final DatabaseService _dbHelper = DatabaseService();
  bool _isLoading = false;
  String? _lastError;

  List<OrderModel> get orders => List.unmodifiable(_orders);

  bool get isLoading => _isLoading;

  String? get lastError => _lastError;

  static final OrderService _instance = OrderService._internal();

  factory OrderService() => _instance;

  OrderService._internal();

  Future<void> initialize() async {
    await loadOrders();
  }

  Future<void> loadOrders() async {
    await _performDatabaseOperation(() async {
      _isLoading = true;
      notifyListeners();

      final orders = await _dbHelper.getAllOrders();

      _orders
        ..clear()
        ..addAll(orders);

      _lastError = null;
    }, 'Failed to load orders');
  }

  Future<void> addOrder({
    required FoodModel food,
    required SizeModel selectedSize,
    required int quantity,
    required List<ExtraModel> extras,
    required List<InstructionModel> instructions,
  }) async {
    OrderModel order = OrderModel(
      uuid: randomString(10),
      food: food,
      status: OrderStatus.pending,
      createdTime: DateTime.now(),
      quantity: quantity,
      extras: extras,
      instructions: instructions,
    );
    await _performDatabaseOperation(() async {
      await _dbHelper.insertOrder(order, selectedSize);
      _orders.add(order);
      _lastError = null;
    }, 'Failed to add order');
  }

  Future<void> updateOrder(OrderModel updatedOrder) async {
    await _performDatabaseOperation(() async {
      final index = _orders.indexWhere((o) => o.uuid == updatedOrder.uuid);
      if (index == -1) throw Exception('Order not found');

      await _dbHelper.updateOrder(updatedOrder);
      _orders[index] = updatedOrder;
      _lastError = null;
    }, 'Failed to update order');
  }

  Future<void> removeOrder(String uuid, String foodUUID) async {
    await _performDatabaseOperation(() async {
      await _dbHelper.deleteOrder(uuid, foodUUID);
      _orders.removeWhere((o) => o.uuid == uuid);
      _lastError = null;
    }, 'Failed to remove order');
  }

  Future<void> clearAllOrders() async {
    await _performDatabaseOperation(() async {
      await _dbHelper.clearAllOrders();
      _orders.clear();
      _lastError = null;
    }, 'Failed to clear orders');
  }

  Future<void> updateOrderStatus(String uuid, String newStatus) async {
    await _performDatabaseOperation(() async {
      final index = _orders.indexWhere((o) => o.uuid == uuid);
      if (index == -1) throw Exception('Order not found');

      final updatedOrder = _orders[index].copyWith(
        status: OrderStatusConverter().fromJson(newStatus),
      );
      await _dbHelper.updateOrder(updatedOrder);
      _orders[index] = updatedOrder;
      _lastError = null;
    }, 'Failed to update order status');
  }

  Future<void> _performDatabaseOperation(
    Future<void> Function() operation,
    String errorMessage,
  ) async {
    try {
      await operation();
      notifyListeners();
    } catch (e) {
      _lastError = '$errorMessage: ${e.toString()}';
      debugPrint(_lastError);
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
    }
  }
}
