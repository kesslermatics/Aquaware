import 'package:aquaware/models/disease.dart';
import 'package:flutter/material.dart';

class DiseaseResultScreen extends StatelessWidget {
  final FishDisease fishDisease;

  // Constructor to accept the FishDisease object
  const DiseaseResultScreen({super.key, required this.fishDisease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fish Disease Diagnosis Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Diagnosis Summary',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            // Display if a fish was detected
            Text(
              'Fish Detected: ${fishDisease.fishDetected ? "Yes" : "No"}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8.0),
            // Show the condition of the fish
            Text(
              'Condition: ${fishDisease.condition}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8.0),
            // Display the symptoms of the disease (if any)
            Text(
              'Symptoms: ${fishDisease.symptoms}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8.0),
            // Show the suggested treatments
            Text(
              'Suggested Treatment: ${fishDisease.curing}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8.0),
            // Show the certainty percentage
            Text(
              'Diagnosis Certainty: ${fishDisease.certainty.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the previous screen
                Navigator.pop(context);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
