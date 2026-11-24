import 'food_item_model.dart';

class CartItemModel {
  final FoodItemModel foodItem;
  int quantity;
  String specialInstructions;
  List<String> selectedAddons;

  CartItemModel({
    required this.foodItem,
    this.quantity = 1,
    this.specialInstructions = '',
    this.selectedAddons = const [],
  });

  double get totalPrice {
    return foodItem.price * quantity;
  }
}
