import 'package:aquaware/models/water_value.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_heatmap/fl_heatmap.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class HeatmapWidget extends StatelessWidget {
  final List<WaterValue> waterValues;
  final String title;
  final int fractionDigits;

  const HeatmapWidget({
    super.key,
    required this.waterValues,
    this.title = '',
    required this.fractionDigits,
  });

  @override
  Widget build(BuildContext context) {
    HeatmapData heatmapData =
        _generateHeatmapData(waterValues.reversed.toList());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorProvider.n1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Heatmap(
              rowsVisible: 4, // Display four rows
              heatmapData: heatmapData,
              showXAxisLabels: false,
            ),
            const SizedBox(
              height: 16,
            ),
            _buildLegend(
              _getMinValue(waterValues),
              _getMaxValue(waterValues),
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

    // Initialize hourlyValues with all hours as keys and empty lists as values
    Map<String, List<double>> hourlyValues = {for (var hour in hours) hour: []};

    // Group values by hours and calculate the average per hour
    for (var value in waterValues) {
      String hour = DateFormat('HH:00').format(value.measuredAt);
      hourlyValues[hour]!.add(value.value);
    }

    const rows = [
      '00:00 - 06:00',
      '06:00 - 12:00',
      '12:00 - 18:00',
      '18:00 - 24:00',
    ];
    const columns = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
    ];

    hourlyValues.removeWhere((key, values) => values.isEmpty);

    List<HeatmapItem> items = [];
    hourlyValues.forEach((hour, values) {
      double averageValue = values.reduce((a, b) => a + b) / values.length;

      int rowIndex = int.parse(hour.split(':')[0]) ~/ 6;
      int columnIndex = int.parse(hour.split(':')[0]) % 6;
      items.add(HeatmapItem(
        value: averageValue,
        unit: '°C',
        xAxisLabel: columns[columnIndex],
        yAxisLabel: rows[rowIndex],
        style: HeatmapItemStyle.filled,
      ));
    });

    return HeatmapData(
      radius: 5,
      rows: rows,
      columns: columns,
      items: items,
      colorPalette: [
        const Color(0xffF5F5F5), // 0
        const Color(0xffBBDEFB), // 100
        const Color(0xff90CAF9), // 200
        const Color(0xff64B5F6), // 300
        const Color(0xff42A5F5), // 400
        const Color(0xff2196F3), // 500
        const Color(0xff1E88E5), // 600
        const Color(0xff1976D2), // 700
        const Color(0xff1565C0), // 800
        const Color(0xff0D47A1), // 900
      ],
    );
  }

  double _getMinValue(List<WaterValue> waterValues) {
    return waterValues.map((e) => e.value).reduce(min);
  }

  double _getMaxValue(List<WaterValue> waterValues) {
    return waterValues.map((e) => e.value).reduce(max);
  }

  Widget _buildLegend(double minValue, double maxValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          minValue.toStringAsFixed(fractionDigits) + waterValues.first.unit,
          style: const TextStyle(
            color: ColorProvider.n1,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 100,
          height: 20,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffF5F5F5),
                Color(0xffBBDEFB),
                Color(0xff90CAF9),
                Color(0xff64B5F6),
                Color(0xff42A5F5),
                Color(0xff2196F3),
                Color(0xff1E88E5),
                Color(0xff1976D2),
                Color(0xff1565C0),
                Color(0xff0D47A1),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          maxValue.toStringAsFixed(fractionDigits) + waterValues.first.unit,
          style: const TextStyle(
            color: ColorProvider.n1,
          ),
        ),
      ],
    );
  }
}
