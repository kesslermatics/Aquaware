import 'package:aquaware/widgets/charts/heatmap_widget.dart';
import 'package:aquaware/widgets/charts/histogram_widget.dart';
import 'package:aquaware/widgets/charts/line_chart_widget.dart';
import 'package:aquaware/widgets/last_updated_widget.dart';
import 'package:aquaware/widgets/total_entries_widget.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/water_parameter_service.dart';
import 'package:aquaware/models/water_value.dart';
import 'package:aquaware/services/color_provider.dart';

class DataScreen extends StatefulWidget {
  final Future<List<WaterValue>> futureWaterValues;
  final Future<int> futureTotalEntries;
  final String parameterName;
  final bool isLineChartVisible;
  final bool isHeatmapVisible;
  final bool isHistogrammVisible;
  final double histogrammRange;
  final String unit;
  final int fractionDigits;
  final double lineChartDeviation;

  const DataScreen({
    super.key,
    required this.futureWaterValues,
    required this.futureTotalEntries,
    required this.parameterName,
    this.isLineChartVisible = true,
    this.isHeatmapVisible = true,
    this.isHistogrammVisible = true,
    this.histogrammRange = 0.01,
    this.unit = '',
    this.fractionDigits = 2,
    this.lineChartDeviation = 0.1,
  });

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  double _progress = 0.0;
  String _statusText = "Initializing...";

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    setState(() {
      _progress = 0.2;
      _statusText = "Fetching water values...";
    });
    await widget.futureWaterValues;

    setState(() {
      _progress = 0.6;
      _statusText = "Fetching total entries...";
    });
    await widget.futureTotalEntries;

    setState(() {
      _progress = 1.0;
      _statusText = "Loading complete!";
    });

    await Future.delayed(const Duration(milliseconds: 50)); // Pause for UX
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<WaterValue>>(
        future: widget.futureWaterValues,
        builder: (context, snapshot) {
          if (_progress < 1.0) {
            return _buildLoadingWidget();
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load water values'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No water values found'));
          } else {
            List<WaterValue> waterValues = snapshot.data!.reversed.toList();
            WaterValue lastWaterValue = waterValues.last;
            return FutureBuilder<int>(
              future: widget.futureTotalEntries,
              builder: (context, totalEntriesSnapshot) {
                if (totalEntriesSnapshot.hasError) {
                  return const Center(
                      child: Text('Failed to load total entries'));
                } else if (!totalEntriesSnapshot.hasData) {
                  return const Center(child: Text('No total entries found'));
                } else {
                  int totalEntries = totalEntriesSnapshot.data!;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LastUpdatedWidget(lastWaterValue: lastWaterValue),
                        TotalEntriesWidget(totalEntries: totalEntries),
                        if (widget.isLineChartVisible)
                          _makeLineChartWidget(waterValues),
                        if (widget.isHeatmapVisible)
                          _makeHeatmapWidget(waterValues),
                        if (widget.isHistogrammVisible)
                          _makeHistogramWidget(waterValues),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: ColorProvider.n17,
          strokeWidth: 6.0,
        ),
        const SizedBox(height: 16),
        Text(
          _statusText,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 16, 50, 16),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 4.0,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _makeLineChartWidget(List<WaterValue> waterValues) {
    List<DateTime> xValues =
        waterValues.map((value) => value.measuredAt).toList();
    List<double> yValues = waterValues.map((value) => value.value).toList();
    return LineChartWidget(
      xValues: xValues,
      yValues: yValues,
      yDeviation: widget.lineChartDeviation,
      fractionDigits: widget.fractionDigits,
      title: '${widget.parameterName} Levels over Time',
      xAxisLabel: 'Time',
      yAxisLabel: '${widget.parameterName} (${widget.unit})',
    );
  }

  Widget _makeHeatmapWidget(List<WaterValue> waterValues) {
    return HeatmapWidget(
      waterValues: waterValues,
      fractionDigits: widget.fractionDigits,
      title: "${widget.parameterName} Level Heatmap",
    );
  }

  Widget _makeHistogramWidget(List<WaterValue> waterValues) {
    return HistogramWidget(
      waterValues: waterValues,
      range: widget.histogrammRange,
      fractionDigits: widget.fractionDigits,
      title: 'Distribution in the last 24h',
    );
  }
}
