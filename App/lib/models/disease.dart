class FishDisease {
  final bool fishDetected;
  final String condition;
  final String symptoms;
  final String curing;
  final double certainty;

  FishDisease({
    required this.fishDetected,
    required this.condition,
    required this.symptoms,
    required this.curing,
    required this.certainty,
  });

  // Factory method to create a FishDisease instance from JSON
  factory FishDisease.fromJson(Map<String, dynamic> json) {
    return FishDisease(
      fishDetected: json['fish_detected'],
      condition: json['condition'],
      symptoms: json['symptoms'],
      curing: json['curing'],
      certainty: (json['certainty'] as num).toDouble(),
    );
  }

  // Convert FishDisease object to JSON (optional, if needed later)
  Map<String, dynamic> toJson() {
    return {
      'fish_detected': fishDetected,
      'condition': condition,
      'symptoms': symptoms,
      'curing': curing,
      'certainty': certainty,
    };
  }
}
