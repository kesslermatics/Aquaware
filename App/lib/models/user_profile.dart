class UserProfile {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime dateJoined;
  final int subscriptionTier;
  final String apiKey;

  // Private constructor
  UserProfile._internal({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateJoined,
    required this.subscriptionTier,
    required this.apiKey,
  });

  // Static variable to hold the single instance
  static UserProfile? _instance;

  // Factory constructor to return the same instance
  factory UserProfile({
    required int id,
    required String email,
    required String firstName,
    required String lastName,
    required DateTime dateJoined,
    required int subscriptionTier,
    required String apiKey,
  }) {
    _instance ??= UserProfile._internal(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      dateJoined: dateJoined,
      subscriptionTier: subscriptionTier,
      apiKey: apiKey,
    );
    return _instance!;
  }

  // Method to set the Singleton instance from JSON
  static void setFromJson(Map<String, dynamic> json) {
    _instance = UserProfile._internal(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      dateJoined: DateTime.parse(json['date_joined']),
      subscriptionTier: json['subscription_tier'],
      apiKey: json['api_key'],
    );
  }

  // Method to clear/reset the instance (if needed)
  static void clearInstance() {
    _instance = null;
  }

  static UserProfile getInstance() {
    return _instance!;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'date_joined': dateJoined.toIso8601String(),
      'subscription_tier': subscriptionTier,
      'api_key': apiKey,
    };
  }
}
