class Aquarium {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;

  Aquarium({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory Aquarium.fromJson(Map<String, dynamic> json) {
    return Aquarium(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
