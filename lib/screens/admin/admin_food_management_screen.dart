import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../models/food_item_model.dart';
import '../../providers/food_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AdminFoodManagementScreen extends StatelessWidget {
  const AdminFoodManagementScreen({super.key});

  void _showAddEditFoodDialog(BuildContext context, {FoodItemModel? existingItem}) {
    final foodProvider = Provider.of<FoodProvider>(context, listen: false);

    final isEditing = existingItem != null;
    final nameCtrl = TextEditingController(text: existingItem?.name ?? '');
    final descCtrl = TextEditingController(text: existingItem?.description ?? '');
    final priceCtrl = TextEditingController(text: existingItem?.price.toStringAsFixed(0) ?? '');
    final imageCtrl = TextEditingController(
        text: existingItem?.imageUrl ??
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80');
    final prepCtrl = TextEditingController(text: existingItem?.prepTimeMinutes.toString() ?? '15');
    final calCtrl = TextEditingController(text: existingItem?.calories.toString() ?? '350');

    String selectedCategory = existingItem?.categoryId ?? 'burgers';
    String selectedCategoryName = existingItem?.categoryName ?? 'Burgers';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Food Item' : 'Add New Food Item',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CustomTextField(label: 'Food Name', controller: nameCtrl),
                const SizedBox(height: 12),
                CustomTextField(label: 'Description', controller: descCtrl, maxLines: 2),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Price (PKR)',
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        label: 'Prep Time (Mins)',
                        controller: prepCtrl,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CustomTextField(label: 'Image URL', controller: imageCtrl),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: foodProvider.categories
                      .where((c) => c.id != 'all')
                      .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      selectedCategory = val;
                      selectedCategoryName =
                          foodProvider.categories.firstWhere((c) => c.id == val).name;
                    }
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: isEditing ? 'Update Item' : 'Save Food Item',
                  onPressed: () {
                    final price = double.tryParse(priceCtrl.text) ?? 0.0;
                    final prep = int.tryParse(prepCtrl.text) ?? 15;
                    final cal = int.tryParse(calCtrl.text) ?? 350;

                    if (isEditing) {
                      final updated = existingItem.copyWith(
                        name: nameCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        price: price,
                        imageUrl: imageCtrl.text.trim(),
                        categoryId: selectedCategory,
                        categoryName: selectedCategoryName,
                        prepTimeMinutes: prep,
                        calories: cal,
                      );
                      foodProvider.updateFoodItem(updated);
                    } else {
                      final newItem = FoodItemModel(
                        id: 'food_${DateTime.now().millisecondsSinceEpoch}',
                        name: nameCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        price: price,
                        rating: 4.8,
                        reviewsCount: 1,
                        categoryId: selectedCategory,
                        categoryName: selectedCategoryName,
                        imageUrl: imageCtrl.text.trim(),
                        prepTimeMinutes: prep,
                        calories: cal,
                      );
                      foodProvider.addFoodItem(newItem);
                    }
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final items = foodProvider.allFoodItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Food Menu Management'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditFoodDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Food Item', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final food = items[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      food.imageUrl,
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        height: 70,
                        width: 70,
                        color: AppColors.surfaceLight,
                        child: const Icon(Icons.fastfood, color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'PKR ${food.price.toStringAsFixed(0)} • ${food.categoryName}',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              food.isAvailable ? 'Available' : 'Unavailable',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: food.isAvailable ? AppColors.successGreen : AppColors.errorRed,
                              ),
                            ),
                            Switch(
                              value: food.isAvailable,
                              activeTrackColor: AppColors.successGreen,
                              onChanged: (val) {
                                foodProvider.toggleAvailability(food.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.secondary, size: 20),
                        onPressed: () => _showAddEditFoodDialog(context, existingItem: food),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.errorRed, size: 20),
                        onPressed: () {
                          foodProvider.deleteFoodItem(food.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
