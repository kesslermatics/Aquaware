import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:aquaware/screens/dashboard/data_screen.dart';
import 'package:aquaware/screens/dashboard/parameter_screen.dart';
import 'package:aquaware/screens/parameter_details/ammonia/ammonia_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/boron/boron_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/bromine/bromine_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/calcium/calcium_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/carbon_dioxide/carbon_dioxide_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/carbonate_hardness/carbonate_hardness_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/chloride/chloride_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/chlorine/chlorine_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/conductivity/conductivity_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/copper/copper_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/fluoride/fluoride_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/general_hardness/general_hardness_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/iodine/iodine_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/iron/iron_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/magnesium/magnesium_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/molybdenum/molybdenum_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/nitrate/nitrate_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/nitrite/nitrite_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/organic_carbon/organic_carbon_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/oxygen/oxygen_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/ph/ph_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/phosphate/phosphate_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/potassium/potassium_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/redox_potential/redox_potential_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/salinity/salinity_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/silica/silica_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/strontium/strontium_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/sulfate/sulfate_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/suspended_solids/suspended_solids_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/tds/tds_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/temperature/temperature_knowledge_screen.dart';
import 'package:aquaware/screens/parameter_details/turbidity/turbidity_knowledge_screen.dart';
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
                            '${widget.waterParameter.parameter} $unit',
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
      minY: minY - (maxY - minY),
      maxY: maxY + (maxY - minY),
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
    required Widget knowledgeScreen,
  }) {
    return ParameterScreen(
      aquariumId: aquariumId,
      parameterName: parameterName,
      dataScreen: DataScreen(
        aquariumId: aquariumId,
        parameterName: parameterName,
        isLineChartVisible: true,
        isHeatmapVisible: true,
        isHistogrammVisible: true,
        histogrammRange: histogrammRange,
        unit: unit,
        fractionDigits: fractionDigits,
        lineChartDeviation: lineChartDeviation,
      ),
      knowledgeScreen: knowledgeScreen,
      alertScreen: AlertScreen(
        infotext: alertInfoText,
        parameterName: parameterName,
        aquariumId: aquariumId,
        unit: unit,
      ),
    );
  }

  final Map<String, Widget Function(BuildContext, int)> parameterScreens = {
    'ammonia': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Ammonia',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Ammonia',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.01,
            unit: 'ppm',
            fractionDigits: 3,
            lineChartDeviation: 0.1,
          ),
          knowledgeScreen: AmmoniaKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Ammonia levels that are too high can be dangerous for your fish, leading to stress, illness, and even death. '
                'Ideally, ammonia levels should be kept at 0 ppm. '
                "An appropriate alert can be to notify when ammonia levels are above 0.1.",
            parameterName: "Ammonia",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'boron': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Boron',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Boron',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.01,
            unit: 'ppm',
            fractionDigits: 3,
            lineChartDeviation: 0.1,
          ),
          knowledgeScreen: BoronKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High levels of boron can be toxic to plants and invertebrates in your aquarium. '
                'It can also lead to stress and illness in sensitive fish species. '
                "An appropriate alert can be to notify when boron levels are above 1.0 ppm, depending on the species in your tank.",
            parameterName: "Boron",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'bromine': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Bromine',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Bromine',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.01,
            unit: 'ppm',
            fractionDigits: 3,
            lineChartDeviation: 0.1,
          ),
          knowledgeScreen: BromineKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Elevated bromine levels can be harmful to fish, leading to respiratory problems and stress. '
                'In extreme cases, it can be lethal. '
                "An appropriate alert can be to notify when bromine levels are above 0.1 ppm.",
            parameterName: "Bromine",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'calcium': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Calcium',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Calcium',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.01,
            unit: 'ppm',
            fractionDigits: 3,
            lineChartDeviation: 0.1,
          ),
          knowledgeScreen: CalciumKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High calcium levels can lead to water hardness issues, which might cause stress in soft water fish. '
                'On the other hand, low calcium levels can lead to poor shell development in invertebrates. '
                "An appropriate alert can be to notify when calcium levels are above 450 ppm or below 300 ppm.",
            parameterName: "Calcium",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'carbon dioxide': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Carbon Dioxide',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Carbon Dioxide',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.01,
            unit: 'ppm',
            fractionDigits: 3,
            lineChartDeviation: 0.1,
          ),
          knowledgeScreen: CarbonDioxideKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Excessive carbon dioxide (CO2) can lower the pH of your aquarium, leading to stress and respiratory issues in fish. '
                'In extreme cases, it can cause suffocation. '
                "An appropriate alert can be to notify when CO2 levels are above 30 ppm.",
            parameterName: "Carbon Dioxide",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'carbonate hardness': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Carbonate Hardness',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Carbonate Hardness',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.1,
            unit: 'dKH',
            fractionDigits: 2,
            lineChartDeviation: 0.2,
          ),
          knowledgeScreen: CarbonateHardnessKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High carbonate hardness (KH) levels can cause pH stability issues, making it difficult to adjust pH levels. '
                'Low KH can lead to sudden pH swings, which are harmful to fish. '
                "An appropriate alert can be to notify when carbonate hardness is above 12 dKH or below 4 dKH.",
            parameterName: "Carbonate Hardness",
            aquariumId: aquariumId,
            unit: 'dKH',
          ),
        ),
    'chloride': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Chloride',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Chloride',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.1,
            unit: 'mg/L',
            fractionDigits: 2,
            lineChartDeviation: 0.2,
          ),
          knowledgeScreen: ChlorideKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High chloride levels can indicate contamination and may lead to stress in freshwater fish. '
                "An appropriate alert can be to notify when chloride levels are above 250 mg/L.",
            parameterName: "Chloride",
            aquariumId: aquariumId,
            unit: 'mg/L',
          ),
        ),
    'chlorine': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Chlorine',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Chlorine',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.1,
            unit: 'ppm',
            fractionDigits: 2,
            lineChartDeviation: 0.2,
          ),
          knowledgeScreen: ChlorineKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Excess chlorine can be toxic to all aquatic life, leading to severe stress, gill damage, and death. '
                "An appropriate alert can be to notify when chlorine levels are detectable (above 0 ppm).",
            parameterName: "Chlorine",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'conductivity': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Conductivity',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Conductivity',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 10.0,
            unit: 'µS/cm',
            fractionDigits: 0,
            lineChartDeviation: 50.0,
          ),
          knowledgeScreen: ConductivityKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High conductivity often indicates high levels of dissolved salts, which can be harmful to fish not adapted to such conditions. '
                "An appropriate alert can be to notify when conductivity exceeds 2000 µS/cm in freshwater aquariums.",
            parameterName: "Conductivity",
            aquariumId: aquariumId,
            unit: 'µS/cm',
          ),
        ),
    'copper': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Copper',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Copper',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.01,
            unit: 'ppm',
            fractionDigits: 3,
            lineChartDeviation: 0.05,
          ),
          knowledgeScreen: CopperKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Elevated copper levels can be highly toxic to invertebrates and sensitive fish species, leading to death. '
                "An appropriate alert can be to notify when copper levels exceed 0.1 ppm.",
            parameterName: "Copper",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'fluoride': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Fluoride',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Fluoride',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.1,
            unit: 'ppm',
            fractionDigits: 2,
            lineChartDeviation: 0.2,
          ),
          knowledgeScreen: FluorideKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High fluoride levels can be harmful to fish, causing stress and potential organ damage over time. '
                "An appropriate alert can be to notify when fluoride levels exceed 1.5 ppm.",
            parameterName: "Fluoride",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'general hardness': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'General Hardness',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'General Hardness',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 1.0,
            unit: 'dGH',
            fractionDigits: 1,
            lineChartDeviation: 1.0,
          ),
          knowledgeScreen: GeneralHardnessKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'General hardness (GH) measures the total concentration of calcium and magnesium. '
                'Water that is too hard or too soft can stress fish and affect their osmoregulation. '
                "An appropriate alert can be to notify when GH is above 14 dGH or below 4 dGH, depending on the species.",
            parameterName: "General Hardness",
            aquariumId: aquariumId,
            unit: 'dGH',
          ),
        ),
    'iodine': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Iodine',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Iodine',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.01,
            unit: 'ppm',
            fractionDigits: 3,
            lineChartDeviation: 0.05,
          ),
          knowledgeScreen: IodineKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Iodine is necessary for invertebrate health but in high concentrations, it can be toxic to both fish and invertebrates. '
                "An appropriate alert can be to notify when iodine levels are above 0.06 ppm.",
            parameterName: "Iodine",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'iron': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Iron',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Iron',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.01,
            unit: 'ppm',
            fractionDigits: 3,
            lineChartDeviation: 0.05,
          ),
          knowledgeScreen: IronKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High iron levels can lead to excessive algae growth and may be toxic to invertebrates and some fish species. '
                "An appropriate alert can be to notify when iron levels exceed 0.2 ppm.",
            parameterName: "Iron",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'magnesium': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Magnesium',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Magnesium',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 10.0,
            unit: 'ppm',
            fractionDigits: 0,
            lineChartDeviation: 50.0,
          ),
          knowledgeScreen: MagnesiumKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Magnesium is crucial for coral and invertebrate health, but excessive levels can disrupt water chemistry and harm aquatic life. '
                "An appropriate alert can be to notify when magnesium levels are above 1500 ppm.",
            parameterName: "Magnesium",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'molybdenum': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Molybdenum',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Molybdenum',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.001,
            unit: 'ppm',
            fractionDigits: 3,
            lineChartDeviation: 0.005,
          ),
          knowledgeScreen: MolybdenumKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Molybdenum in excess can be toxic to fish and invertebrates, potentially leading to health issues or death. '
                "An appropriate alert can be to notify when molybdenum levels exceed 0.01 ppm.",
            parameterName: "Molybdenum",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'nitrate': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Nitrate',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Nitrate',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 1.0,
            unit: 'ppm',
            fractionDigits: 1,
            lineChartDeviation: 5.0,
          ),
          knowledgeScreen: NitrateKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High nitrate levels can cause stress, weaken immune systems, and lead to algae overgrowth. '
                "An appropriate alert can be to notify when nitrate levels exceed 40 ppm.",
            parameterName: "Nitrate",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'nitrite': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Nitrite',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Nitrite',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.01,
            unit: 'ppm',
            fractionDigits: 3,
            lineChartDeviation: 0.05,
          ),
          knowledgeScreen: NitriteKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Nitrite is highly toxic to fish and even small amounts can lead to stress, illness, or death. '
                "An appropriate alert can be to notify when nitrite levels are detectable (above 0 ppm).",
            parameterName: "Nitrite",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'organic carbon': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Organic Carbon',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Organic Carbon',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.1,
            unit: 'mg/L',
            fractionDigits: 1,
            lineChartDeviation: 0.5,
          ),
          knowledgeScreen: OrganicCarbonKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High levels of organic carbon can indicate poor water quality, leading to oxygen depletion and stress for fish. '
                "An appropriate alert can be to notify when organic carbon levels are above 5 mg/L.",
            parameterName: "Organic Carbon",
            aquariumId: aquariumId,
            unit: 'mg/L',
          ),
        ),
    'oxygen': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Oxygen',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Oxygen',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.1,
            unit: 'mg/L',
            fractionDigits: 1,
            lineChartDeviation: 0.5,
          ),
          knowledgeScreen: OxygenKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Low oxygen levels can lead to suffocation and death for fish, especially those in densely stocked tanks. '
                "An appropriate alert can be to notify when oxygen levels drop below 5 mg/L.",
            parameterName: "Oxygen",
            aquariumId: aquariumId,
            unit: 'mg/L',
          ),
        ),
    'ph': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'PH',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'PH',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.1,
            unit: '',
            fractionDigits: 2,
            lineChartDeviation: 0.2,
          ),
          knowledgeScreen: PHKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'pH levels that are too high or too low can lead to stress, disease, and even death in fish. '
                'Different fish species require different pH levels. '
                "An appropriate alert can be to notify when pH levels are outside the range of 6.5 to 8.0, depending on species.",
            parameterName: "PH",
            aquariumId: aquariumId,
            unit: '',
          ),
        ),
    'phosphate': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Phosphate',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Phosphate',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.1,
            unit: 'ppm',
            fractionDigits: 2,
            lineChartDeviation: 0.2,
          ),
          knowledgeScreen: PhosphateKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Excess phosphate can lead to algae overgrowth, causing oxygen depletion and stress in fish. '
                "An appropriate alert can be to notify when phosphate levels exceed 1.0 ppm.",
            parameterName: "Phosphate",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'potassium': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Potassium',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Potassium',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 1.0,
            unit: 'ppm',
            fractionDigits: 1,
            lineChartDeviation: 5.0,
          ),
          knowledgeScreen: PotassiumKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Potassium is necessary for plant health, but high levels can be harmful to fish and other aquatic life. '
                "An appropriate alert can be to notify when potassium levels exceed 30 ppm.",
            parameterName: "Potassium",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'redox potential': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Redox Potential',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Redox Potential',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 10.0,
            unit: 'mV',
            fractionDigits: 0,
            lineChartDeviation: 50.0,
          ),
          knowledgeScreen: RedoxPotentialKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Redox potential that is too low can indicate poor water quality and lack of oxygen, while too high can cause oxidative stress in fish. '
                "An appropriate alert can be to notify when redox potential is outside the range of +200 to +400 mV.",
            parameterName: "Redox Potential",
            aquariumId: aquariumId,
            unit: 'mV',
          ),
        ),
    'salinity': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Salinity',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Salinity',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.001,
            unit: 'specific gravity',
            fractionDigits: 3,
            lineChartDeviation: 0.005,
          ),
          knowledgeScreen: SalinityKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High salinity can cause osmotic stress in freshwater fish, leading to dehydration and death. '
                "An appropriate alert can be to notify when salinity is above 1.005 specific gravity in freshwater tanks.",
            parameterName: "Salinity",
            aquariumId: aquariumId,
            unit: 'specific gravity',
          ),
        ),
    'silica': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Silica',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Silica',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.1,
            unit: 'mg/L',
            fractionDigits: 1,
            lineChartDeviation: 0.5,
          ),
          knowledgeScreen: SilicaKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Silica can promote diatom algae growth, which can be problematic in aquariums. '
                "An appropriate alert can be to notify when silica levels exceed 2 mg/L.",
            parameterName: "Silica",
            aquariumId: aquariumId,
            unit: 'mg/L',
          ),
        ),
    'strontium': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Strontium',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Strontium',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 1.0,
            unit: 'ppm',
            fractionDigits: 1,
            lineChartDeviation: 5.0,
          ),
          knowledgeScreen: StrontiumKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Strontium is important for coral growth, but excessive levels can be harmful to invertebrates. '
                "An appropriate alert can be to notify when strontium levels exceed 12 ppm.",
            parameterName: "Strontium",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'sulfate': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Sulfate',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Sulfate',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 10.0,
            unit: 'mg/L',
            fractionDigits: 0,
            lineChartDeviation: 50.0,
          ),
          knowledgeScreen: SulfateKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Sulfate in high concentrations can contribute to water hardness and be toxic to fish and invertebrates. '
                "An appropriate alert can be to notify when sulfate levels exceed 500 mg/L.",
            parameterName: "Sulfate",
            aquariumId: aquariumId,
            unit: 'mg/L',
          ),
        ),
    'suspended solids': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Suspended Solids',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Suspended Solids',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 1.0,
            unit: 'mg/L',
            fractionDigits: 1,
            lineChartDeviation: 5.0,
          ),
          knowledgeScreen: SuspendedSolidsKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High levels of suspended solids can cause cloudy water, reduce light penetration, and stress fish by clogging their gills. '
                "An appropriate alert can be to notify when suspended solids exceed 30 mg/L.",
            parameterName: "Suspended Solids",
            aquariumId: aquariumId,
            unit: 'mg/L',
          ),
        ),
    'tds': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'TDS',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'TDS',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 10.0,
            unit: 'ppm',
            fractionDigits: 0,
            lineChartDeviation: 50.0,
          ),
          knowledgeScreen: TDSKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Total Dissolved Solids (TDS) that are too high can indicate poor water quality and stress aquatic life. '
                "An appropriate alert can be to notify when TDS levels exceed 500 ppm in freshwater aquariums.",
            parameterName: "TDS",
            aquariumId: aquariumId,
            unit: 'ppm',
          ),
        ),
    'temperature': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Temperature',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Temperature',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 0.5,
            unit: '°C',
            fractionDigits: 1,
            lineChartDeviation: 0.5,
          ),
          knowledgeScreen: TemperatureKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'Temperature that is too high or too low can cause thermal stress, weaken immune systems, and lead to death. '
                'Different species have different temperature requirements. '
                "An appropriate alert can be to notify when temperature is outside the range of 24-28°C, depending on species.",
            parameterName: "Temperature",
            aquariumId: aquariumId,
            unit: '°C',
          ),
        ),
    'turbidity': (context, aquariumId) => ParameterScreen(
          aquariumId: aquariumId,
          parameterName: 'Turbidity',
          dataScreen: DataScreen(
            aquariumId: aquariumId,
            parameterName: 'Turbidity',
            isLineChartVisible: true,
            isHeatmapVisible: true,
            isHistogrammVisible: true,
            histogrammRange: 1.0,
            unit: 'NTU',
            fractionDigits: 1,
            lineChartDeviation: 5.0,
          ),
          knowledgeScreen: TurbidityKnowledgeScreen(),
          alertScreen: AlertScreen(
            infotext:
                'High turbidity can reduce light penetration, disrupt photosynthesis, and stress fish by clogging their gills. '
                "An appropriate alert can be to notify when turbidity exceeds 5 NTU.",
            parameterName: "Turbidity",
            aquariumId: aquariumId,
            unit: 'NTU',
          ),
        ),
  };
}
