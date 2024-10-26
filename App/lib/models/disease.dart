class AnimalDisease {
  final bool animalDetected;
  final String condition;
  final String symptoms;
  final String curing;

  AnimalDisease({
    required this.animalDetected,
    required this.condition,
    required this.symptoms,
    required this.curing,
  });

  // Factory method to create a AnimalDisease instance from JSON
  factory AnimalDisease.fromJson(Map<String, dynamic> json) {
    return AnimalDisease(
      animalDetected: json['animal_detected'],
      condition: json['condition'],
      symptoms: json['symptoms'],
      curing: json['curing'],
    );
  }

  // Convert AnimalDisease object to JSON (optional, if needed later)
  Map<String, dynamic> toJson() {
    return {
      'animal_detected': animalDetected,
      'condition': condition,
      'symptoms': symptoms,
      'curing': curing,
    };
  }
}
