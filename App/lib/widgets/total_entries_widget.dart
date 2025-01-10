import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';

class TotalEntriesWidget extends StatelessWidget {
  final int totalEntries;

  const TotalEntriesWidget({super.key, required this.totalEntries});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Total number of entries: $totalEntries',
            style: const TextStyle(color: ColorProvider.n1)),
      ),
    );
  }
}
