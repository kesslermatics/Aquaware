import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'fluoride_data_screen.dart';
import 'fluoride_knowledge_screen.dart';

class FluorideScreen extends StatelessWidget {
  final int aquariumId;

  FluorideScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fluoride'),
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
            FluorideDataScreen(aquariumId: aquariumId),
            FluorideKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'High fluoride levels can be harmful to fish, causing stress and potential organ damage over time. '
                  "An appropriate alert can be to notify when fluoride levels exceed 1.5 ppm.",
              parameterName: "Fluoride",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
