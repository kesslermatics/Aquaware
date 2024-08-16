import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'nitrate_data_screen.dart';
import 'nitrate_knowledge_screen.dart';

class NitrateScreen extends StatelessWidget {
  final int aquariumId;

  NitrateScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nitrate'),
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
            NitrateDataScreen(aquariumId: aquariumId),
            NitrateKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'High nitrate levels can cause stress, weaken immune systems, and lead to algae overgrowth. '
                  "An appropriate alert can be to notify when nitrate levels exceed 40 ppm.",
              parameterName: "Nitrate",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
