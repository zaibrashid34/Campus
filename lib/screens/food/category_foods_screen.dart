import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/food_provider.dart';
import '../../widgets/food_card.dart';
import 'food_details_screen.dart';

class CategoryFoodsScreen extends StatelessWidget {
  final String categoryId;
  final String? categoryTitle;

  const CategoryFoodsScreen({
    super.key,
    required this.categoryId,
    this.categoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final foods = categoryId == 'all'
        ? foodProvider.allFoodItems
        : foodProvider.allFoodItems.where((f) => f.categoryId == categoryId).toList();

    final title = categoryTitle ??
        (categoryId == 'all'
            ? 'All Food Items'
            : foodProvider.categories
                .firstWhere(
                  (c) => c.id == categoryId,
                  orElse: () => foodProvider.categories.first,
                )
                .name);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: foods.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.no_meals,
                      size: 64,
                      color: AppColors.textMuted.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No food items available in this category',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return FoodCard(
                    foodItem: food,
                    isHorizontal: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FoodDetailsScreen(foodItem: food),
                        ),
                      );
                    },
                    onAddToCart: () {
                      cartProvider.addToCart(food);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${food.name} added to cart!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
