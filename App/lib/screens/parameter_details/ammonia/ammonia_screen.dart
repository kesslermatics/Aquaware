import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'ammonia_data_screen.dart';
import 'ammonia_knowledge_screen.dart';

class AmmoniaScreen extends StatelessWidget {
  final int aquariumId;

  AmmoniaScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ammonia'),
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
            AmmoniaDataScreen(aquariumId: aquariumId),
            AmmoniaKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Ammonia levels that are too high can be dangerous for your fish, leading to stress, illness, and even death. '
                  'Ideally, ammonia levels should be kept at 0 ppm. '
                  "An appropriate alert can be to notify when ammonia levels are above 0.1.",
              parameterName: "Ammonia",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
