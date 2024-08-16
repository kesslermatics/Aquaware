import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'suspended_solids_data_screen.dart';
import 'suspended_solids_knowledge_screen.dart';

class SuspendedSolidsScreen extends StatelessWidget {
  final int aquariumId;

  SuspendedSolidsScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Suspended Solids'),
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
            SuspendedSolidsDataScreen(aquariumId: aquariumId),
            SuspendedSolidsKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'High levels of suspended solids can cause cloudy water, reduce light penetration, and stress fish by clogging their gills. '
                  "An appropriate alert can be to notify when suspended solids exceed 30 mg/L.",
              parameterName: "Suspended solids",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
