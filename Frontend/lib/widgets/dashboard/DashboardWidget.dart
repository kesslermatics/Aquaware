import 'package:aquaware/model/ChannelInfo.dart';
import 'package:aquaware/widgets/dashboard/DashboardLastUpdatedWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/SingleMeasurement.dart';
import 'DashboardDataWidget.dart';

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
          DashboardDataWidget(
              dataParameter:
                  data.map((measurement) => measurement.temperature).toList(),
              icon: FontAwesomeIcons.temperatureHalf,
              color: Colors.red,
              name: "Temperature"),
          DashboardDataWidget(
              dataParameter: data
                  .map((measurement) => measurement.ph)
                  .toList()
                  .map((value) => double.parse(value.toStringAsFixed(2)))
                  .toList(),
              icon: FontAwesomeIcons.temperatureHalf,
              color: Colors.blue,
              name: "PH"),
          DashboardDataWidget(
              dataParameter:
                  data.map((measurement) => measurement.tds).toList(),
              icon: FontAwesomeIcons.temperatureHalf,
              color: Colors.brown,
              name: "TDS"),
        ],
      ),
    );
  }
}
