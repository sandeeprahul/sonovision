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
  final List<Filter> filters; // ✅ new field


  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.sortOrder,
    required this.isActive,
    required this.priceRanges,
    required this.products,
    required this.filters,

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
      filters: (json["filters"] as List)
          .map((e) => Filter.fromJson(e))
          .toList(),
    );
  }
}
class Filter {
  final String id;
  final String key;
  final String label;
  final String? icon;
  final bool showInUi;
  final List<FilterValue> values;

  Filter({
    required this.id,
    required this.key,
    required this.label,
    required this.icon,
    required this.showInUi,
    required this.values,
  });

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      id: json["_id"],
      key: json["key"],
      label: json["label"],
      icon: json["icon"],
      showInUi: json["show_in_ui"],
      values: (json["values"] as List)
          .map((e) => FilterValue.fromJson(e))
          .toList(),
    );
  }
}

class FilterValue {
  final String id;
  final String value;

  FilterValue({
    required this.id,
    required this.value,
  });

  factory FilterValue.fromJson(Map<String, dynamic> json) {
    return FilterValue(
      id: json["_id"],
      value: json["value"],
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
