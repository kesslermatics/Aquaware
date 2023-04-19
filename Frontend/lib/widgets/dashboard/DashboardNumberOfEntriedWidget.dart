import 'package:aquaware/model/SingleMeasurement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DashboardNumberOfEntriedWidget extends StatelessWidget {
  final SingleMeasurement data;
  const DashboardNumberOfEntriedWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(14, 0, 14, 14),
      color: Colors.white12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Total number of entries: " + data.entryID.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
