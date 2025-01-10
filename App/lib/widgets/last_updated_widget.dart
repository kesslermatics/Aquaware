import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/models/water_value.dart';
import 'package:intl/intl.dart'; // Package to format date strings

class LastUpdatedWidget extends StatelessWidget {
  final WaterValue lastWaterValue;

  const LastUpdatedWidget({super.key, required this.lastWaterValue});

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.circle, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              'Last updated on ${_formatDate(lastWaterValue.measuredAt)}',
              style: const TextStyle(color: ColorProvider.n1),
            ),
          ],
        ),
      ),
    );
  }
}
