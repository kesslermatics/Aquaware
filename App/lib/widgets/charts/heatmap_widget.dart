import 'package:aquaware/models/water_value.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_heatmap/fl_heatmap.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class HeatmapWidget extends StatelessWidget {
  final List<WaterValue> waterValues;
  final String title;

  HeatmapWidget({
    required this.waterValues,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    HeatmapData heatmapData = _generateHeatmapData(waterValues);

    return Card(
      color: ColorProvider.primaryDark,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorProvider.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Heatmap(
              onItemSelectedListener: (HeatmapItem? selectedItem) {
                debugPrint(
                    'Item ${selectedItem?.yAxisLabel}/${selectedItem?.xAxisLabel} with value ${selectedItem?.value} selected');
              },
              rowsVisible: 1, // Only one row for "Temperature"
              heatmapData: heatmapData,
            ),
          ],
        ),
      ),
    );
  }

  HeatmapData _generateHeatmapData(List<WaterValue> waterValues) {
    // Extract unique hours from waterValues
    List<String> hours =
        List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00');

    // Group values by hours and calculate the average per hour
    Map<String, List<double>> hourlyValues = {};
    for (var value in waterValues) {
      String hour = DateFormat('HH:00').format(value.measuredAt);
      if (!hourlyValues.containsKey(hour)) {
        hourlyValues[hour] = [];
      }
      hourlyValues[hour]!.add(value.value);
    }

    // Calculate average value for each hour
    List<HeatmapItem> items = [];
    hourlyValues.forEach((hour, values) {
      double averageValue = values.reduce((a, b) => a + b) / values.length;
      items.add(HeatmapItem(
        value: averageValue,
        unit: '°C',
        xAxisLabel: hour,
        yAxisLabel: '',
        style: HeatmapItemStyle.filled,
      ));
    });

    return HeatmapData(
      rows: [''],
      columns: hours,
      items: items.reversed.toList(),
      colorPalette: [
        Colors.blue,
        Color.fromARGB(255, 70, 61, 179),
        Color.fromARGB(255, 142, 28, 230),
        Color.fromARGB(255, 189, 16, 212),
        Colors.red,
      ],
    );
  }
}
