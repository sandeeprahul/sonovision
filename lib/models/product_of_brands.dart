class Product {
  final String id;
  final String name;
  final int price;
  final int? discountPercentage;
  final String category;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.discountPercentage,
    required this.category,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      name: json["name"],
      price: json["price"],
      discountPercentage: json["discountPercentage"],
      category: json["category"],
      images: List<String>.from(json["images"]),
    );
  }
}

class PriceRange {
  final int min;
  final int max;
  final String label;
  final String id;

  PriceRange({
    required this.min,
    required this.max,
    required this.label,
    required this.id,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: json["min"],
      max: json["max"],
      label: json["label"],
      id: json["_id"],
    );
  }
}

class Category {
  final String id;
  final String name;
  final String icon;
  final int sortOrder;
  final bool isActive;
  final List<PriceRange> priceRanges;
  final List<Product> products;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.sortOrder,
    required this.isActive,
    required this.priceRanges,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["_id"],
      name: json["name"],
      icon: json["icon"],
      sortOrder: json["sortOrder"],
      isActive: json["isActive"],
      priceRanges: (json["priceRanges"] as List)
          .map((e) => PriceRange.fromJson(e))
          .toList(),
      products:
      (json["products"] as List).map((e) => Product.fromJson(e)).toList(),
    );
  }
}

class Brand {
  final String id;
  final String name;
  final String icon;
  final List<Category> categories;

  Brand({
    required this.id,
    required this.name,
    required this.icon,
    required this.categories,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json["_id"],
      name: json["name"],
      icon: json["icon"],
      categories: (json["categories"] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
    );
  }
}
