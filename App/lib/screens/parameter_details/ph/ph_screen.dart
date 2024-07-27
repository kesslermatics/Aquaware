import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'ph_data_screen.dart';
import 'ph_knowledge_screen.dart';
import 'ph_alerts_screen.dart';

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
            PHAlertsScreen(),
          ],
        ),
      ),
    );
  }
}
