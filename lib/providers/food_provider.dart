import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/food_item_model.dart';
import '../services/mock_data.dart';

class FoodProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  List<FoodItemModel> _foodItems = [];
  String _selectedCategoryId = 'all';
  String _searchQuery = '';

  FoodProvider() {
    _categories = MockData.categories;
    _foodItems = MockData.foodItems;
  }

  List<CategoryModel> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;

  List<FoodItemModel> get allFoodItems => _foodItems;

  List<FoodItemModel> get filteredFoodItems {
    return _foodItems.where((item) {
      final matchesCategory = _selectedCategoryId == 'all' || item.categoryId == _selectedCategoryId;
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.categoryName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<FoodItemModel> get popularFoodItems =>
      _foodItems.where((item) => item.isPopular).toList();

  List<FoodItemModel> get recommendedFoodItems =>
      _foodItems.where((item) => item.isRecommended).toList();

  List<FoodItemModel> get todaysSpecialItems =>
      _foodItems.where((item) => item.isTodaySpecial).toList();

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  FoodItemModel? getFoodById(String id) {
    try {
      return _foodItems.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  // Admin Food Management Actions
  void addFoodItem(FoodItemModel item) {
    _foodItems.add(item);
    notifyListeners();
  }

  void updateFoodItem(FoodItemModel updatedItem) {
    final index = _foodItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _foodItems[index] = updatedItem;
      notifyListeners();
    }
  }

  void deleteFoodItem(String id) {
    _foodItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void toggleAvailability(String id) {
    final index = _foodItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _foodItems[index];
      _foodItems[index] = item.copyWith(isAvailable: !item.isAvailable);
      notifyListeners();
    }
  }
}
