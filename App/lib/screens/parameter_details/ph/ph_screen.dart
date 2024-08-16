import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'ph_data_screen.dart';
import 'ph_knowledge_screen.dart';

class PHScreen extends StatelessWidget {
  final int aquariumId;

  PHScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PH'),
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
            PHDataScreen(aquariumId: aquariumId),
            PHKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'pH levels that are too high or too low can lead to stress, disease, and even death in fish. '
                  'Different fish species require different pH levels. '
                  "An appropriate alert can be to notify when pH levels are outside the range of 6.5 to 8.0, depending on species.",
              parameterName: "pH",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
