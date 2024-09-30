class Environment {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;
  final String environmentType;
  final bool public;
  final String city;

  Environment({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.environmentType,
    required this.public,
    required this.city,
  });

  factory Environment.fromJson(Map<String, dynamic> json) {
    return Environment(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      environmentType: json['environment_type'],
      public: json['public'],
      city: json['city'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'environment_type': environmentType,
      'public': public,
      'city': city,
    };
  }
}
