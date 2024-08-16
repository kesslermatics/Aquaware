import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'organic_carbon_data_screen.dart';
import 'organic_carbon_knowledge_screen.dart';

class OrganicCarbonScreen extends StatelessWidget {
  final int aquariumId;

  OrganicCarbonScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Organic Carbon'),
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
            OrganicCarbonDataScreen(aquariumId: aquariumId),
            OrganicCarbonKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'High levels of organic carbon can indicate poor water quality, leading to oxygen depletion and stress for fish. '
                  "An appropriate alert can be to notify when organic carbon levels are above 5 mg/L.",
              parameterName: "Organic carbon",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
