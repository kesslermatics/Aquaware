import 'package:aquaware/widgets/charts/heatmap_widget.dart';
import 'package:aquaware/widgets/charts/histogram_widget.dart';
import 'package:aquaware/widgets/charts/line_chart_widget.dart';
import 'package:aquaware/widgets/last_updated_widget.dart';
import 'package:aquaware/widgets/total_entries_widget.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/water_parameter_service.dart';
import 'package:aquaware/models/water_value.dart';

class DataScreen extends StatefulWidget {
  final int aquariumId;
  final String parameterName;
  final bool isLineChartVisible;
  final bool isHeatmapVisible;
  final bool isHistogrammVisible;
  final double histogrammRange;
  final String unit;
  final int fractionDigits;
  final double lineChartDeviation;

  DataScreen({
    required this.aquariumId,
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
  late Future<List<WaterValue>> _futureWaterValues;
  late Future<int> _futureTotalEntries;
  final WaterParameterService _waterParameterService = WaterParameterService();

  @override
  void initState() {
    super.initState();
    _futureWaterValues = _fetchWaterValues();
    _futureTotalEntries = _fetchTotalEntries();
  }

  Future<List<WaterValue>> _fetchWaterValues() async {
    return await _waterParameterService.fetchSingleWaterParameter(
      widget.aquariumId,
      widget.parameterName,
      numberOfEntries: 100,
    );
  }

  Future<int> _fetchTotalEntries() async {
    return await _waterParameterService.fetchTotalEntries(
      widget.aquariumId,
      widget.parameterName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<WaterValue>>(
        future: _futureWaterValues,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load water values'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No water values found'));
          } else {
            List<WaterValue> waterValues = snapshot.data!.reversed.toList();
            WaterValue lastWaterValue = waterValues.last;
            return FutureBuilder<int>(
              future: _futureTotalEntries,
              builder: (context, totalEntriesSnapshot) {
                if (totalEntriesSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (totalEntriesSnapshot.hasError) {
                  return Center(child: Text('Failed to load total entries'));
                } else if (!totalEntriesSnapshot.hasData) {
                  return Center(child: Text('No total entries found'));
                } else {
                  int totalEntries = totalEntriesSnapshot.data!;
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(8.0),
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
