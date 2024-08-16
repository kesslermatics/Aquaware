import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'potassium_data_screen.dart';
import 'potassium_knowledge_screen.dart';

class PotassiumScreen extends StatelessWidget {
  final int aquariumId;

  PotassiumScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Potassium'),
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
            PotassiumDataScreen(aquariumId: aquariumId),
            PotassiumKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Potassium is necessary for plant health, but high levels can be harmful to fish and other aquatic life. '
                  "An appropriate alert can be to notify when potassium levels exceed 30 ppm.",
              parameterName: "Potassium",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
