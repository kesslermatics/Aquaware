import 'package:aquaware/models/water_value.dart';
import 'package:aquaware/services/water_parameter_service.dart';
import 'package:flutter/material.dart';

class ParameterScreen extends StatelessWidget {
  final int aquariumId;
  final String parameterName;
  final Widget Function(Future<List<WaterValue>>, Future<int>)
      dataScreenBuilder;
  final Widget knowledgeScreen;
  final Widget alertScreen;

  const ParameterScreen({
    super.key,
    required this.aquariumId,
    required this.parameterName,
    required this.dataScreenBuilder,
    required this.knowledgeScreen,
    required this.alertScreen,
  });

  Future<List<WaterValue>> _fetchWaterValues() {
    final WaterParameterService service = WaterParameterService();
    return service.fetchSingleWaterParameter(
      aquariumId,
      parameterName,
      numberOfEntries: 100,
    );
  }

  Future<int> _fetchTotalEntries() {
    final WaterParameterService service = WaterParameterService();
    return service.fetchTotalEntries(aquariumId, parameterName);
  }

  @override
  Widget build(BuildContext context) {
    final futureWaterValues = _fetchWaterValues();
    final futureTotalEntries = _fetchTotalEntries();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(parameterName),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Data'),
              Tab(text: 'Knowledge'),
              Tab(text: 'Alerts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            dataScreenBuilder(futureWaterValues, futureTotalEntries),
            knowledgeScreen,
            alertScreen,
          ],
        ),
      ),
    );
  }
}
