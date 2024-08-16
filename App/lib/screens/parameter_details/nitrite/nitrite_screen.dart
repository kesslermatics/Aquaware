import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'nitrite_data_screen.dart';
import 'nitrite_knowledge_screen.dart';

class NitriteScreen extends StatelessWidget {
  final int aquariumId;

  NitriteScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nitrite'),
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
            NitriteDataScreen(aquariumId: aquariumId),
            NitriteKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Nitrite is highly toxic to fish and even small amounts can lead to stress, illness, or death. '
                  "An appropriate alert can be to notify when nitrite levels are detectable (above 0 ppm).",
              parameterName: "Nitrite",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
