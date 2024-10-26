import 'package:flutter/material.dart';
import 'package:aquaware/models/fish_detection.dart'; // Importiere dein FishDetection Model

class AnimalResultScreen extends StatelessWidget {
  final AnimalDetection animalResult;

  const AnimalResultScreen({super.key, required this.animalResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detected Animal Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Species: ${animalResult.species}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Habitat: ${animalResult.habitat}'),
            Text('Diet: ${animalResult.diet}'),
            Text('Average Size: ${animalResult.averageSize}'),
            Text('Behavior: ${animalResult.behavior}'),
            Text('Lifespan: ${animalResult.lifespan}'),
            Text(
                'Visual Characteristics: ${animalResult.visualCharacteristics}'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
