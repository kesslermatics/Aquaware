import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'calcium_data_screen.dart';
import 'calcium_knowledge_screen.dart';

class CalciumScreen extends StatelessWidget {
  final int aquariumId;

  CalciumScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calcium'),
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
            CalciumDataScreen(aquariumId: aquariumId),
            CalciumKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'High calcium levels can lead to water hardness issues, which might cause stress in soft water fish. '
                  'On the other hand, low calcium levels can lead to poor shell development in invertebrates. ',
              parameterName: "Calcium",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
