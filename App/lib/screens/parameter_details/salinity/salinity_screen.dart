import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'salinity_data_screen.dart';
import 'salinity_knowledge_screen.dart';

class SalinityScreen extends StatelessWidget {
  final int aquariumId;

  SalinityScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Salinity'),
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
            SalinityDataScreen(aquariumId: aquariumId),
            SalinityKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'High salinity can cause osmotic stress in freshwater fish, leading to dehydration and death. '
                  "An appropriate alert can be to notify when salinity is above 1.005 specific gravity in freshwater tanks.",
              parameterName: "Salinity",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
