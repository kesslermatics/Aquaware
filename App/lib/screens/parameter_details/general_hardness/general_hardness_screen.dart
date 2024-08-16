import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'general_hardness_data_screen.dart';
import 'general_hardness_knowledge_screen.dart';

class GeneralHardnessScreen extends StatelessWidget {
  final int aquariumId;

  GeneralHardnessScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('General Hardness'),
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
            GeneralHardnessDataScreen(aquariumId: aquariumId),
            GeneralHardnessKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'General hardness (GH) measures the total concentration of calcium and magnesium. '
                  'Water that is too hard or too soft can stress fish and affect their osmoregulation. '
                  "An appropriate alert can be to notify when GH is above 14 dGH or below 4 dGH, depending on the species.",
              parameterName: "General hardness",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
