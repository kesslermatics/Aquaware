import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'strontium_data_screen.dart';
import 'strontium_knowledge_screen.dart';

class StrontiumScreen extends StatelessWidget {
  final int aquariumId;

  StrontiumScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Strontium'),
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
            StrontiumDataScreen(aquariumId: aquariumId),
            StrontiumKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Strontium is important for coral growth, but excessive levels can be harmful to invertebrates. '
                  "An appropriate alert can be to notify when strontium levels exceed 12 ppm.",
              parameterName: "Strontium",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
