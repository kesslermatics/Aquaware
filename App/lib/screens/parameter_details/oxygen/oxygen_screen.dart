import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'oxygen_data_screen.dart';
import 'oxygen_knowledge_screen.dart';

class OxygenScreen extends StatelessWidget {
  final int aquariumId;

  OxygenScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Oxygen'),
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
            OxygenDataScreen(aquariumId: aquariumId),
            OxygenKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Low oxygen levels can lead to suffocation and death for fish, especially those in densely stocked tanks. '
                  "An appropriate alert can be to notify when oxygen levels drop below 5 mg/L.",
              parameterName: "Oxygen",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
