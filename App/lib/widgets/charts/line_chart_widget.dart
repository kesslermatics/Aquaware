import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatefulWidget {
  final List<DateTime> xValues;
  final List<double> yValues;
  final double yDeviation;
  final String title;
  final String xAxisLabel;
  final String yAxisLabel;
  final fractionDigits;
  String lastDisplayedDate = '';

  LineChartWidget({
    required this.xValues,
    required this.yValues,
    required this.yDeviation,
    required this.fractionDigits,
    this.title = '',
    this.xAxisLabel = '',
    this.yAxisLabel = '',
  });

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  String lastDate = '';
  int _selectedValue = 6;
  late List<DateTime> usedXValues;
  late List<double> usedYValues;

  final List<int> _options = [6, 12, 24, 48, 96];

  @override
  Widget build(BuildContext context) {
    if (_selectedValue < widget.xValues.length) {
      usedXValues =
          widget.xValues.sublist(widget.xValues.length - _selectedValue);
      usedYValues =
          widget.yValues.sublist(widget.yValues.length - _selectedValue);
    } else {
      usedXValues = widget.xValues;
      usedYValues = widget.yValues;
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < usedXValues.length; i++) {
      spots.add(FlSpot(i.toDouble(), usedYValues[i]));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorProvider.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Row(
              children: [
                Text(
                  "Last ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorProvider.textDark,
                  ),
                ),
                DropdownButton<int>(
                  value: _selectedValue,
                  items: _options.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      _selectedValue = newValue!;
                    });
                  },
                ),
                Text(
                  " Values",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorProvider.textDark,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          return LineTooltipItem(
                            '${touchedSpot.y.toStringAsFixed(widget.fractionDigits)}',
                            TextStyle(
                              color: ColorProvider.textLight,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        interval: 6,
                        showTitles: true,
                        reservedSize: 80,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= usedXValues.length) {
                            return Container();
                          }

                          DateTime currentDate = usedXValues[value.toInt()];

                          // Überprüfe, ob das aktuelle Datum anders ist als das letzte angezeigte Datum
                          String currentDateString =
                              DateFormat('dd-MM').format(currentDate);
                          bool isNewDay =
                              widget.lastDisplayedDate != currentDateString;

                          // Aktualisiere das letzte angezeigte Datum, wenn ein neuer Tag erkannt wurde
                          if (isNewDay) {
                            widget.lastDisplayedDate = currentDateString;
                          }

                          String formattedDate = (isNewDay || value == 0)
                              ? DateFormat('dd-MM HH:mm')
                                  .format(currentDate) // Datum + Uhrzeit
                              : DateFormat('HH:mm')
                                  .format(currentDate); // Nur Uhrzeit

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                textAlign: TextAlign.end,
                                formattedDate,
                                style: TextStyle(
                                  color: ColorProvider.textDark,
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
                      drawBelowEverything: true,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(widget.fractionDigits),
                          style: TextStyle(
                            color: ColorProvider.textDark,
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
                  minY: usedYValues.reduce((a, b) => a < b ? a : b) -
                      widget.yDeviation,
                  maxY: usedYValues.reduce((a, b) => a > b ? a : b) +
                      widget.yDeviation,
                  minX: 0,
                  maxX: usedXValues.length.toDouble() - 1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: ColorProvider.primary,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        checkToShowDot: (spot, barData) {
                          return (spot.x % (_selectedValue / 12)).toInt() == 0;
                        },
                      ),
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
