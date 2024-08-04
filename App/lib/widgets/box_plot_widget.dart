import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BoxPlotWidget extends StatelessWidget {
  final List<double> values;

  BoxPlotWidget({required this.values});

  @override
  Widget build(BuildContext context) {
    double min = values.reduce((a, b) => a < b ? a : b);
    double max = values.reduce((a, b) => a > b ? a : b);
    double median = calculateMedian(values);
    double q1 = calculatePercentile(values, 25);
    double q3 = calculatePercentile(values, 75);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Box Plot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          fromY: min,
                          toY: max,
                          width: 20,
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        BarChartRodData(
                          fromY: q1,
                          toY: q3,
                          width: 20,
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        BarChartRodData(
                          fromY: median,
                          toY: median,
                          width: 20,
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateMedian(List<double> values) {
    values.sort();
    int middle = values.length ~/ 2;
    if (values.length % 2 == 1) {
      return values[middle];
    } else {
      return (values[middle - 1] + values[middle]) / 2;
    }
  }

  double calculatePercentile(List<double> values, int percentile) {
    values.sort();
    int index = (percentile / 100.0 * (values.length - 1)).round();
    return values[index];
  }
}
