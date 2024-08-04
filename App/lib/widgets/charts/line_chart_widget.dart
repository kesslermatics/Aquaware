import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatelessWidget {
  final List<DateTime> xValues;
  final List<double> yValues;
  final double yDeviation;
  final Color lineColor;
  final Color gridColor;
  final Color bgColor;
  final Color textColor;
  final String title;
  final String xAxisLabel;
  final String yAxisLabel;

  String lastDate = '';

  LineChartWidget({
    required this.xValues,
    required this.yValues,
    required this.yDeviation,
    this.lineColor = Colors.blue,
    this.gridColor = Colors.grey,
    this.textColor = ColorProvider.textLight,
    this.bgColor = ColorProvider.primaryDark,
    this.title = '',
    this.xAxisLabel = '',
    this.yAxisLabel = '',
  });

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    for (int i = 0; i < xValues.length; i++) {
      spots.add(FlSpot(i.toDouble(), yValues[i]));
    }

    return Card(
      color: bgColor,
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                  ),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: gridColor,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: gridColor,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 80,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= xValues.length) {
                            return Container();
                          }
                          DateTime date = xValues[value.toInt()];
                          String formattedDate =
                              DateFormat('dd-MM HH:mm').format(date);

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                formattedDate,
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toString(),
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.transparent),
                      left: BorderSide(color: Colors.transparent),
                      right: BorderSide(color: Colors.transparent),
                      top: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  minY: yValues.reduce((a, b) => a < b ? a : b) - yDeviation,
                  maxY: yValues.reduce((a, b) => a > b ? a : b) + yDeviation,
                  minX: 0,
                  maxX: xValues.length.toDouble() - 1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: lineColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
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
}
