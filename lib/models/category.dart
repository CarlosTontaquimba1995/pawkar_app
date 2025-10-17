class Category {
  final String id;
  final String name;
  final String icon;
  final int count;
  final List<Category> subcategories;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.count = 0,
    this.subcategories = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      count: json['count'] as int? ?? 0,
      subcategories:
          (json['subcategories'] as List<dynamic>?)
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'count': count,
      'subcategories': subcategories.map((e) => e.toJson()).toList(),
    };
  }
}
