import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    super.key,
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
  String _selectedFilter = '';
  late List<DateTime> usedXValues;
  late List<double> usedYValues;
  List<String> availableFilters = [];

  @override
  void initState() {
    super.initState();
    _updateAvailableFilters();
  }

  void _updateAvailableFilters() {
    DateTime now = DateTime.now();
    availableFilters = [];

    if (widget.xValues
        .any((date) => date.isAfter(now.subtract(const Duration(hours: 6))))) {
      availableFilters.add(AppLocalizations.of(context)!.last6Hours);
    }
    if (widget.xValues
        .any((date) => date.isAfter(now.subtract(const Duration(hours: 24))))) {
      availableFilters.add(AppLocalizations.of(context)!.last24Hours);
    }
    if (widget.xValues
        .any((date) => date.isAfter(now.subtract(const Duration(days: 7))))) {
      availableFilters.add(AppLocalizations.of(context)!.lastWeek);
    }

    if (!availableFilters.contains(_selectedFilter)) {
      _selectedFilter =
          availableFilters.isNotEmpty ? availableFilters.first : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    DateTime now = DateTime.now();
    DateTime filterTime;

    switch (_selectedFilter) {
      case 'Last 24 hours':
        filterTime = now.subtract(const Duration(hours: 24));
        break;
      case 'Last week':
        filterTime = now.subtract(const Duration(days: 7));
        break;
      default:
        filterTime = now.subtract(const Duration(hours: 6));
        break;
    }

    usedXValues =
        widget.xValues.where((date) => date.isAfter(filterTime)).toList();
    usedYValues =
        widget.yValues.sublist(widget.xValues.indexOf(usedXValues.first));

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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorProvider.n1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Row(
              children: [
                Text(
                  "${loc.filter}: ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorProvider.n1,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedFilter.isNotEmpty ? _selectedFilter : null,
                  items: availableFilters.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedFilter = newValue!;
                      _updateAvailableFilters();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
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
                            touchedSpot.y
                                .toStringAsFixed(widget.fractionDigits),
                            const TextStyle(
                              color: ColorProvider.n1,
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
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        interval: (usedXValues.length / 6)
                            .roundToDouble()
                            .clamp(1, double.infinity),
                        showTitles: true,
                        reservedSize: 80,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= usedXValues.length) {
                            return Container();
                          }

                          DateTime currentDate = usedXValues[value.toInt()];

                          String formattedDate =
                              DateFormat('dd-MM HH:mm').format(currentDate);

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                textAlign: TextAlign.end,
                                formattedDate,
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
                    leftTitles: AxisTitles(
                      drawBelowEverything: true,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(widget.fractionDigits),
                          style: const TextStyle(
                            color: ColorProvider.n1,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
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
                      color: ColorProvider.n1,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        checkToShowDot: (spot, barData) {
                          return (spot.x % (usedXValues.length / 6)).toInt() ==
                              0;
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
