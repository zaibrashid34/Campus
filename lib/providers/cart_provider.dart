import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/food_item_model.dart';
import '../constants/app_constants.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee {
    if (_items.isEmpty) return 0.0;
    return subtotal > 1000 ? 0.0 : AppConstants.defaultDeliveryFee;
  }

  double get totalBill {
    return subtotal + deliveryFee;
  }

  void addToCart(FoodItemModel foodItem, {int quantity = 1, String specialInstructions = ''}) {
    final existingIndex = _items.indexWhere((item) => item.foodItem.id == foodItem.id);
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
      if (specialInstructions.isNotEmpty) {
        _items[existingIndex].specialInstructions = specialInstructions;
      }
    } else {
      _items.add(CartItemModel(
        foodItem: foodItem,
        quantity: quantity,
        specialInstructions: specialInstructions,
      ));
    }
    notifyListeners();
  }

  void incrementQuantity(String foodId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String foodId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(String foodId) {
    _items.removeWhere((item) => item.foodItem.id == foodId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
