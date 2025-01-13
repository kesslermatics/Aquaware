import 'package:aquaware/models/water_value.dart';
import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:aquaware/screens/dashboard/data_screen.dart';
import 'package:aquaware/screens/dashboard/parameter_screen.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/services/water_parameter_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/models/water_parameter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WaterParameterCard extends StatefulWidget {
  final WaterParameter waterParameter;
  final int aquariumId;

  const WaterParameterCard(
      {super.key, required this.aquariumId, required this.waterParameter});

  @override
  _WaterParameterCardState createState() => _WaterParameterCardState();
}

class _WaterParameterCardState extends State<WaterParameterCard> {
  late List<Color> gradientColors;
  late List<double> data;
  late List<String> dates;
  late double deviation;
  late double yInterval;
  late double xInterval;
  late double minY;
  late double maxY;

  @override
  void initState() {
    super.initState();
    gradientColors = [Colors.blue, Colors.blueAccent];
    data = widget.waterParameter.values
        .map((e) => e.value)
        .toList()
        .reversed
        .toList();
    dates = widget.waterParameter.values
        .map((e) => e.measuredAt.toIso8601String())
        .toList()
        .reversed
        .toList();
    deviation = (data.reduce((a, b) => a > b ? a : b) -
            data.reduce((a, b) => a < b ? a : b)) /
        10;
    yInterval = deviation / 2;
    xInterval = 1;
    minY = data.reduce((a, b) => a < b ? a : b) - deviation;
    maxY = data.reduce((a, b) => a > b ? a : b) + deviation;
  }

