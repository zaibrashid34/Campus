import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../models/food_item_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/custom_button.dart';

class FoodDetailsScreen extends StatefulWidget {
  final FoodItemModel foodItem;

  const FoodDetailsScreen({
    super.key,
    required this.foodItem,
  });

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int _quantity = 1;
  final TextEditingController _instructionsController = TextEditingController();
  final List<String> _selectedAddons = [];

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final totalPrice = widget.foodItem.price * _quantity;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero Image AppBar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.foodItem.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.surfaceLight,
                        child: const Icon(Icons.fastfood, size: 80, color: AppColors.primary),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details Body
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge & Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.foodItem.isAvailable
                                ? AppColors.successGreen.withOpacity(0.15)
                                : AppColors.errorRed.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.foodItem.isAvailable ? 'AVAILABLE NOW' : 'OUT OF STOCK',
                            style: TextStyle(
                              color: widget.foodItem.isAvailable
                                  ? AppColors.successGreen
                                  : AppColors.errorRed,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.foodItem.rating}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              ' (${widget.foodItem.reviewsCount} reviews)',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Food Title
                    Text(
                      widget.foodItem.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Category & Prep Time Row
                    Row(
                      children: [
                        Chip(
                          avatar: const Icon(Icons.label, size: 14, color: AppColors.primary),
                          label: Text(widget.foodItem.categoryName),
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.timer_outlined, size: 16, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.foodItem.prepTimeMinutes} mins prep',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.local_fire_department_outlined,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.foodItem.calories} kcal',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Price & Quantity Selector Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Price',
                              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                            Text(
                              'PKR ${widget.foodItem.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        // Quantity Controls
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderGrey),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 20),
                                onPressed: _decrement,
                                color: AppColors.primary,
                              ),
                              Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 20),
                                onPressed: _increment,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.foodItem.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Addons / Customizations
                    if (widget.foodItem.availableAddons.isNotEmpty) ...[
                      const Text(
                        'Customize Your Order',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: widget.foodItem.availableAddons.map((addon) {
                          final isSelected = _selectedAddons.contains(addon);
                          return CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            activeColor: AppColors.primary,
                            title: Text(addon, style: const TextStyle(fontSize: 14)),
                            value: isSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedAddons.add(addon);
                                } else {
                                  _selectedAddons.remove(addon);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Special Instructions
                    const Text(
                      'Special Instructions (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _instructionsController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Less spicy, extra sauce on the side, no onions...',
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Price',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    Text(
                      'PKR ${totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomButton(
                  text: 'Add to Cart',
                  icon: Icons.add_shopping_cart,
                  onPressed: widget.foodItem.isAvailable
                      ? () {
                          cartProvider.addToCart(
                            widget.foodItem,
                            quantity: _quantity,
                            specialInstructions: _instructionsController.text.trim(),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added $_quantity x ${widget.foodItem.name} to cart!'),
                              backgroundColor: AppColors.successGreen,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
