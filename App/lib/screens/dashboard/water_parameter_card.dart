import 'package:aquaware/models/water_value.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/models/water_parameter.dart';
import 'package:intl/intl.dart';

class WaterParameterCard extends StatelessWidget {
  final WaterParameter waterParameter;

  WaterParameterCard({required this.waterParameter});

  @override
  Widget build(BuildContext context) {
    final latestValue = waterParameter.values.first;

    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.white12,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              waterParameter.parameter,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${latestValue.value} ${latestValue.unit}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat.Md(),
                        intervalType: DateTimeIntervalType.auto,
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        labelFormat: '{value} ${latestValue.unit}',
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      series: <CartesianSeries>[
                        LineSeries<WaterValue, DateTime>(
                          dataSource: waterParameter.values,
                          xValueMapper: (WaterValue value, _) =>
                              value.measuredAt,
                          yValueMapper: (WaterValue value, _) => value.value,
                          name: waterParameter.parameter,
                          color: Color.fromRGBO(8, 142, 255, 1),
                          markerSettings: MarkerSettings(
                            isVisible: true, // Display markers at data points
                            shape: DataMarkerType.circle, // Shape of the marker
                            borderWidth: 2,
                            borderColor: Color.fromRGBO(8, 142, 255, 1),
                          ),
                        ),
                      ],
                      tooltipBehavior: TooltipBehavior(enable: true),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
