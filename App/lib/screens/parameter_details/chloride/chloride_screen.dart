import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'chloride_data_screen.dart';
import 'chloride_knowledge_screen.dart';

class ChlorideScreen extends StatelessWidget {
  final int aquariumId;

  ChlorideScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chloride'),
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
            ChlorideDataScreen(aquariumId: aquariumId),
            ChlorideKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'High chloride levels can indicate contamination and may lead to stress in freshwater fish. '
                  "An appropriate alert can be to notify when chloride levels are above 250 mg/L.",
              parameterName: "Chloride",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
