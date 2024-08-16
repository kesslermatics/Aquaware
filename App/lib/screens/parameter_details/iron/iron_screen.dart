import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'iron_data_screen.dart';
import 'iron_knowledge_screen.dart';

class IronScreen extends StatelessWidget {
  final int aquariumId;

  IronScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Iron'),
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
            IronDataScreen(aquariumId: aquariumId),
            IronKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'High iron levels can lead to excessive algae growth and may be toxic to invertebrates and some fish species. '
                  "An appropriate alert can be to notify when iron levels exceed 0.2 ppm.",
              parameterName: "Iron",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
