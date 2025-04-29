class Category {
  final String id;
  final String name;
  final String icon;
  final int sortOrder;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.sortOrder,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
      icon: json['icon'],
      sortOrder: json['sortOrder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'icon': icon,
      'sortOrder': sortOrder,
    };
  }
}
