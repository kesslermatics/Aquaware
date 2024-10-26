class AnimalDetection {
  final bool animalDetected;
  final String species;
  final String habitat;
  final String diet;
  final String averageSize;
  final String behavior;
  final String lifespan;
  final String visualCharacteristics;

  AnimalDetection({
    required this.animalDetected,
    required this.species,
    this.habitat = "",
    this.diet = "",
    this.averageSize = "",
    this.behavior = "",
    this.lifespan = "",
    this.visualCharacteristics = "",
  });

  // Factory constructor to parse JSON response from API
  factory AnimalDetection.fromJson(Map<String, dynamic> json) {
    return AnimalDetection(
      animalDetected: json['animal_detected'] as bool,
      species: (json['species'] ?? "") as String,
      habitat: (json['habitat'] ?? "") as String,
      diet: (json['diet'] ?? "") as String,
      averageSize: (json['average_size'] ?? "") as String,
      behavior: (json['behavior'] ?? "") as String,
      lifespan: (json['lifespan'] ?? "") as String,
      visualCharacteristics: (json['visual_characteristics'] ?? "") as String,
    );
  }

  // Convert the instance to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'animal_detected': animalDetected,
      'species': species,
      'habitat': habitat,
      'diet': diet,
      'average_size': averageSize,
      'behavior': behavior,
      'lifespan': lifespan,
      'visual_characteristics': visualCharacteristics,
    };
  }
}
