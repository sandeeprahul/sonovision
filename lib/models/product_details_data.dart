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
  /// Optional sale (null when absent or not applicable)
  final Sale? sale;

  /// Optional finalPrice from API; if null, you can compute client-side
  final double? finalPrice;

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
    this.sale,
    this.finalPrice,
  });

  factory ProductDetailsData.fromJson(Map<String, dynamic> json) {
    // robust number parsing
    double _asDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    // sale can be missing or null
    final rawSale = json['sale'];
    final Sale? sale = (rawSale is Map<String, dynamic> && rawSale.isNotEmpty)
        ? Sale.fromJson(rawSale)
        : null;
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
      sale: sale,
      finalPrice: json['finalPrice'] != null ? _asDouble(json['finalPrice']) : null,

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
      if (sale != null) 'sale': sale!.toJson(),
      if (finalPrice != null) 'finalPrice': finalPrice,
    };

  }

  double get effectivePrice {
    if (finalPrice != null) return finalPrice!;
    // Prefer sale discount if active; else use product discountPercentage
    final int pct = (sale?.isActive == true && sale?.discountPercentage != null)
        ? sale!.discountPercentage!
        : (discountPercentage ?? 0);
    return (price - (price * pct / 100)).clamp(0, double.infinity);
  }
}
class Sale {
  final String id;
  final String name;
  final int? discountPercentage;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final List<String> products;

  Sale({
    required this.id,
    required this.name,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.products,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    return Sale(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      discountPercentage: (json['discountPercentage'] is num)
          ? (json['discountPercentage'] as num).toInt()
          : null,
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      isActive: json['isActive'] ?? false,
      products: List<String>.from(json['products'] ?? const []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'discountPercentage': discountPercentage,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
      'products': products,
    };
  }

  bool get isCurrentlyActive {
    if (!isActive) return false;
    final now = DateTime.now().toUtc();
    final startsOk = startDate == null || now.isAfter(startDate!);
    final endsOk = endDate == null || now.isBefore(endDate!);
    return startsOk && endsOk;
  }
}
