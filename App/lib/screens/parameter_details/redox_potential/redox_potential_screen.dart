import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'redox_potential_data_screen.dart';
import 'redox_potential_knowledge_screen.dart';
import 'redox_potential_alerts_screen.dart';

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
            RedoxPotentialAlertsScreen(),
          ],
        ),
      ),
    );
  }
}
