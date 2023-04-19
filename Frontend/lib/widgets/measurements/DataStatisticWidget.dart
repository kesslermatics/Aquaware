import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../model/SingleMeasurement.dart';

class DataStatisticWidget extends StatefulWidget {
  final List<double> data;
  final List<String> dates;
  final double deviation;
  final double yInterval;
  final double xInterval;
  final String filterSetting;
  late List<Color> gradientColors = [];
  DataStatisticWidget({
    super.key,
    required this.data,
    required this.dates,
    required this.deviation,
    required this.yInterval,
    required this.xInterval,
    required this.filterSetting,
  }) {
    gradientColors = [
      Colors.white,
      Colors.white,
    ];
  }

  @override
  State<DataStatisticWidget> createState() => _DataStatisticWidgetState();
}

class _DataStatisticWidgetState extends State<DataStatisticWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(14, 14, 14, 14),
      color: Colors.white12,
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData() {
    List<FlSpot> spots = [];
    for (int i = 0; i < widget.data.length; i++) {
      spots.add(FlSpot(double.parse((i).toString()),
          double.parse(widget.data[i].toString())));
    }

    return LineChartData(
      clipData: FlClipData.all(),
      gridData: FlGridData(
        show: true,
      ),
      minY: widget.data.reduce((a, b) => a < b ? a : b) - widget.deviation,
      maxY: widget.data.reduce((a, b) => a > b ? a : b) + widget.deviation,
      minX: 1,
      maxX: widget.data.length.toDouble(),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            getTitlesWidget: bottomTitleWidgets,
            showTitles: true,
            reservedSize: 30,
            interval: widget.xInterval,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            interval: widget.yInterval,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.transparent),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: widget.gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: widget.gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (widget.filterSetting == "Past day") {
      text = Text(
          DateTime.parse(widget.dates[value.toInt() - 1]).hour.toString(),
          style: style);
    } else {
      text = Text(
          DateTime.parse(widget.dates[value.toInt() - 1]).day.toString(),
          style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}

class _Chart extends StatelessWidget {
  final double baselineX;
  final double baselineY;
  final List<double> data;
  final List<String> dates;
  late List<FlSpot> spots;

  _Chart(
      {required this.baselineX,
      required this.baselineY,
      required this.data,
      required this.dates}) {
    spots = [];
    for (int i = 0; i < data.length; i++) {
      if (DateTime.now().day == DateTime.parse(dates[i]).day) {
        spots.add(FlSpot(
            double.parse(i.toString()), double.parse(data[i].toString())));
      }
    }
  }

  Widget getHorizontalTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineX).abs() <= 0.1) {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white60,
        fontSize: 14,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(meta.formattedValue, style: style),
    );
  }

  Widget getVerticalTitles(value, TitleMeta meta) {
    TextStyle style;
    if ((value - baselineY).abs() <= 0.1) {
      style = const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );
    } else {
      style = const TextStyle(
        color: Colors.white60,
        fontSize: 14,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(meta.formattedValue, style: style),
    );
  }

  FlLine getHorizontalVerticalLine(double value) {
    if ((value - baselineY).abs() <= 0.1) {
      return FlLine(
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [8, 4],
      );
    } else {
      return FlLine(
        color: Colors.blueGrey,
        strokeWidth: 0.4,
        dashArray: [8, 4],
      );
    }
  }

  FlLine getVerticalVerticalLine(double value) {
    if ((value - baselineX).abs() <= 0.1) {
      return FlLine(
        color: Colors.white70,
        strokeWidth: 1,
        dashArray: [8, 4],
      );
    } else {
      return FlLine(
        color: Colors.blueGrey,
        strokeWidth: 0.4,
        dashArray: [8, 4],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getVerticalTitles,
              reservedSize: 36,
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getHorizontalTitles,
                reservedSize: 32),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getVerticalTitles,
              reservedSize: 36,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getHorizontalTitles,
                reservedSize: 32),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: getHorizontalVerticalLine,
          getDrawingVerticalLine: getVerticalVerticalLine,
        ),
        minY: data.reduce((a, b) => a < b ? a : b),
        maxY: data.reduce((a, b) => a > b ? a : b),
        baselineY: baselineY,
        minX: 1,
        maxX: spots.length.toDouble(),
        baselineX: baselineX,
      ),
      swapAnimationDuration: Duration.zero,
    );
  }
}
