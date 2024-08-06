import 'package:flutter/material.dart';
import 'package:fl_heatmap/fl_heatmap.dart';
import 'package:intl/intl.dart';
import 'package:aquaware/services/color_provider.dart';

class HeatmapWidget extends StatefulWidget {
  final List<DateTime> xValues;
  final List<double> yValues;
  final DateTime day;

  HeatmapWidget({
    required this.xValues,
    required this.yValues,
    required this.day,
  });

  @override
  _HeatmapWidgetState createState() => _HeatmapWidgetState();
}

class _HeatmapWidgetState extends State<HeatmapWidget> {
  HeatmapItem? selectedItem;
  late HeatmapData heatmapData;

  @override
  void initState() {
    super.initState();
    _initHeatmapData();
  }

  void _initHeatmapData() {
    final dateFormatter = DateFormat('dd-MM');
    final timeFormatter = DateFormat('HH:mm');

    final filteredIndices = widget.xValues
        .asMap()
        .entries
        .where((entry) =>
            dateFormatter.format(entry.value) ==
            dateFormatter.format(widget.day))
        .map((entry) => entry.key)
        .toList();

    final filteredXValues =
        filteredIndices.map((index) => widget.xValues[index]).toList();
    final filteredYValues =
        filteredIndices.map((index) => widget.yValues[index]).toList();

    final rows = List<String>.generate(24, (index) => '$index:00');

    final dataMap = <String, List<double>>{};
    for (int i = 0; i < filteredXValues.length; i++) {
      final hour = filteredXValues[i].hour.toString().padLeft(2, '0') + ':00';
      dataMap[hour] ??= [];
      dataMap[hour]!.add(filteredYValues[i]);
    }

    final items = <HeatmapItem>[];
    dataMap.forEach((hour, values) {
      final averageValue = values.reduce((a, b) => a + b) / values.length;
      items.add(HeatmapItem(
        value: averageValue,
        unit: '°C',
        xAxisLabel: hour,
        yAxisLabel: '',
      ));
    });

    heatmapData = HeatmapData(
      rows: rows,
      columns: [''],
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = selectedItem != null
        ? '${selectedItem!.value.toStringAsFixed(2)} ${selectedItem!.unit}'
        : '--- ${heatmapData.items.first.unit}';
    final subtitle = selectedItem != null ? selectedItem!.xAxisLabel : '---';
    return Card(
      color: ColorProvider.primaryDark,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorProvider.textLight,
              ),
            ),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: ColorProvider.textLight,
              ),
            ),
            const SizedBox(height: 8),
            Heatmap(
              onItemSelectedListener: (HeatmapItem? selectedItem) {
                setState(() {
                  this.selectedItem = selectedItem;
                });
              },
              rowsVisible: 24,
              heatmapData: heatmapData,
            ),
          ],
        ),
      ),
    );
  }
}
