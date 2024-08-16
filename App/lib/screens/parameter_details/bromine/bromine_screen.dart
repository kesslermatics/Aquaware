import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'bromine_data_screen.dart';
import 'bromine_knowledge_screen.dart';

class BromineScreen extends StatelessWidget {
  final int aquariumId;

  BromineScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bromine'),
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
            BromineDataScreen(aquariumId: aquariumId),
            BromineKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Elevated bromine levels can be harmful to fish, leading to respiratory problems and stress. '
                  'In extreme cases, it can be lethal. '
                  "An appropriate alert can be to notify when bromine levels are above 0.1 ppm.",
              parameterName: "Bromine",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