  @override
  Widget build(BuildContext context) {
    final latestValue = widget.waterParameter.values.first;
    String unit = "";
    if (latestValue.unit.isNotEmpty) {
      unit = "(${latestValue.unit})";
    }
    return GestureDetector(
      onTap: () =>
          _navigateToDetailScreen(context, widget.waterParameter.parameter),
      child: Card(
        color: ColorProvider.n6,
        margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _getIconForParameter(widget.waterParameter.parameter),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Text(
                            '${widget.waterParameter.parameter} $unit',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: ColorProvider.n1,
                            ),
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
                            latestValue.value.toString(),
                            key: ValueKey<double>(latestValue.value),
                            style: const TextStyle(
                              fontSize: 24,
                              color: ColorProvider.n1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: VerticalDivider(
                    color:
                        _getColorForParameter(widget.waterParameter.parameter),
                    thickness: 2,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        maxY.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 10),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: LineChart(mainData()),
                        ),
                      ),
                      Text(
                        minY.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: ColorProvider.n1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LineChartData mainData() {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(double.parse((i + 1).toString()), data[i]));
    }

    return LineChartData(
      clipData: const FlClipData.all(),
      gridData: const FlGridData(show: false),
      minY: minY - (maxY - minY),
      maxY: maxY + (maxY - minY),
      minX: 1,
      maxX: data.length.toDouble(),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: _getColorForParameter(widget.waterParameter.parameter),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  void _navigateToDetailScreen(BuildContext context, String parameter) {
    final screenBuilder = parameterScreens[parameter.toLowerCase()];
    if (screenBuilder != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => screenBuilder(context, widget.aquariumId),
        ),
      );
    } else {
      // Handle unknown parameter screen navigation if needed
    }
  }

  Widget _getIconForParameter(String parameter) {
    return Icon(
      parameterIcons[parameter.toLowerCase()] ?? Icons.device_thermostat,
      color: _getColorForParameter(parameter),
      size: 40,
    );
  }

  Color _getColorForParameter(String parameter) {
    return parameterColors[parameter.toLowerCase()] ?? Colors.grey;
  }

  final Map<String, IconData> parameterIcons = {
    'temperature': Icons.thermostat,
    'ph': Icons.opacity,
    'tds': Icons.invert_colors,
    'oxygen': Icons.air,
    'ammonia': Icons.warning,
    'nitrite': Icons.report_problem,
    'nitrate': Icons.grain,
    'phosphate': Icons.eco,
    'carbon dioxide': Icons.cloud,
    'salinity': Icons.waves,
    'general hardness': Icons.diamond,
    'carbonate hardness': Icons.filter_hdr,
    'copper': Icons.circle,
    'iron': Icons.local_fire_department,
    'calcium': FontAwesomeIcons.bone,
    'magnesium': Icons.star,
    'potassium': Icons.flash_on,
    'chlorine': Icons.shield,
    'alkalinity': Icons.bubble_chart,
    'redox potential': Icons.electrical_services,
    'silica': Icons.spa,
    'boron': Icons.scatter_plot,
    'strontium': Icons.radio_button_checked,
    'iodine': Icons.lightbulb,
    'molybdenum': Icons.flash_auto,
    'sulfate': Icons.bubble_chart,
    'organic carbon': Icons.nature,
    'turbidity': Icons.cloud,
    'conductivity': Icons.offline_bolt,
    'total organic carbon': Icons.grass,
    'suspended solids': Icons.filter_drama,
    'fluoride': Icons.invert_colors,
    'bromine': Icons.flare,
    'chloride': Icons.shield,
  };

  final Map<String, Color> parameterColors = {
    'temperature': Colors.red,
    'ph': Colors.blue,
    'tds': Colors.brown,
    'oxygen': Colors.lightBlue,
    'ammonia': Colors.orange,
    'nitrite': Colors.purple,
    'nitrate': Colors.pink,
    'phosphate': Colors.green,
    'carbon dioxide': Colors.grey,
    'salinity': Colors.cyan,
    'general hardness': Colors.blueGrey,
    'carbonate hardness': Colors.teal,
    'copper': Colors.deepOrange,
    'iron': Colors.redAccent,
    'calcium': Colors.grey,
    'magnesium': Colors.blueAccent,
    'potassium': Colors.yellow,
    'chlorine': Colors.greenAccent,
    'alkalinity': Colors.lightGreen,
    'redox potential': Colors.deepPurple,
    'silica': Colors.brown,
    'boron': Colors.purpleAccent,
    'strontium': Colors.blue,
    'iodine': Colors.yellowAccent,
    'molybdenum': Colors.orangeAccent,
    'sulfate': Colors.blueGrey,
    'organic carbon': Colors.green,
    'turbidity': Colors.lightBlue,
    'conductivity': Colors.indigo,
    'total organic carbon': Colors.green,
    'suspended solids': Colors.grey,
    'fluoride': Colors.lightBlue,
    'bromine': Colors.red,
    'chloride': Colors.blueAccent,
  };

  Widget createParameterScreen({
    required BuildContext context,
    required int aquariumId,
    required String parameterName,
    required String unit,
    required double histogrammRange,
    required int fractionDigits,
    required double lineChartDeviation,
    required String alertInfoText,
  }) {
    final WaterParameterService waterParameterService = WaterParameterService();

    // Lade die Daten und die Gesamtanzahl der Einträge vorab
    final Future<List<WaterValue>> futureWaterValues =
        waterParameterService.fetchSingleWaterParameter(
      aquariumId,
      parameterName,
      numberOfEntries: 100,
    );

    final Future<int> futureTotalEntries =
        waterParameterService.fetchTotalEntries(
      aquariumId,
      parameterName,
    );

    return ParameterScreen(
      aquariumId: aquariumId,
      parameterName: parameterName,
      dataScreenBuilder: (futureWaterValues, futureTotalEntries) => DataScreen(
        futureWaterValues: futureWaterValues,
        futureTotalEntries: futureTotalEntries,
        parameterName: parameterName,
        isLineChartVisible: true,
        isHeatmapVisible: true,
        isHistogrammVisible: true,
        histogrammRange: histogrammRange,
        unit: unit,
        fractionDigits: fractionDigits,
        lineChartDeviation: lineChartDeviation,
      ),
      alertScreen: AlertScreen(
        infotext: alertInfoText,
        parameterName: parameterName,
        aquariumId: aquariumId,
        unit: unit,
      ),
    );
  }

  final Map<String, Widget Function(BuildContext, int)> parameterScreens = {
    'ammonia': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Ammonia',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.ammonia, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.01,
          unit: 'ppm',
          fractionDigits: 3,
          lineChartDeviation: 0.1,
        ),
        alertScreen: AlertScreen(
          infotext: loc.ammoniaInfo,
          parameterName: loc.ammonia,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'boron': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Boron',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.boron, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.01,
          unit: 'ppm',
          fractionDigits: 3,
          lineChartDeviation: 0.1,
        ),
        alertScreen: AlertScreen(
          infotext: loc.boronInfo,
          parameterName: loc.boron,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'bromine': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Bromine',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.bromine, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.01,
          unit: 'ppm',
          fractionDigits: 3,
          lineChartDeviation: 0.1,
        ),
        alertScreen: AlertScreen(
          infotext: loc.bromineInfo,
          parameterName: loc.bromine,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'calcium': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Calcium',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.calcium, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.01,
          unit: 'ppm',
          fractionDigits: 3,
          lineChartDeviation: 0.1,
        ),
        alertScreen: AlertScreen(
          infotext: loc.calciumInfo,
          parameterName: loc.calcium,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'carbon dioxide': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Carbon Dioxide',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.carbonDioxide, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.01,
          unit: 'ppm',
          fractionDigits: 3,
          lineChartDeviation: 0.1,
        ),
        alertScreen: AlertScreen(
          infotext: loc.carbonDioxideInfo,
          parameterName: loc.carbonDioxide,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'carbonate hardness': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Carbonate Hardness',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.carbonateHardness, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.1,
          unit: 'dKH',
          fractionDigits: 2,
          lineChartDeviation: 0.2,
        ),
        alertScreen: AlertScreen(
          infotext: loc.carbonateHardnessInfo,
          parameterName: loc.carbonateHardness,
          aquariumId: aquariumId,
          unit: 'dKH',
        ),
      );
    },
    'chloride': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Chloride',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.chloride, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.1,
          unit: 'mg/L',
          fractionDigits: 2,
          lineChartDeviation: 0.2,
        ),
        alertScreen: AlertScreen(
          infotext: loc.chlorideInfo,
          parameterName: loc.chloride,
          aquariumId: aquariumId,
          unit: 'mg/L',
        ),
      );
    },
    'chlorine': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Chlorine',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.chlorine, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.1,
          unit: 'ppm',
          fractionDigits: 2,
          lineChartDeviation: 0.2,
        ),
        alertScreen: AlertScreen(
          infotext: loc.chlorineInfo,
          parameterName: loc.chlorine,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'conductivity': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Conductivity',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.conductivity, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 10.0,
          unit: 'µS/cm',
          fractionDigits: 0,
          lineChartDeviation: 50.0,
        ),
        alertScreen: AlertScreen(
          infotext: loc.conductivityInfo,
          parameterName: loc.conductivity,
          aquariumId: aquariumId,
          unit: 'µS/cm',
        ),
      );
    },
    'copper': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Copper',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.copper, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.01,
          unit: 'ppm',
          fractionDigits: 3,
          lineChartDeviation: 0.05,
        ),
        alertScreen: AlertScreen(
          infotext: loc.copperInfo,
          parameterName: loc.copper,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'fluoride': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Fluoride',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.fluoride, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.1,
          unit: 'ppm',
          fractionDigits: 2,
          lineChartDeviation: 0.2,
        ),
        alertScreen: AlertScreen(
          infotext: loc.fluorideInfo,
          parameterName: loc.fluoride,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'general hardness': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'General Hardness',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.generalHardness, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 1.0,
          unit: 'dGH',
          fractionDigits: 1,
          lineChartDeviation: 1.0,
        ),
        alertScreen: AlertScreen(
          infotext: loc.generalHardnessInfo,
          parameterName: loc.generalHardness,
          aquariumId: aquariumId,
          unit: 'dGH',
        ),
      );
    },
    'iodine': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Iodine',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.iodine, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.01,
          unit: 'ppm',
          fractionDigits: 3,
          lineChartDeviation: 0.05,
        ),
        alertScreen: AlertScreen(
          infotext: loc.iodineInfo,
          parameterName: loc.iodine,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'iron': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Iron',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.iron, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.01,
          unit: 'ppm',
          fractionDigits: 3,
          lineChartDeviation: 0.05,
        ),
        alertScreen: AlertScreen(
          infotext: loc.ironInfo,
          parameterName: loc.iron,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'magnesium': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Magnesium',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.magnesium, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 10.0,
          unit: 'ppm',
          fractionDigits: 0,
          lineChartDeviation: 50.0,
        ),
        alertScreen: AlertScreen(
          infotext: loc.magnesiumInfo,
          parameterName: loc.magnesium,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'molybdenum': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Molybdenum',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.molybdenum, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.001,
          unit: 'ppm',
          fractionDigits: 3,
          lineChartDeviation: 0.005,
        ),
        alertScreen: AlertScreen(
          infotext: loc.molybdenumInfo,
          parameterName: loc.molybdenum,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'nitrate': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Nitrate',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.nitrate, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 1.0,
          unit: 'ppm',
          fractionDigits: 1,
          lineChartDeviation: 5.0,
        ),
        alertScreen: AlertScreen(
          infotext: loc.nitrateInfo,
          parameterName: loc.nitrate,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'nitrite': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Nitrite',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.nitrite, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.01,
          unit: 'ppm',
          fractionDigits: 3,
          lineChartDeviation: 0.05,
        ),
        alertScreen: AlertScreen(
          infotext: loc.nitriteInfo,
          parameterName: loc.nitrite,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'organic carbon': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Organic Carbon',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.organicCarbon, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.1,
          unit: 'mg/L',
          fractionDigits: 1,
          lineChartDeviation: 0.5,
        ),
        alertScreen: AlertScreen(
          infotext: loc.organicCarbonInfo,
          parameterName: loc.organicCarbon,
          aquariumId: aquariumId,
          unit: 'mg/L',
        ),
      );
    },
    'oxygen': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Oxygen',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.oxygen, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.1,
          unit: 'mg/L',
          fractionDigits: 1,
          lineChartDeviation: 0.5,
        ),
        alertScreen: AlertScreen(
          infotext: loc.oxygenInfo,
          parameterName: loc.oxygen,
          aquariumId: aquariumId,
          unit: 'mg/L',
        ),
      );
    },
    'ph': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'PH',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.ph, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.1,
          unit: '',
          fractionDigits: 2,
          lineChartDeviation: 0.2,
        ),
        alertScreen: AlertScreen(
          infotext: loc.phInfo,
          parameterName: loc.ph,
          aquariumId: aquariumId,
          unit: '',
        ),
      );
    },
    'phosphate': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Phosphate',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.phosphate, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.1,
          unit: 'ppm',
          fractionDigits: 2,
          lineChartDeviation: 0.2,
        ),
        alertScreen: AlertScreen(
          infotext: loc.phosphateInfo,
          parameterName: loc.phosphate,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'potassium': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Potassium',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.potassium, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 1.0,
          unit: 'ppm',
          fractionDigits: 1,
          lineChartDeviation: 5.0,
        ),
        alertScreen: AlertScreen(
          infotext: loc.potassiumInfo,
          parameterName: loc.potassium,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'redox potential': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Redox Potential',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.redoxPotential, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 10.0,
          unit: 'mV',
          fractionDigits: 0,
          lineChartDeviation: 50.0,
        ),
        alertScreen: AlertScreen(
          infotext: loc.redoxPotentialInfo,
          parameterName: loc.redoxPotential,
          aquariumId: aquariumId,
          unit: 'mV',
        ),
      );
    },
    'salinity': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Salinity',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.salinity, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.001,
          unit: 'specific gravity',
          fractionDigits: 3,
          lineChartDeviation: 0.005,
        ),
        alertScreen: AlertScreen(
          infotext: loc.salinityInfo,
          parameterName: loc.salinity,
          aquariumId: aquariumId,
          unit: 'specific gravity',
        ),
      );
    },
    'silica': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Silica',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.silica, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.1,
          unit: 'mg/L',
          fractionDigits: 1,
          lineChartDeviation: 0.5,
        ),
        alertScreen: AlertScreen(
          infotext: loc.silicaInfo,
          parameterName: loc.silica,
          aquariumId: aquariumId,
          unit: 'mg/L',
        ),
      );
    },
    'strontium': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Strontium',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.strontium, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 1.0,
          unit: 'ppm',
          fractionDigits: 1,
          lineChartDeviation: 5.0,
        ),
        alertScreen: AlertScreen(
          infotext: loc.strontiumInfo,
          parameterName: loc.strontium,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'sulfate': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Sulfate',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.sulfate, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 10.0,
          unit: 'mg/L',
          fractionDigits: 0,
          lineChartDeviation: 50.0,
        ),
        alertScreen: AlertScreen(
          infotext: loc.sulfateInfo,
          parameterName: loc.sulfate,
          aquariumId: aquariumId,
          unit: 'mg/L',
        ),
      );
    },
    'suspended solids': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Suspended Solids',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.suspendedSolids, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 1.0,
          unit: 'mg/L',
          fractionDigits: 1,
          lineChartDeviation: 5.0,
        ),
        alertScreen: AlertScreen(
          infotext: loc.suspendedSolidsInfo,
          parameterName: loc.suspendedSolids,
          aquariumId: aquariumId,
          unit: 'mg/L',
        ),
      );
    },
    'tds': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'TDS',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.tds, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 10.0,
          unit: 'ppm',
          fractionDigits: 0,
          lineChartDeviation: 50.0,
        ),
        alertScreen: AlertScreen(
          infotext: loc.tdsInfo,
          parameterName: loc.tds,
          aquariumId: aquariumId,
          unit: 'ppm',
        ),
      );
    },
    'temperature': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Temperature',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.temperature, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 0.5,
          unit: '°C',
          fractionDigits: 1,
          lineChartDeviation: 0.5,
        ),
        alertScreen: AlertScreen(
          infotext: loc.temperatureInfo,
          parameterName: loc.temperature,
          aquariumId: aquariumId,
          unit: '°C',
        ),
      );
    },
    'turbidity': (context, aquariumId) {
      final loc = AppLocalizations.of(context)!;
      return ParameterScreen(
        aquariumId: aquariumId,
        parameterName: 'Turbidity',
        dataScreenBuilder: (futureWaterValues, futureTotalEntries) =>
            DataScreen(
          futureWaterValues: futureWaterValues,
          futureTotalEntries: futureTotalEntries,
          parameterName: loc.turbidity, // Übersetzt
          isLineChartVisible: true,
          isHeatmapVisible: true,
          isHistogrammVisible: true,
          histogrammRange: 1.0,
          unit: 'NTU',
          fractionDigits: 1,
          lineChartDeviation: 5.0,
        ),
        alertScreen: AlertScreen(
          infotext: loc.turbidityInfo,
          parameterName: loc.turbidity,
          aquariumId: aquariumId,
          unit: 'NTU',
        ),
      );
    },
  };
}
