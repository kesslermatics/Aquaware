import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'carbonate_hardness_data_screen.dart';
import 'carbonate_hardness_knowledge_screen.dart';
import 'carbonate_hardness_alerts_screen.dart';

class CarbonateHardnessScreen extends StatelessWidget {
  final int aquariumId;

  CarbonateHardnessScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Carbonate Hardness'),
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
            CarbonateHardnessDataScreen(aquariumId: aquariumId),
            CarbonateHardnessKnowledgeScreen(),
            CarbonateHardnessAlertsScreen(),
          ],
        ),
      ),
    );
  }
}
