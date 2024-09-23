class UserProfile {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime dateJoined;
  final int subscriptionTier;

  UserProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateJoined,
    required this.subscriptionTier,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      dateJoined: DateTime.parse(json['date_joined']),
      subscriptionTier: json['subscription_tier_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'date_joined': dateJoined.toIso8601String(),
    };
  }
}
