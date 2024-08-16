import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'copper_data_screen.dart';
import 'copper_knowledge_screen.dart';

class CopperScreen extends StatelessWidget {
  final int aquariumId;

  CopperScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Copper'),
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
            CopperDataScreen(aquariumId: aquariumId),
            CopperKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Elevated copper levels can be highly toxic to invertebrates and sensitive fish species, leading to death. '
                  "An appropriate alert can be to notify when copper levels exceed 0.1 ppm.",
              parameterName: "Copper",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
