import 'package:aquaware/model/SingleMeasurement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'DashboardChart.dart';

class DashboardDataWidget extends StatelessWidget {
  late List<dynamic> dataParameter;
  final IconData icon;
  final Color color;
  final String name;
  final double deviation;
  final String unit;

  DashboardDataWidget({
    super.key,
    required this.dataParameter,
    required this.icon,
    required this.color,
    required this.name,
    required this.deviation,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> roundedDataParameter =
        dataParameter.map((value) => value.round()).toList();
    return Card(
      margin: EdgeInsets.fromLTRB(14, 10, 14, 0),
      color: Colors.white12,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                child: Container(
                  width: 100,
                  child: Column(
                    children: [
                      Icon(
                        icon,
                        color: color,
                        size: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Text(
                          name + (unit == "" ? "" : "\n($unit)"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: Text(
                          dataParameter.last.toString(),
                          key: ValueKey<int>(
                            int.parse(
                              roundedDataParameter.last.toString(),
                            ),
                          ),
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: VerticalDivider(
                  color: color,
                  thickness: 2,
                ),
              ),
              Container(
                width: 175,
                child: DashboardChart(
                  dataParameter: dataParameter,
                  color: color,
                  deviation: deviation,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
