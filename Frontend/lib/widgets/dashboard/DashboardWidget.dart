import 'dart:core';

import 'package:aquaware/model/ChannelInfo.dart';
import 'package:aquaware/widgets/dashboard/DashboardLastUpdatedWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/SingleMeasurement.dart';
import 'DashboardDataWidget.dart';
import 'DashboardNumberOfEntriedWidget.dart';

class DashboardWidget extends StatelessWidget {
  final List<SingleMeasurement> data;
  final ChannelInfo info;
  double temperatureEdf = 8.537;
  double temperatureRefDf = 8.94;
  double temperatureFValue = 111.86;
  double temperaturePValue = 2e-16;

  double phEdf = 4.408;
  double phRefDf = 5.223;
  double phFValue = 21.148;
  double phPValue = 2e-16;

  double conductivityEdf = 7.639;
  double conductivityRefDf = 8.537;
  double conductivityFValue = 5.633;
  double conductivityPValue = 8.56e-07;

  DashboardWidget({super.key, required this.data, required this.info});

  @override
  Widget build(BuildContext context) {
    List<dynamic> temperatureMeasurements =
        data.map((measurement) => measurement.temperature).toList();
    List<dynamic> phMeasurements = data
        .map((measurement) => measurement.ph)
        .toList()
        .map((value) => double.parse(value.toStringAsFixed(2)))
        .toList();
    List<dynamic> tdsMeasurements =
        data.map((measurement) => measurement.tds).toList();

    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardLastUpdatedWidget(data.last),
            DashboardNumberOfEntriedWidget(data: data.last),
            DashboardDataWidget(
              dataParameter: temperatureMeasurements,
              icon: FontAwesomeIcons.temperatureHalf,
              color: Colors.red,
              name: "Temperature",
              deviation: 3,
              unit: "°C",
            ),
            DashboardDataWidget(
              dataParameter: phMeasurements,
              icon: FontAwesomeIcons.droplet,
              color: Colors.blue,
              name: "PH",
              deviation: 1,
              unit: "",
            ),
            DashboardDataWidget(
              dataParameter: tdsMeasurements,
              icon: FontAwesomeIcons.gem,
              color: Colors.brown,
              name: "TDS",
              deviation: 100,
              unit: "mg/L",
            ),
            DashboardDataWidget(
              dataParameter: calculateChlorophyllABiomass(
                  temperatureMeasurements, phMeasurements, tdsMeasurements),
              icon: FontAwesomeIcons.leaf,
              color: Colors.green,
              name: "Chlorophyll-a",
              deviation: 1,
              unit: "µg/L",
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> calculateChlorophyllABiomass(
      List<dynamic> temperatureMeasurements,
      List<dynamic> phMeasurements,
      List<dynamic> tdsMeasurements) {
    var chlorophyllAList = [];

    for (int i = 0; i < temperatureMeasurements.length; i++) {
      chlorophyllAList.add(
        estimateChlorophyllABiomass(
            temperatureMeasurements[i], phMeasurements[i], tdsMeasurements[i]),
      );
    }

    return chlorophyllAList;
  }

  double estimateChlorophyllABiomass(
      double temperature, double pH, double conductivity) {
    double estimatedBiomass = -10.53 +
        0.05727 * temperature +
        1.329 * pH +
        0.0004046 * 2 * conductivity;

    return double.parse(estimatedBiomass.toStringAsFixed(2));
  }
}
