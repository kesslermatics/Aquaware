import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'phosphate_data_screen.dart';
import 'phosphate_knowledge_screen.dart';

class PhosphateScreen extends StatelessWidget {
  final int aquariumId;

  PhosphateScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Phosphate'),
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
            PhosphateDataScreen(aquariumId: aquariumId),
            PhosphateKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Excess phosphate can lead to algae overgrowth, causing oxygen depletion and stress in fish. '
                  "An appropriate alert can be to notify when phosphate levels exceed 1.0 ppm.",
              parameterName: "Phosphate",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
