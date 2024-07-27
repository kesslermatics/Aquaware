import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'turbidity_data_screen.dart';
import 'turbidity_knowledge_screen.dart';
import 'turbidity_alerts_screen.dart';

class TurbidityScreen extends StatelessWidget {
  final int aquariumId;

  TurbidityScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Turbidity'),
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
            TurbidityDataScreen(aquariumId: aquariumId),
            TurbidityKnowledgeScreen(),
            TurbidityAlertsScreen(),
          ],
        ),
      ),
    );
  }
}
