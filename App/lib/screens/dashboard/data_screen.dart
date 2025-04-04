import 'package:aquaware/widgets/charts/heatmap_widget.dart';
import 'package:aquaware/widgets/charts/histogram_widget.dart';
import 'package:aquaware/widgets/charts/line_chart_widget.dart';
import 'package:aquaware/widgets/last_updated_widget.dart';
import 'package:aquaware/widgets/total_entries_widget.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/water_parameter_service.dart';
import 'package:aquaware/models/water_value.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String _statusText = "";
  late Future<List<WaterValue>> _futureWaterValues;
  late Future<int> _futureTotalEntries;

  @override
  void initState() {
    super.initState();
    _progress = 0.2; // Initial progress
    _loadFutures();
  }

  void _loadFutures() {
    _futureWaterValues = widget.futureWaterValues;
    _futureTotalEntries = widget.futureTotalEntries;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lokalisierung in didChangeDependencies initialisieren
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    final loc = AppLocalizations.of(context)!;

    setState(() {
      _progress = 0.2;
      _statusText = loc.fetchingWaterValues;
    });

    // Warte auf beide FutureBuilder-Datenquellen gleichzeitig
    await Future.wait([widget.futureWaterValues, widget.futureTotalEntries]);

    setState(() {
      _progress = 1.0;
      _statusText = loc.loadingComplete;
    });
  }

  Future<void> _refreshData() async {
    _loadFutures();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<WaterValue>>(
          future: _futureWaterValues,
          builder: (context, snapshot) {
            if (_progress < 1.0 ||
                snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingWidget();
            }

            if (snapshot.hasError) {
              return Center(
                child:
                    Text(AppLocalizations.of(context)!.failedToLoadWaterValues),
              );
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noWaterValuesFound),
              );
            } else {
              List<WaterValue> waterValues = snapshot.data!.reversed.toList();
              WaterValue lastWaterValue = waterValues.last;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LastUpdatedWidget(lastWaterValue: lastWaterValue),
                    FutureBuilder<int>(
                      future: _futureTotalEntries,
                      builder: (context, totalEntriesSnapshot) {
                        if (totalEntriesSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: ColorProvider.n17,
                            ),
                          );
                        } else if (totalEntriesSnapshot.hasError) {
                          return Center(
                              child: Text(AppLocalizations.of(context)!
                                  .failedToLoadTotalEntries));
                        } else if (!totalEntriesSnapshot.hasData) {
                          return Center(
                              child: Text(AppLocalizations.of(context)!
                                  .noTotalEntriesFound));
                        } else {
                          int totalEntries = totalEntriesSnapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TotalEntriesWidget(totalEntries: totalEntries),
                              if (widget.isLineChartVisible)
                                _makeLineChartWidget(waterValues),
                              if (widget.isHeatmapVisible)
                                _makeHeatmapWidget(waterValues),
                              if (widget.isHistogrammVisible)
                                _makeHistogramWidget(waterValues),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
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
    final loc = AppLocalizations.of(context)!;
    List<DateTime> xValues =
        waterValues.map((value) => value.measuredAt).toList();
    List<double> yValues = waterValues.map((value) => value.value).toList();
    return LineChartWidget(
      xValues: xValues,
      yValues: yValues,
      yDeviation: widget.lineChartDeviation,
      fractionDigits: widget.fractionDigits,
      title: loc.lineChartTitle(widget.parameterName),
      xAxisLabel: loc.xAxisLabel,
      yAxisLabel: loc.yAxisLabel(widget.parameterName, widget.unit),
    );
  }

  Widget _makeHeatmapWidget(List<WaterValue> waterValues) {
    final loc = AppLocalizations.of(context)!;
    return HeatmapWidget(
      waterValues: waterValues,
      fractionDigits: widget.fractionDigits,
      title: loc.heatmapTitle(widget.parameterName),
    );
  }

  Widget _makeHistogramWidget(List<WaterValue> waterValues) {
    final loc = AppLocalizations.of(context)!;
    return HistogramWidget(
      waterValues: waterValues,
      range: widget.histogrammRange,
      fractionDigits: widget.fractionDigits,
      title: loc.histogramTitle,
    );
  }
}
