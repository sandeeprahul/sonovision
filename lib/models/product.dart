class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviews;
  final bool isOnSale;
  final double? originalPrice;
  final double? discountPercentage;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviews,
    this.isOnSale = false,
    this.originalPrice,
    this.discountPercentage,
  });
}