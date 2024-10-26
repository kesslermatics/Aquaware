class FishDetection {
  final bool fishDetected;
  final String species;
  final double confidence;

  FishDetection({
    required this.fishDetected,
    required this.species,
    required this.confidence,
  });

  // Factory constructor to parse JSON response from API
  factory FishDetection.fromJson(Map<String, dynamic> json) {
    return FishDetection(
      fishDetected: json['fish_detected'] as bool,
      species: (json['species'] ?? "") as String,
      confidence: ((json['certainty'] ?? 0) as num).toDouble(),
    );
  }

  // Convert the instance to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'fish_detected': fishDetected,
      'species': species,
      'confidence': confidence,
    };
  }
}
