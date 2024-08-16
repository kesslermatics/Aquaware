import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'magnesium_data_screen.dart';
import 'magnesium_knowledge_screen.dart';

class MagnesiumScreen extends StatelessWidget {
  final int aquariumId;

  MagnesiumScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Magnesium'),
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
            MagnesiumDataScreen(aquariumId: aquariumId),
            MagnesiumKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Magnesium is crucial for coral and invertebrate health, but excessive levels can disrupt water chemistry and harm aquatic life. '
                  "An appropriate alert can be to notify when magnesium levels are above 1500 ppm.",
              parameterName: "Magnesium",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
