import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/food_provider.dart';
import '../../services/mock_data.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/food_card.dart';
import '../../widgets/promo_banner.dart';
import '../../widgets/section_header.dart';
import '../food/category_foods_screen.dart';
import '../food/food_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedLocation = AppConstants.campusLocations.first;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showLocationPicker(BuildContext context, AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Campus Pickup / Delivery Spot',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              ...AppConstants.campusLocations.map((location) {
                final isSelected = location == _selectedLocation;
                return ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                  ),
                  title: Text(
                    location,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textDark,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedLocation = location;
                    });
                    authProvider.updateProfile(
                      fullName: authProvider.currentUser?.fullName ?? 'User',
                      phone: authProvider.currentUser?.phone ?? '',
                      preferredLocation: location,
                    );
                    Navigator.of(ctx).pop();
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final foodProvider = Provider.of<FoodProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final user = authProvider.currentUser;
    final userName = user?.fullName.split(' ').first ?? 'Student';

    final categories = foodProvider.categories;
    final popularFoods = foodProvider.popularFoodItems;
    final recommendedFoods = foodProvider.recommendedFoodItems;
    final todaysSpecials = foodProvider.todaysSpecialItems;
    final filteredFoods = foodProvider.filteredFoodItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
          },
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              // Top Header Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.primary.withOpacity(0.2),
                                child: Text(
                                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello, $userName 👋',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _showLocationPicker(context, authProvider),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          user?.preferredLocation ?? _selectedLocation,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 16,
                                          color: AppColors.primary,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Notification Icon with Badge
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_outlined, size: 28),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('No new campus announcements'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  height: 9,
                                  width: 9,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search Bar
                      TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          foodProvider.setSearchQuery(val);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search burgers, biryani, drinks...',
                          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: AppColors.textMuted),
                                  onPressed: () {
                                    _searchController.clear();
                                    foodProvider.setSearchQuery('');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Promotional Banner
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 160,
                  child: PageView.builder(
                    itemCount: MockData.promoBanners.length,
                    itemBuilder: (context, index) {
                      final banner = MockData.promoBanners[index];
                      return PromoBanner(
                        title: banner['title']!,
                        subtitle: banner['subtitle']!,
                        code: banner['code']!,
                        backgroundColor: index == 0
                            ? AppColors.primary
                            : (index == 1 ? AppColors.secondary : const Color(0xFF9C27B0)),
                      );
                    },
                  ),
                ),
              ),

              // Categories Horizontal Scroll
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Food Categories'),
                    SizedBox(
                      height: 48,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          final isSelected = category.id == foodProvider.selectedCategoryId;
                          return CategoryChip(
                            category: category,
                            isSelected: isSelected,
                            onTap: () {
                              foodProvider.selectCategory(category.id);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Search Filtered view or Categorized Home View
              if (foodProvider.searchQuery.isNotEmpty || foodProvider.selectedCategoryId != 'all') ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Search Results (${filteredFoods.length})',
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final food = filteredFoods[index];
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
                                action: SnackBarAction(
                                  label: 'VIEW CART',
                                  textColor: Colors.amber,
                                  onPressed: () {},
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: filteredFoods.length,
                    ),
                  ),
                ),
              ] else ...[
                // Popular Food Items
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SectionHeader(
                        title: 'Popular Food Items 🔥',
                        actionText: 'See All',
                        onActionTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CategoryFoodsScreen(categoryId: 'all'),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: popularFoods.length,
                          itemBuilder: (context, index) {
                            final food = popularFoods[index];
                            return FoodCard(
                              foodItem: food,
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
                    ],
                  ),
                ),

                // Today's Special
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SectionHeader(title: "Today's Special ⭐"),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: todaysSpecials.length,
                          itemBuilder: (context, index) {
                            final food = todaysSpecials[index];
                            return FoodCard(
                              foodItem: food,
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
                    ],
                  ),
                ),

                // Recommended For You (Vertical List)
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Recommended For You 💡',
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final food = recommendedFoods[index];
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
                      childCount: recommendedFoods.length,
                    ),
                  ),
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}
