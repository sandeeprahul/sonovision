class HomeScreenModel {
  final List<BannerModel> banners;
  final List<ProductModel> trendingProducts;
  final List<CategoryModel> popularCategories;
  final List<ProductModel> weeklyBestSellers;
  final FlashDealModel flashDeal;

  HomeScreenModel({
    required this.banners,
    required this.trendingProducts,
    required this.popularCategories,
    required this.weeklyBestSellers,
    required this.flashDeal,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) {
    return HomeScreenModel(
      banners: (json['widgets'] as List)
          .where((widget) => widget['widgetType'] == 'banners')
          .expand((widget) => (widget['data'] as List)
              .map((banner) => BannerModel.fromJson(banner)))
          .toList(),
      trendingProducts: (json['widgets'] as List)
          .where((widget) =>
              widget['widgetType'] == 'group' &&
              widget['type'] == 'product' &&
              widget['label'] == 'Trending Products')
          .expand((widget) => (widget['data'] as List)
              .map((product) => ProductModel.fromJson(product)))
          .toList(),
      popularCategories: (json['widgets'] as List)
          .where((widget) =>
              widget['widgetType'] == 'group' &&
              widget['type'] == 'category' &&
              widget['label'] == 'Popular Categories')
          .expand((widget) => (widget['data'] as List)
              .map((category) => CategoryModel.fromJson(category)))
          .toList(),
      weeklyBestSellers: (json['widgets'] as List)
          .where((widget) =>
              widget['widgetType'] == 'group' &&
              widget['type'] == 'product' &&
              widget['label'] == 'Weekly Best Sellers')
          .expand((widget) => (widget['data'] as List)
              .map((product) => ProductModel.fromJson(product)))
          .toList(),
      flashDeal: FlashDealModel.fromJson(
        (json['widgets'] as List)
            .firstWhere((widget) => widget['widgetType'] == 'sale')['data'],
      ),
    );
  }
}

class BannerModel {
  final String image;
  final String title;
  final String subtitle;
  final String type;
  final String targetId;

  BannerModel({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.targetId,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      image: json['image'],
      title: json['title'],
      subtitle: json['subtitle'],
      type: json['type'],
      targetId: json['targetId'],
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String price;
  final String originalPrice;
  final String image;
  final double rating;
  final int reviews;
  final bool isNew;
  final bool isBestSeller;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.image,
    required this.rating,
    required this.reviews,
    this.isNew = false,
    this.isBestSeller = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      originalPrice: json['originalPrice'],
      image: json['image'],
      rating: json['rating']?.toDouble() ?? 0.0,
      reviews: json['reviews'] ?? 0,
      isNew: json['isNew'] ?? false,
      isBestSeller: json['isBestSeller'] ?? false,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String image;
  final String color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.image,
    required this.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      image: json['image'],
      color: json['color'],
    );
  }
}

class FlashDealModel {
  final String image;
  final String title;
  final String subtitle;
  final DateTime endTime;
  final List<ProductModel> products;

  FlashDealModel({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.endTime,
    required this.products,
  });

  factory FlashDealModel.fromJson(Map<String, dynamic> json) {
    return FlashDealModel(
      image: json['image'],
      title: json['title'],
      subtitle: json['subtitle'],
      endTime: DateTime.parse(json['endTime']),
      products: (json['products'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList(),
    );
  }
} 