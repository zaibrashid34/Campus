import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../services/mock_data.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  List<OrderModel> get activeOrders => _orders
      .where((order) =>
          order.status != OrderStatus.delivered &&
          order.status != OrderStatus.cancelled)
      .toList();

  List<OrderModel> get pastOrders => _orders
      .where((order) =>
          order.status == OrderStatus.delivered ||
          order.status == OrderStatus.cancelled)
      .toList();

  OrderProvider() {
    // Populate sample initial order for testing & UI presentation
    final mockFoods = MockData.foodItems;
    if (mockFoods.isNotEmpty) {
      _orders.add(
        OrderModel(
          id: 'ORD-89412',
          orderDate: DateTime.now().subtract(const Duration(minutes: 25)),
          items: [
            CartItemModel(
              foodItem: mockFoods[0], // Classic Zinger Burger
              quantity: 2,
            ),
            CartItemModel(
              foodItem: mockFoods[2], // Loaded Masala Fries
              quantity: 1,
            ),
          ],
          subtotal: 1150.0,
          deliveryFee: 50.0,
          total: 1200.0,
          status: OrderStatus.preparing,
          customerName: 'Ali Hassan',
          phone: '+923001234567',
          campusName: 'Main Campus',
          buildingDepartment: 'Computer Science Dept - Lab 3',
          pickupLocation: 'Main Library Plaza',
          paymentMethod: 'Cash on Delivery',
        ),
      );
    }
  }

  OrderModel placeOrder({
    required List<CartItemModel> cartItems,
    required double subtotal,
    required double deliveryFee,
    required double total,
    required String customerName,
    required String phone,
    required String campusName,
    required String buildingDepartment,
    required String pickupLocation,
    required String instructions,
    required String paymentMethod,
  }) {
    final newOrder = OrderModel(
      id: 'ORD-${(10000 + (DateTime.now().millisecondsSinceEpoch % 89999))}',
      orderDate: DateTime.now(),
      items: List.from(cartItems),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      total: total,
      status: OrderStatus.placed,
      customerName: customerName,
      phone: phone,
      campusName: campusName,
      buildingDepartment: buildingDepartment,
      pickupLocation: pickupLocation,
      instructions: instructions,
      paymentMethod: paymentMethod,
    );

    _orders.insert(0, newOrder);
    notifyListeners();
    return newOrder;
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (_) {
      return null;
    }
  }
}
