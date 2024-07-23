import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/models/water_parameter.dart';

class WaterParameterCard extends StatefulWidget {
  final WaterParameter waterParameter;

  WaterParameterCard({required this.waterParameter});

  @override
  _WaterParameterCardState createState() => _WaterParameterCardState();
}

class _WaterParameterCardState extends State<WaterParameterCard> {
  late List<Color> gradientColors;
  late List<double> data;
  late List<String> dates;
  late double deviation;
  late double yInterval;
  late double xInterval;

  @override
  void initState() {
    super.initState();
    gradientColors = [Colors.blue, Colors.blueAccent];
    data = widget.waterParameter.values.map((e) => e.value).toList();
    dates = widget.waterParameter.values
        .map((e) => e.measuredAt.toIso8601String())
        .toList();
    deviation = (data.reduce((a, b) => a > b ? a : b) -
            data.reduce((a, b) => a < b ? a : b)) /
        10;
    yInterval = deviation / 2;
    xInterval = 1;
  }

  @override
  Widget build(BuildContext context) {
    final latestValue = widget.waterParameter.values.first;
    return Card(
      margin: EdgeInsets.fromLTRB(14, 10, 14, 0),
      color: Colors.white12,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                child: Container(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _getIconForParameter(widget.waterParameter.parameter),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Text(
                          '${widget.waterParameter.parameter} (${latestValue.unit})',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: Text(
                          latestValue.value.toString(),
                          key: ValueKey<int>(
                            latestValue.value.round(),
                          ),
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: VerticalDivider(
                  color: _getColorForParameter(widget.waterParameter.parameter),
                  thickness: 2,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: LineChart(mainData()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData mainData() {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(double.parse((i + 1).toString()), data[i]));
    }

    return LineChartData(
      clipData: FlClipData.all(),
      gridData: FlGridData(
        show: false,
      ),
      minY: data.reduce((a, b) => a < b ? a : b) - deviation,
      maxY: data.reduce((a, b) => a > b ? a : b) + deviation,
      minX: 1,
      maxX: data.length.toDouble(),
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: _getColorForParameter(widget.waterParameter.parameter),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }

  Widget _getIconForParameter(String parameter) {
    switch (parameter.toLowerCase()) {
      case 'temperature':
        return Icon(Icons.thermostat, color: Colors.red, size: 40);
      case 'ph':
        return Icon(Icons.opacity, color: Colors.blue, size: 40);
      case 'tds':
        return Icon(Icons.invert_colors, color: Colors.brown, size: 40);
      case 'chlorophyll-a':
        return Icon(Icons.grass, color: Colors.green, size: 40);
      default:
        return Icon(Icons.device_thermostat, color: Colors.grey, size: 40);
    }
  }

  Color _getColorForParameter(String parameter) {
    switch (parameter.toLowerCase()) {
      case 'temperature':
        return Colors.red;
      case 'ph':
        return Colors.blue;
      case 'tds':
        return Colors.brown;
      case 'chlorophyll-a':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
