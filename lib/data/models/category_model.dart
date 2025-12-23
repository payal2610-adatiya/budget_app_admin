class Category {
  final String id;
  final String userId;
  final String name;
  final String type; // 'income' or 'expense'
  final DateTime createdAt;

  Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.createdAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'expense',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }
}