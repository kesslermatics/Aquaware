import 'package:aquaware/model/ChannelInfo.dart';
import 'package:aquaware/widgets/dashboard/DashboardLastUpdatedWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/SingleMeasurement.dart';
import 'DashboardDataWidget.dart';
import 'DashboardNumberOfEntriedWidget.dart';

class DashboardWidget extends StatelessWidget {
  final List<SingleMeasurement> data;
  final ChannelInfo info;

  const DashboardWidget({super.key, required this.data, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardLastUpdatedWidget(data.last),
          DashboardNumberOfEntriedWidget(data: data.last),
          DashboardDataWidget(
            dataParameter:
                data.map((measurement) => measurement.temperature).toList(),
            icon: FontAwesomeIcons.temperatureHalf,
            color: Colors.red,
            name: "Temperature",
            deviation: 3,
            unit: "°C",
          ),
          DashboardDataWidget(
            dataParameter: data
                .map((measurement) => measurement.ph)
                .toList()
                .map((value) => double.parse(value.toStringAsFixed(2)))
                .toList(),
            icon: FontAwesomeIcons.droplet,
            color: Colors.blue,
            name: "PH",
            deviation: 1,
            unit: "",
          ),
          DashboardDataWidget(
            dataParameter: data.map((measurement) => measurement.tds).toList(),
            icon: FontAwesomeIcons.gem,
            color: Colors.brown,
            name: "TDS",
            deviation: 100,
            unit: "mg/L",
          ),
        ],
      ),
    );
  }
}
