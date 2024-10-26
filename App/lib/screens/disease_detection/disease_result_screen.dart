import 'package:aquaware/models/disease.dart';
import 'package:flutter/material.dart';

class DiseaseResultScreen extends StatelessWidget {
  final AnimalDisease animalDisease;

  // Konstruktor, um das FishDisease-Objekt zu akzeptieren
  const DiseaseResultScreen({super.key, required this.animalDisease});

  @override
  Widget build(BuildContext context) {
    final bool isHealthy = animalDisease.condition.toLowerCase() == 'healthy';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Diagnosis Result'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isHealthy) ...[
                const Text(
                  'The captured animal seems to be healthy!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                const Text(
                  'Condition',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  animalDisease.condition,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Symptoms',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  animalDisease.symptoms,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Suggested Treatment',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  animalDisease.curing,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
              const SizedBox(height: 24.0),
              // Admonition
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  border: Border.all(
                    color: Colors.yellow[700]!,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚠️ Keep in Mind',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Please note that this API uses machine learning models to analyze the animal and its condition. While it is generally accurate, there may be edge cases where:\n\n'
                      '• Symptoms of disease are subtle or not easily detectable.\n'
                      '• The animal’s natural patterns or appearance may resemble disease symptoms but are not harmful.\n\n'
                      'The diagnosis provided should be taken as a recommendation, not a definitive conclusion. No liability will be accepted for any incorrect diagnosis or subsequent actions taken based on the response.\n\n'
                      'It is always recommended to consult a professional veterinarian or animal health expert for any serious concerns about your pets.',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
