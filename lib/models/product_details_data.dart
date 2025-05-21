class ProductDetailsData {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double discountPercentage;
  final List<String> images;
  final String description;
  final String highlights;
  final Map<String, dynamic> specifications;

  ProductDetailsData({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.discountPercentage,
    required this.images,
    required this.description,
    required this.highlights,
    required this.specifications,
  });

  factory ProductDetailsData.fromJson(Map<String, dynamic> json) {
    return ProductDetailsData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      description: json['description'] ?? '',
      highlights: json['highlights'] ?? '',
      specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
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
