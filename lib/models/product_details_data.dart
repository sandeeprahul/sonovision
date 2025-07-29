class ProductDetailsData {
  final String id;
  final String name;
  final String brand;
  final String categoryId;
  final double price;
  final int discountPercentage;
  final String description;
  final bool isActive;
  final String highlights;
  final List<String> colors;
  final List<String> images;
  final int stock;
  final String storeCode;
  final Map<String, dynamic> specifications;
  final String content;


  ProductDetailsData({
    required this.id,
    required this.name,
    required this.brand,
    required this.categoryId,
    required this.price,
    required this.discountPercentage,
    required this.description,
    required this.highlights,
    required this.colors,
    required this.isActive,
    required this.images,
    required this.stock,
    required this.storeCode,
    required this.specifications,
    required this.content,
  });

  factory ProductDetailsData.fromJson(Map<String, dynamic> json) {
    return ProductDetailsData(
      id: json['_id'],
      name: json['name'],
      isActive: json['isActive']??false,
      brand: json['brand'],
      categoryId: json['categoryId'],
      price: (json['price'] ?? 0).toDouble(),
      discountPercentage: json['discountPercentage'] ?? 0,
      description: json['description'] ?? '',
      highlights: json['highlights'] ?? '',
      colors: List<String>.from(json['colors'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      stock: json['stock'] ?? 0,
      storeCode: json['storeCode'] ?? '',
      specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'discountPercentage': discountPercentage,
      'images': images,
      'description': description,
      'highlights': highlights,
      'specifications': specifications,
    };
  }
}
