import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/models/water_value.dart';
import 'package:intl/intl.dart'; // Package to format date strings
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LastUpdatedWidget extends StatelessWidget {
  final WaterValue lastWaterValue;

  const LastUpdatedWidget({super.key, required this.lastWaterValue});

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.circle, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              loc.lastUpdated(_formatDate(lastWaterValue.measuredAt)),
              style: const TextStyle(color: ColorProvider.n1),
            ),
          ],
        ),
      ),
    );
  }
}
