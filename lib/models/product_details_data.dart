


import 'package:electronic_store/models/product_of_brands.dart';

class ProductDetailsData {
  final String id;
  final String name;
  final Brand? brand;
  final String categoryId;
  final double price;
  final int? discountPercentage;
  final String description;
  final bool isActive;
  final String highlights;
  final List<String> colors;
  final List<String> images;
  final int stock;
  final String storeCode;
  // final Map<String, dynamic> specifications;
  final String content;
  final Sale? sale;
  final double? finalPrice;
  final List<ProductFilter> filters;

  ProductDetailsData({
    required this.id,
    required this.name,
    required this.brand,
    required this.categoryId,
    required this.price,
    this.discountPercentage,
    required this.description,
    required this.highlights,
    required this.colors,
    required this.images,
    required this.stock,
    required this.storeCode,
    // required this.specifications,
    required this.content,
    this.sale,
    this.finalPrice,
    required this.filters,
    this.isActive = true,
  });

  factory ProductDetailsData.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return ProductDetailsData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
      categoryId: json['category']?['_id'] ?? '',
      price: _toDouble(json['price']),
      discountPercentage: json['discountPercentage'] != null
          ? (json['discountPercentage'] is int
          ? json['discountPercentage']
          : int.tryParse(json['discountPercentage'].toString()))
          : null,
      description: json['description'] ?? '',
      highlights: json['highlights'] ?? '',
      // highlights:  '',
      colors: List<String>.from(json['colors'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      stock: json['stock'] != null ? json['stock'] as int : 0,
      storeCode: json['storeCode']?.toString() ?? '',
      // specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
      content: json['content'] ?? '',
      sale: json['sale'] != null ? Sale.fromJson(json['sale']) : null,
      finalPrice: json['finalPrice'] != null ? _toDouble(json['finalPrice']) : null,
      filters: (json['filters'] as List<dynamic>?)
          ?.map((e) => ProductFilter.fromJson(e))
          .toList() ?? [],

      // filters: (json['filters'] as List<dynamic>?)?.map((e) => Filter.fromJson(e)).toList() ?? [],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'brand': brand?.toJson(),
      'price': price,
      'discountPercentage': discountPercentage,
      'description': description,
      'highlights': highlights,
      'colors': colors,
      'images': images,
      'stock': stock,
      'storeCode': storeCode,
      // 'specifications': specifications,
      'content': content,
      'sale': sale?.toJson(),
      'finalPrice': finalPrice,
      'filters': filters.map((e) => e.toJson()).toList(),
      'isActive': isActive,
    };
  }

/*  double get effectivePrice {
    final pct = (sale?.isCurrentlyActive == true && sale?.discountPercentage != null)
        ? sale!.discountPercentage!
        : (discountPercentage ?? 0);
    return (price - (price * pct / 100)).clamp(0, double.infinity);
  }*/
}

class ProductFilter {
  final String key;
  final String valueId;
  final String id;
  final String? id_;
  final String? value;

  ProductFilter({
    required this.key,
    required this.valueId,
    required this.id,
    this.id_,
    this.value,
  });

  factory ProductFilter.fromJson(Map<String, dynamic> json) {
    return ProductFilter(
      key: json['key'] ?? '',
      valueId: json['valueId'] ?? '',
      value: json['value'] ?? '',
      id: json['id'] ?? '',
      id_: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'valueId': valueId,
      'value': value,
      'id': id,
      '_id': id,
    };
  }
}

class Brand {
  final String id;
  final String name;

  Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
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
    this.discountPercentage,
    this.startDate,
    this.endDate,
    required this.isActive,
    required this.products,
  });

  factory Sale.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Sale(
        id: '',
        name: '',
        isActive: false,
        products: [],
      );
    }
    return Sale(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      discountPercentage: json['discountPercentage'] != null
          ? int.tryParse(json['discountPercentage'].toString())
          : null,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
      isActive: json['isActive'] ?? false,
      products: json['products'] != null
          ? List<String>.from(json['products'])
          : [],
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
}


