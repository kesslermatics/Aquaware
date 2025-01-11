import 'package:flutter/material.dart';
import 'package:aquaware/models/fish_detection.dart'; // Importiere dein FishDetection Model

class AnimalResultScreen extends StatefulWidget {
  final AnimalDetection animalResult;

  const AnimalResultScreen({super.key, required this.animalResult});

  @override
  _AnimalResultScreenState createState() => _AnimalResultScreenState();
}

class _AnimalResultScreenState extends State<AnimalResultScreen> {
  double minSize = 0;
  double maxSize = 0;
  double currentMinSize = 0;
  double currentMaxSize = 0;

  double minLifespan = 0;
  double maxLifespan = 0;
  double currentMinLifespan = 0;
  double currentMaxLifespan = 0;

  String sizeUnit = '';
  String lifespanUnit = '';

  @override
  void initState() {
    super.initState();
    _parseData();
  }

  void _parseData() {
    // Parsing der averageSize
    if (widget.animalResult.averageSize.isNotEmpty) {
      final sizeParts = widget.animalResult.averageSize.split(' ');
      if (sizeParts.length >= 2) {
        final sizeRange = sizeParts[0]; // z.B. "2-5"
        sizeUnit = sizeParts[1]; // z.B. "cm"
        final sizeValues = sizeRange.split('-');
        if (sizeValues.length == 2) {
          minSize = double.tryParse(sizeValues[0]) ?? 0;
          maxSize = double.tryParse(sizeValues[1]) ?? 0;
          currentMinSize = minSize;
          currentMaxSize = maxSize;
        }
      }
    }

    // Parsing der lifespan
    if (widget.animalResult.lifespan.isNotEmpty) {
      final lifespanParts = widget.animalResult.lifespan.split(' ');
      if (lifespanParts.length >= 2) {
        final lifespanRange = lifespanParts[0]; // z.B. "1-3"
        lifespanUnit = lifespanParts[1]; // z.B. "years"
        final lifespanValues = lifespanRange.split('-');
        if (lifespanValues.length == 2) {
          minLifespan = double.tryParse(lifespanValues[0]) ?? 0;
          maxLifespan = double.tryParse(lifespanValues[1]) ?? 0;
          currentMinLifespan = minLifespan;
          currentMaxLifespan = maxLifespan;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detected Animal Information')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.animalResult.species,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.landscape),
                  SizedBox(width: 8),
                  Text(
                    'Habitat',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.animalResult.habitat ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.straighten),
                  SizedBox(width: 8),
                  Text(
                    'Average Size',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildRangeSlider(
                minValue: minSize,
                maxValue: maxSize,
                currentMin: currentMinSize,
                currentMax: currentMaxSize,
                unit: sizeUnit,
                color: Colors.blue,
                onChanged: (values) {
                  setState(() {
                    currentMinSize = values.start;
                    currentMaxSize = values.end;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.access_time),
                  SizedBox(width: 8),
                  Text(
                    'Lifespan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildRangeSlider(
                minValue: minLifespan,
                maxValue: maxLifespan,
                currentMin: currentMinLifespan,
                currentMax: currentMaxLifespan,
                unit: lifespanUnit,
                color: Colors.green,
                onChanged: (values) {
                  setState(() {
                    currentMinLifespan = values.start;
                    currentMaxLifespan = values.end;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.color_lens),
                  SizedBox(width: 8),
                  Text(
                    'Visual Characteristics',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.animalResult.visualCharacteristics ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.emoji_people),
                  SizedBox(width: 8),
                  Text(
                    'Behavior',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.animalResult.behavior ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.restaurant),
                  SizedBox(width: 8),
                  Text(
                    'Diet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.animalResult.diet ?? '',
                style: const TextStyle(fontSize: 14),
              ),
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
                      'Please note that this API uses machine learning models to analyze the species. While it is generally accurate, there may be edge cases where:\n\n'
                      '• Species identification may not be perfect, especially if the image quality is low.\n'
                      '• Visual characteristics of certain species may overlap, leading to misidentification.\n\n'
                      'The species identification provided should be taken as a recommendation, not a definitive conclusion. No liability will be accepted for any incorrect identification or subsequent actions taken based on the response.\n\n',
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

  Widget _buildRangeSlider({
    required double minValue,
    required double maxValue,
    required double currentMin,
    required double currentMax,
    required String unit,
    required Color color,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      children: [
        AbsorbPointer(
          child: RangeSlider(
            values: RangeValues(currentMin, currentMax),
            min: minValue,
            max: maxValue,
            divisions: (maxValue - minValue).round(),
            activeColor: color,
            labels: RangeLabels(
              '${currentMin.toStringAsFixed(1)} $unit',
              '${currentMax.toStringAsFixed(1)} $unit',
            ),
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${minValue.toStringAsFixed(1)} $unit'),
            Text('${maxValue.toStringAsFixed(1)} $unit'),
          ],
        ),
      ],
    );
  }
}
