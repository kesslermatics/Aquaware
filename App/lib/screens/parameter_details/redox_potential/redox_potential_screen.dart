import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'redox_potential_data_screen.dart';
import 'redox_potential_knowledge_screen.dart';

class RedoxPotentialScreen extends StatelessWidget {
  final int aquariumId;

  RedoxPotentialScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Redox Potential'),
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
            RedoxPotentialDataScreen(aquariumId: aquariumId),
            RedoxPotentialKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Redox potential that is too low can indicate poor water quality and lack of oxygen, while too high can cause oxidative stress in fish. '
                  "An appropriate alert can be to notify when redox potential is outside the range of +200 to +400 mV.",
              parameterName: "Redox potential",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
