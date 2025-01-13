import 'package:aquaware/models/water_value.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aquaware/services/color_provider.dart';

class HistogramWidget extends StatelessWidget {
  final List<WaterValue> waterValues;
  final double range;
  final String title;
  final int fractionDigits;
  final String xAxisLabel;
  final String yAxisLabel;

  const HistogramWidget({
    super.key,
    required this.waterValues,
    required this.range,
    this.title = '',
    this.xAxisLabel = '',
    this.yAxisLabel = '',
    required this.fractionDigits,
  });

  @override
  Widget build(BuildContext context) {
    Map<double, int> frequencyMap = _createFrequencyMap(waterValues, range);

    List<BarChartGroupData> barGroups = frequencyMap.entries.map((entry) {
      return BarChartGroupData(
        x: (entry.key * (1 / range)).toInt(), // Scale to int
        barRods: [
          BarChartRodData(
            color: ColorProvider.n1,
            toY: entry.value.toDouble(),
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: ColorProvider.n1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toString(),
                          const TextStyle(
                            color: ColorProvider.n1,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: ColorProvider.n1,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 80,
                        getTitlesWidget: (value, meta) {
                          double originalValue = value.toDouble() * range;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                originalValue.toStringAsFixed(fractionDigits) +
                                    waterValues.first.unit,
                                style: const TextStyle(
                                  color: ColorProvider.n1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Colors.transparent),
                      left: BorderSide(color: Colors.transparent),
                      right: BorderSide(color: Colors.transparent),
                      top: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  barGroups: barGroups,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<double, int> _createFrequencyMap(List<WaterValue> values, double range) {
    Map<double, int> frequencyMap = {};
    for (var value in values) {
      double extractedValue = value.value;
      double roundedValue = (extractedValue / range).floorToDouble() * range;
      frequencyMap[roundedValue] = (frequencyMap[roundedValue] ?? 0) + 1;
    }
    return frequencyMap;
  }
}
