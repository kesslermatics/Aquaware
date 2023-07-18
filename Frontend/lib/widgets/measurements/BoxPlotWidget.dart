import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../model/BoxPlotData.dart';

class BoxPlotWidget extends StatefulWidget {
  final List<double> data;
  final double deviation;
  final double interval;
  const BoxPlotWidget({
    super.key,
    required this.data,
    required this.deviation,
    required this.interval,
  });

  @override
  State<BoxPlotWidget> createState() => _BoxPlotWidgetState();
}

class _BoxPlotWidgetState extends State<BoxPlotWidget> {
  late List<BoxPlotData> boxPlotData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    boxPlotData = [
      BoxPlotData(
        name: "",
        data: widget.data,
        minimum: widget.data
                .reduce((current, next) => current < next ? current : next) -
            widget.deviation,
        maximum: widget.data
                .reduce((current, next) => current > next ? current : next) +
            widget.deviation,
      ),
    ];
    return Card(
      margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
      color: Colors.white12,
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    minimum: boxPlotData.first.minimum,
                    maximum: boxPlotData.first.maximum,
                    interval: widget.interval,
                  ),
                  series: <ChartSeries<BoxPlotData, String>>[
                    BoxAndWhiskerSeries<BoxPlotData, String>(
                        dataSource: boxPlotData,
                        xValueMapper: (BoxPlotData data, _) => data.name,
                        yValueMapper: (BoxPlotData data, _) => data.data,
                        name: 'Gold',
                        color: Color.fromRGBO(8, 142, 255, 1))
                  ])),
        ],
      ),
    );
  }
}
