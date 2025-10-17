class Category {
  final String id;
  final String name;
  final String icon;
  final int count;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.count = 0,
  });

  // Factory method to create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      count: json['count'] as int? ?? 0,
    );
  }

  // Convert a Category to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'count': count,
    };
  }
}
