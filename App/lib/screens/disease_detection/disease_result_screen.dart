import 'package:aquaware/models/disease.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DiseaseResultScreen extends StatelessWidget {
  final AnimalDisease animalDisease;

  const DiseaseResultScreen({super.key, required this.animalDisease});

  @override
  Widget build(BuildContext context) {
    final bool isHealthy = animalDisease.condition.toLowerCase() == 'healthy';
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.diseaseDiagnosisResult),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isHealthy) ...[
                Row(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        loc.healthyAnimalMessage,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    const Icon(Icons.info, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      loc.condition,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  animalDisease.condition,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Icon(Icons.healing, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      loc.symptoms,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  animalDisease.symptoms,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Icon(Icons.medical_services, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        loc.suggestedTreatment,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  animalDisease.curing,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
              const SizedBox(height: 24.0),
              // Admonition
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.yellow[700]!,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.keepInMind,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      loc.keepInMindDetails,
                      style: const TextStyle(fontSize: 12),
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
