import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'chlorine_data_screen.dart';
import 'chlorine_knowledge_screen.dart';

class ChlorineScreen extends StatelessWidget {
  final int aquariumId;

  ChlorineScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chlorine'),
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
            ChlorineDataScreen(aquariumId: aquariumId),
            ChlorineKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Excess chlorine can be toxic to all aquatic life, leading to severe stress, gill damage, and death. '
                  "An appropriate alert can be to notify when chlorine levels are detectable (above 0 ppm).",
              parameterName: "Chlorine",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
