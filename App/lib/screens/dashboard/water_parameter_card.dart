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
  late double minY;
  late double maxY;

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
    minY = data.reduce((a, b) => a < b ? a : b) - deviation;
    maxY = data.reduce((a, b) => a > b ? a : b) + deviation;
  }

  @override
  Widget build(BuildContext context) {
    final latestValue = widget.waterParameter.values.first;
    return Card(
      margin: EdgeInsets.fromLTRB(14, 10, 14, 0),
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
                          key: ValueKey<double>(latestValue.value),
                          style: TextStyle(fontSize: 24),
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
                child: Column(
                  children: [
                    Text(
                      maxY.toStringAsFixed(2),
                      style: TextStyle(fontSize: 10),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: LineChart(mainData()),
                      ),
                    ),
                    Text(
                      minY.toStringAsFixed(2),
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
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
      gridData: FlGridData(show: false),
      minY: minY,
      maxY: maxY,
      minX: 1,
      maxX: data.length.toDouble(),
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: _getColorForParameter(widget.waterParameter.parameter),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
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
      case 'oxygen':
        return Icon(Icons.air, color: Colors.lightBlue, size: 40);
      case 'ammonia':
        return Icon(Icons.warning, color: Colors.orange, size: 40);
      case 'nitrite':
        return Icon(Icons.report_problem, color: Colors.purple, size: 40);
      case 'nitrate':
        return Icon(Icons.grain, color: Colors.pink, size: 40);
      case 'phosphate':
        return Icon(Icons.eco, color: Colors.green, size: 40);
      case 'carbon dioxide':
        return Icon(Icons.cloud, color: Colors.grey, size: 40);
      case 'salinity':
        return Icon(Icons.waves, color: Colors.cyan, size: 40);
      case 'general hardness':
        return Icon(Icons.diamond, color: Colors.blueGrey, size: 40);
      case 'carbonate hardness':
        return const Icon(Icons.filter_hdr, color: Colors.teal, size: 40);
      case 'copper':
        return Icon(Icons.circle, color: Colors.deepOrange, size: 40);
      case 'iron':
        return Icon(Icons.local_fire_department,
            color: Colors.redAccent, size: 40);
      case 'calcium':
        return Icon(Icons.check_circle, color: Colors.white, size: 40);
      case 'magnesium':
        return Icon(Icons.star, color: Colors.blueAccent, size: 40);
      case 'potassium':
        return Icon(Icons.flash_on, color: Colors.yellow, size: 40);
      case 'chlorine':
        return Icon(Icons.shield, color: Colors.greenAccent, size: 40);
      case 'alkalinity':
        return Icon(Icons.bubble_chart, color: Colors.lightGreen, size: 40);
      case 'redox potential':
        return Icon(Icons.electrical_services,
            color: Colors.deepPurple, size: 40);
      case 'silica':
        return Icon(Icons.spa, color: Colors.brown, size: 40);
      case 'boron':
        return Icon(Icons.scatter_plot, color: Colors.purpleAccent, size: 40);
      case 'strontium':
        return Icon(Icons.radio_button_checked, color: Colors.blue, size: 40);
      case 'iodine':
        return Icon(Icons.lightbulb, color: Colors.yellowAccent, size: 40);
      case 'molybdenum':
        return Icon(Icons.flash_auto, color: Colors.orangeAccent, size: 40);
      case 'sulfate':
        return Icon(Icons.bubble_chart, color: Colors.blueGrey, size: 40);
      case 'organic carbon':
        return Icon(Icons.nature, color: Colors.green, size: 40);
      case 'turbidity':
        return Icon(Icons.water_damage, color: Colors.lightBlue, size: 40);
      case 'conductivity':
        return Icon(Icons.offline_bolt, color: Colors.indigo, size: 40);
      case 'total organic carbon':
        return Icon(Icons.grass, color: Colors.green, size: 40);
      case 'suspended solids':
        return Icon(Icons.filter_drama, color: Colors.grey, size: 40);
      case 'fluoride':
        return Icon(Icons.invert_colors, color: Colors.lightBlue, size: 40);
      case 'bromine':
        return Icon(Icons.flare, color: Colors.red, size: 40);
      case 'chloride':
        return Icon(Icons.shield, color: Colors.blueAccent, size: 40);
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
      case 'oxygen':
        return Colors.lightBlue;
      case 'ammonia':
        return Colors.orange;
      case 'nitrite':
        return Colors.purple;
      case 'nitrate':
        return Colors.pink;
      case 'phosphate':
        return Colors.green;
      case 'carbon dioxide':
        return Colors.grey;
      case 'salinity':
        return Colors.cyan;
      case 'general hardness':
        return Colors.blueGrey;
      case 'carbonate hardness':
        return Colors.teal;
      case 'copper':
        return Colors.deepOrange;
      case 'iron':
        return Colors.redAccent;
      case 'calcium':
        return Colors.white;
      case 'magnesium':
        return Colors.blueAccent;
      case 'potassium':
        return Colors.yellow;
      case 'chlorine':
        return Colors.greenAccent;
      case 'alkalinity':
        return Colors.lightGreen;
      case 'redox potential':
        return Colors.deepPurple;
      case 'silica':
        return Colors.brown;
      case 'boron':
        return Colors.purpleAccent;
      case 'strontium':
        return Colors.blue;
      case 'iodine':
        return Colors.yellowAccent;
      case 'molybdenum':
        return Colors.orangeAccent;
      case 'sulfate':
        return Colors.blueGrey;
      case 'organic carbon':
        return Colors.green;
      case 'turbidity':
        return Colors.lightBlue;
      case 'conductivity':
        return Colors.indigo;
      case 'total organic carbon':
        return Colors.green;
      case 'suspended solids':
        return Colors.grey;
      case 'fluoride':
        return Colors.lightBlue;
      case 'bromine':
        return Colors.red;
      case 'chloride':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
}
