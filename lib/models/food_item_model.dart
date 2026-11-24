class FoodItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final int reviewsCount;
  final String categoryId;
  final String categoryName;
  final String imageUrl;
  final bool isAvailable;
  final bool isPopular;
  final bool isRecommended;
  final bool isTodaySpecial;
  final int prepTimeMinutes;
  final int calories;
  final List<String> availableAddons;

  FoodItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
    this.isAvailable = true,
    this.isPopular = false,
    this.isRecommended = false,
    this.isTodaySpecial = false,
    this.prepTimeMinutes = 15,
    this.calories = 350,
    this.availableAddons = const [],
  });

  FoodItemModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? rating,
    int? reviewsCount,
    String? categoryId,
    String? categoryName,
    String? imageUrl,
    bool? isAvailable,
    bool? isPopular,
    bool? isRecommended,
    bool? isTodaySpecial,
    int? prepTimeMinutes,
    int? calories,
    List<String>? availableAddons,
  }) {
    return FoodItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      isPopular: isPopular ?? this.isPopular,
      isRecommended: isRecommended ?? this.isRecommended,
      isTodaySpecial: isTodaySpecial ?? this.isTodaySpecial,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      calories: calories ?? this.calories,
      availableAddons: availableAddons ?? this.availableAddons,
    );
  }
}
