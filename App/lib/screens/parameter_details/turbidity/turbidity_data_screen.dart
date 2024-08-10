import 'package:aquaware/widgets/charts/heatmap_widget.dart';
import 'package:aquaware/widgets/charts/line_chart_widget.dart';
import 'package:aquaware/widgets/last_updated_widget.dart';
import 'package:aquaware/widgets/total_entries_widget.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/water_parameter_service.dart';
import 'package:aquaware/models/water_value.dart';
import 'package:aquaware/services/color_provider.dart';

class TurbidityDataScreen extends StatefulWidget {
  final int aquariumId;

  TurbidityDataScreen({required this.aquariumId});

  @override
  _TurbidityDataScreenState createState() => _TurbidityDataScreenState();
}

class _TurbidityDataScreenState extends State<TurbidityDataScreen> {
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
        widget.aquariumId, 'Turbidity',
        numberOfEntries: 100);
  }

  Future<int> _fetchTotalEntries() async {
    return await _waterParameterService.fetchTotalEntries(
        widget.aquariumId, 'Turbidity');
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
                        _makeLineChartWidget(waterValues),
                        _makeHeatmapWidget(waterValues),
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
        waterValues.map((value) => value.measuredAt).toList().toList();
    List<double> yValues = waterValues.map((value) => value.value).toList();
    double yDeviation = 1.0; // Example deviation for Turbidity
    return LineChartWidget(
      xValues: xValues,
      yValues: yValues,
      yDeviation: yDeviation,
      fractionDigits: 2,
      title: 'Turbidity Levels over Time',
      xAxisLabel: 'Time',
      yAxisLabel: 'Turbidity (NTU)',
    );
  }

  Widget _makeHeatmapWidget(List<WaterValue> waterValues) {
    return HeatmapWidget(
      waterValues: waterValues,
      fractionDigits: 2,
      title: "Turbidity Level Heatmap",
    );
  }
}
