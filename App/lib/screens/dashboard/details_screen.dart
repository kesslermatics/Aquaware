import 'package:aquaware/models/aquarium.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Aquarium aquarium;

  const DetailsScreen({required this.aquarium, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              aquarium.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              aquarium.description,
              style: TextStyle(fontSize: 16),
            ),
            // Add more details about the aquarium here
          ],
        ),
      ),
    );
  }
}
