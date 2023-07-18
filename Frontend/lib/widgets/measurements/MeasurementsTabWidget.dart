import 'package:aquaware/widgets/measurements/BoxPlotWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../model/SingleMeasurement.dart';
import 'DataStatisticWidget.dart';
import 'MinMaxWidget.dart';

class MeasurementsTabWidget extends StatefulWidget {
  final List<double> data;
  final List<String> dates;
  final double deviation;
  final double boxPlotDeviation;
  final double yInterval;
  final double boxPlotInterval;

  MeasurementsTabWidget({
    super.key,
    required this.data,
    required this.dates,
    required this.deviation,
    required this.boxPlotDeviation,
    required this.yInterval,
    required this.boxPlotInterval,
  });

  @override
  State<MeasurementsTabWidget> createState() => _MeasurementsTabWidgetState(
      data: data,
      dates: dates,
      deviation: deviation,
      boxPlotDeviation: boxPlotDeviation,
      yInterval: yInterval,
      boxPlotInterval: boxPlotInterval);
}

class _MeasurementsTabWidgetState extends State<MeasurementsTabWidget> {
  final List<double> data;
  final List<String> dates;
  final double deviation;
  final double boxPlotDeviation;
  final double yInterval;
  final double boxPlotInterval;
  List<String> options = ['Past day', 'Past week'];
  late String selectedOption;
  late Widget statsWidget;
  late Widget minMaxWidget;
  late Widget boxPlotWidget;

  _MeasurementsTabWidgetState({
    required this.data,
    required this.dates,
    required this.deviation,
    required this.boxPlotDeviation,
    required this.yInterval,
    required this.boxPlotInterval,
  }) {
    selectedOption = options[0];
    updateWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            value: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
                updateWidgets();
              });
            },
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
          minMaxWidget,
          statsWidget,
          boxPlotWidget,
        ],
      ),
    );
  }

  void updateWidgets() {
    List<double> actualData = [];
    List<String> actualDates = [];
    double xInterval;
    switch (selectedOption) {
      case "Past day":
        for (int i = 0; i < data.length; i++) {
          if (DateTime.now().day == DateTime.parse(dates[i]).toLocal().day) {
            actualData.add(data[i]);
            actualDates.add(
              DateTime.parse(dates[i]).toLocal().toIso8601String(),
            );
          }
        }
        xInterval = 4;
        break;
      case "Past week":
      default:
        for (int i = 0; i < data.length; i++) {
          if (DateTime.now()
                  .difference(DateTime.parse(dates[i]).toLocal())
                  .inDays <
              7) {
            actualData.add(data[i]);
            actualDates.add(
              DateTime.parse(dates[i]).toLocal().toIso8601String(),
            );
          }
        }
        xInterval = 48;
    }
    statsWidget = DataStatisticWidget(
      data: actualData,
      dates: actualDates,
      deviation: deviation,
      yInterval: yInterval,
      xInterval: xInterval,
      filterSetting: selectedOption,
    );
    minMaxWidget = MinMaxWidget(
      data: actualData,
    );
    boxPlotWidget = BoxPlotWidget(
      data: actualData,
      deviation: boxPlotDeviation,
      interval: boxPlotInterval,
    );
  }
}
