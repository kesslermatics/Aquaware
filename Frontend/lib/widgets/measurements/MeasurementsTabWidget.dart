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
  final double yInterval;

  MeasurementsTabWidget({
    super.key,
    required this.data,
    required this.dates,
    required this.deviation,
    required this.yInterval,
  });

  @override
  State<MeasurementsTabWidget> createState() => _MeasurementsTabWidgetState(
      data: data, dates: dates, deviation: deviation, yInterval: yInterval);
}

class _MeasurementsTabWidgetState extends State<MeasurementsTabWidget> {
  final List<double> data;
  final List<String> dates;
  final double deviation;
  final double yInterval;
  List<String> options = ['Past day', 'Past week'];
  late String selectedOption;
  late Widget statsWidget;
  late Widget minMaxWidget;

  _MeasurementsTabWidgetState({
    required this.data,
    required this.dates,
    required this.deviation,
    required this.yInterval,
  }) {
    selectedOption = options[0];
    statsWidget = getStatsWidget();
    minMaxWidget = getMinMaxWidget();
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
                statsWidget = getStatsWidget();
                minMaxWidget = getMinMaxWidget();
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
        ],
      ),
    );
  }

  Widget getStatsWidget() {
    List<double> actualData = [];
    List<String> actualDates = [];
    switch (selectedOption) {
      case "Past day":
        for (int i = 0; i < data.length; i++) {
          if (DateTime.now().day == DateTime.parse(dates[i]).toLocal().day) {
            actualData.add(data[i]);
            actualDates
                .add(DateTime.parse(dates[i]).toLocal().toIso8601String());
          }
        }
        return DataStatisticWidget(
          data: actualData,
          dates: actualDates,
          deviation: deviation,
          yInterval: yInterval,
          xInterval: 4,
          filterSetting: selectedOption,
        );
      case "Past week":
      default:
    }
    for (int i = 0; i < data.length; i++) {
      if (DateTime.now().difference(DateTime.parse(dates[i]).toLocal()).inDays <
          7) {
        actualData.add(data[i]);
        actualDates.add(DateTime.parse(dates[i]).toLocal().toIso8601String());
      }
    }
    return DataStatisticWidget(
      data: actualData,
      dates: actualDates,
      deviation: deviation,
      yInterval: yInterval,
      xInterval: 48,
      filterSetting: selectedOption,
    );
  }

  Widget getMinMaxWidget() {
    List<double> actualData = [];
    switch (selectedOption) {
      case "Past day":
        for (int i = 0; i < data.length; i++) {
          if (DateTime.now().day == DateTime.parse(dates[i]).toLocal().day) {
            actualData.add(data[i]);
          }
        }
        return MinMaxWidget(
          data: actualData,
        );
      case "Past week":
      default:
    }
    for (int i = 0; i < data.length; i++) {
      if (DateTime.now().difference(DateTime.parse(dates[i]).toLocal()).inDays <
          7) {
        actualData.add(data[i]);
      }
    }
    return MinMaxWidget(
      data: actualData,
    );
  }
}
