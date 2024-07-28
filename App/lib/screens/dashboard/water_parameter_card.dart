import 'package:aquaware/screens/parameter_details/ammonia/ammonia_screen.dart';
import 'package:aquaware/screens/parameter_details/boron/boron_screen.dart';
import 'package:aquaware/screens/parameter_details/bromine/bromine_screen.dart';
import 'package:aquaware/screens/parameter_details/calcium/calcium_screen.dart';
import 'package:aquaware/screens/parameter_details/carbon_dioxide/carbon_dioxide_screen.dart';
import 'package:aquaware/screens/parameter_details/carbonate_hardness/carbonate_hardness_screen.dart';
import 'package:aquaware/screens/parameter_details/chloride/chloride_screen.dart';
import 'package:aquaware/screens/parameter_details/chlorine/chlorine_screen.dart';
import 'package:aquaware/screens/parameter_details/conductivity/conductivity_screen.dart';
import 'package:aquaware/screens/parameter_details/copper/copper_screen.dart';
import 'package:aquaware/screens/parameter_details/fluoride/fluoride_screen.dart';
import 'package:aquaware/screens/parameter_details/general_hardness/general_hardness_screen.dart';
import 'package:aquaware/screens/parameter_details/iodine/iodine_screen.dart';
import 'package:aquaware/screens/parameter_details/iron/iron_screen.dart';
import 'package:aquaware/screens/parameter_details/magnesium/magnesium_screen.dart';
import 'package:aquaware/screens/parameter_details/molybdenum/molybdenum_screen.dart';
import 'package:aquaware/screens/parameter_details/nitrate/nitrate_screen.dart';
import 'package:aquaware/screens/parameter_details/nitrite/nitrite_screen.dart';
import 'package:aquaware/screens/parameter_details/organic_carbon/organic_carbon_screen.dart';
import 'package:aquaware/screens/parameter_details/oxygen/oxygen_screen.dart';
import 'package:aquaware/screens/parameter_details/ph/ph_screen.dart';
import 'package:aquaware/screens/parameter_details/phosphate/phosphate_screen.dart';
import 'package:aquaware/screens/parameter_details/potassium/potassium_screen.dart';
import 'package:aquaware/screens/parameter_details/redox_potential/redox_potential_screen.dart';
import 'package:aquaware/screens/parameter_details/salinity/salinity_screen.dart';
import 'package:aquaware/screens/parameter_details/silica/silica_screen.dart';
import 'package:aquaware/screens/parameter_details/strontium/strontium_screen.dart';
import 'package:aquaware/screens/parameter_details/sulfate/sulfate_screen.dart';
import 'package:aquaware/screens/parameter_details/suspended_solids/suspended_solids_screen.dart';
import 'package:aquaware/screens/parameter_details/tds/tds_screen.dart';
import 'package:aquaware/screens/parameter_details/temperature/temperature_screen.dart';
import 'package:aquaware/screens/parameter_details/turbidity/turbidity_screen.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/models/water_parameter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WaterParameterCard extends StatefulWidget {
  final WaterParameter waterParameter;
  final int aquariumId;

  WaterParameterCard({required this.aquariumId, required this.waterParameter});

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
    data = widget.waterParameter.values.map((e) => e.value).toList();
    dates = widget.waterParameter.values
        .map((e) => e.measuredAt.toIso8601String())
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
    return GestureDetector(
      onTap: () =>
          _navigateToDetailScreen(context, widget.waterParameter.parameter),
      child: Card(
        margin: EdgeInsets.fromLTRB(14, 10, 14, 0),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _getIconForParameter(widget.waterParameter.parameter),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: Text(
                            '${widget.waterParameter.parameter} (${latestValue.unit})',
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
                            latestValue.value.toString(),
                            key: ValueKey<double>(latestValue.value),
                            style: TextStyle(fontSize: 24),
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
                        style: TextStyle(fontSize: 10),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: LineChart(mainData()),
                        ),
                      ),
                      Text(
                        minY.toStringAsFixed(2),
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: ColorProvider.textDark,
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
      clipData: FlClipData.all(),
      gridData: FlGridData(show: false),
      minY: minY,
      maxY: maxY,
      minX: 1,
      maxX: data.length.toDouble(),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: _getColorForParameter(widget.waterParameter.parameter),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
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

  final Map<String, Widget Function(BuildContext, int)> parameterScreens = {
    'temperature': (context, aquariumId) =>
        TemperatureScreen(aquariumId: aquariumId),
    'ph': (context, aquariumId) => PHScreen(aquariumId: aquariumId),
    'tds': (context, aquariumId) => TDSScreen(aquariumId: aquariumId),
    'oxygen': (context, aquariumId) => OxygenScreen(aquariumId: aquariumId),
    'ammonia': (context, aquariumId) => AmmoniaScreen(aquariumId: aquariumId),
    'nitrite': (context, aquariumId) => NitriteScreen(aquariumId: aquariumId),
    'nitrate': (context, aquariumId) => NitrateScreen(aquariumId: aquariumId),
    'phosphate': (context, aquariumId) =>
        PhosphateScreen(aquariumId: aquariumId),
    'carbon dioxide': (context, aquariumId) =>
        CarbonDioxideScreen(aquariumId: aquariumId),
    'salinity': (context, aquariumId) => SalinityScreen(aquariumId: aquariumId),
    'general hardness': (context, aquariumId) =>
        GeneralHardnessScreen(aquariumId: aquariumId),
    'carbonate hardness': (context, aquariumId) =>
        CarbonateHardnessScreen(aquariumId: aquariumId),
    'copper': (context, aquariumId) => CopperScreen(aquariumId: aquariumId),
    'iron': (context, aquariumId) => IronScreen(aquariumId: aquariumId),
    'calcium': (context, aquariumId) => CalciumScreen(aquariumId: aquariumId),
    'magnesium': (context, aquariumId) =>
        MagnesiumScreen(aquariumId: aquariumId),
    'potassium': (context, aquariumId) =>
        PotassiumScreen(aquariumId: aquariumId),
    'chlorine': (context, aquariumId) => ChlorineScreen(aquariumId: aquariumId),
    'redox potential': (context, aquariumId) =>
        RedoxPotentialScreen(aquariumId: aquariumId),
    'silica': (context, aquariumId) => SilicaScreen(aquariumId: aquariumId),
    'boron': (context, aquariumId) => BoronScreen(aquariumId: aquariumId),
    'strontium': (context, aquariumId) =>
        StrontiumScreen(aquariumId: aquariumId),
    'iodine': (context, aquariumId) => IodineScreen(aquariumId: aquariumId),
    'molybdenum': (context, aquariumId) =>
        MolybdenumScreen(aquariumId: aquariumId),
    'sulfate': (context, aquariumId) => SulfateScreen(aquariumId: aquariumId),
    'organic carbon': (context, aquariumId) =>
        OrganicCarbonScreen(aquariumId: aquariumId),
    'turbidity': (context, aquariumId) =>
        TurbidityScreen(aquariumId: aquariumId),
    'conductivity': (context, aquariumId) =>
        ConductivityScreen(aquariumId: aquariumId),
    'suspended solids': (context, aquariumId) =>
        SuspendedSolidsScreen(aquariumId: aquariumId),
    'fluoride': (context, aquariumId) => FluorideScreen(aquariumId: aquariumId),
    'bromine': (context, aquariumId) => BromineScreen(aquariumId: aquariumId),
    'chloride': (context, aquariumId) => ChlorideScreen(aquariumId: aquariumId),
  };

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
}
