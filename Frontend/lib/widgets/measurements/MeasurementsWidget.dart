import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../model/ChannelInfo.dart';
import '../../model/SingleMeasurement.dart';
import '../DrawerMenuWidget.dart';
import 'MeasurementsTabWidget.dart';

class MeasurementsWidget extends StatelessWidget {
  final List<SingleMeasurement> data;
  final ChannelInfo info;

  const MeasurementsWidget({super.key, required this.data, required this.info});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Center(
          child: MeasurementsTabWidget(
            data:
                data.map((dataParameter) => dataParameter.temperature).toList(),
            dates:
                data.map((dataParameter) => dataParameter.createdAt).toList(),
            deviation: 2,
            yInterval: 1,
          ),
        ),
        Center(
          child: MeasurementsTabWidget(
            data: data.map((dataParameter) => dataParameter.ph).toList(),
            dates:
                data.map((dataParameter) => dataParameter.createdAt).toList(),
            deviation: 0.3,
            yInterval: 0.2,
          ),
        ),
        Center(
          child: MeasurementsTabWidget(
            data: data.map((dataParameter) => dataParameter.tds).toList(),
            dates:
                data.map((dataParameter) => dataParameter.createdAt).toList(),
            deviation: 100,
            yInterval: 40,
          ),
        ),
      ],
    );
  }
}
