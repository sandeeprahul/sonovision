class ProductDetailsDataFromBrandsCategory {
  final String id;
  final String name;
  final Brand brand;
  final double price;
  final int? discountPercentage;
  final String? description;
  final String? highlights;
  final String? deliveryTime;
  final bool isFeatured;
  final List<String> colors;
  final List<String> images;
  final int stock;
  final String? storeCode;
  final String? content;
  final bool isActive;
  final double finalPrice;
  final Category? category;
  final List<ProductFilter> filters;

  ProductDetailsDataFromBrandsCategory({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.discountPercentage,
    this.description,
    this.highlights,
    this.deliveryTime,
    required this.isFeatured,
    required this.colors,
    required this.images,
    required this.stock,
    this.storeCode,
    this.content,
    required this.isActive,
    required this.finalPrice,
    this.category,
    required this.filters,
  });

  factory ProductDetailsDataFromBrandsCategory.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return ProductDetailsDataFromBrandsCategory(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      brand: Brand.fromJson(json["brand"] ?? {}),
      price: _toDouble(json["price"]),
      discountPercentage: json["discountPercentage"] != null
          ? int.tryParse(json["discountPercentage"].toString())
          : null,
      description: json["description"],
      highlights: json["highlights"],
      deliveryTime: json["deliveryTime"],
      isFeatured: json["isFeatured"] ?? false,
      colors: List<String>.from(json["colors"] ?? []),
      images: List<String>.from(json["images"] ?? []),
      stock: json["stock"] ?? 0,
      storeCode: json["storeCode"],
      content: json["content"],
      isActive: json["isActive"] ?? true,
      finalPrice: _toDouble(json["finalPrice"]),
      category:
      json["category"] != null ? Category.fromJson(json["category"]) : null,
      filters: (json["filters"] as List<dynamic>?)
          ?.map((e) => ProductFilter.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Brand {
  final String id;
  final String name;

  Brand({
    required this.id,
    required this.name,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
    );
  }
}

class ProductFilter {
  final String id;
  final String key;
  final String value;
  final String valueId;

  ProductFilter({
    required this.id,
    required this.key,
    required this.value,
    required this.valueId,
  });

  factory ProductFilter.fromJson(Map<String, dynamic> json) {
    return ProductFilter(
      id: json["_id"] ?? "",
      key: json["key"] ?? "",
      value: json["value"] ?? "",
      valueId: json["valueId"] ?? "",
    );
  }
}
