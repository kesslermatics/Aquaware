import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'temperature_data_screen.dart';
import 'temperature_knowledge_screen.dart';

class TemperatureScreen extends StatelessWidget {
  final int aquariumId;

  TemperatureScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Temperature'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4,
            indicatorColor: ColorProvider.primary,
            labelColor: ColorProvider.textLight,
            unselectedLabelColor: ColorProvider.primary,
            tabs: [
              Tab(text: 'Data'),
              Tab(text: 'Knowledge'),
              Tab(text: 'Alerts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TemperatureDataScreen(aquariumId: aquariumId),
            TemperatureKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Temperature that is too high or too low can cause thermal stress, weaken immune systems, and lead to death. '
                  'Different species have different temperature requirements. '
                  "An appropriate alert can be to notify when temperature is outside the range of 24-28°C, depending on species.",
              parameterName: "Temperature",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
