import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'carbonate_hardness_data_screen.dart';
import 'carbonate_hardness_knowledge_screen.dart';

class CarbonateHardnessScreen extends StatelessWidget {
  final int aquariumId;

  CarbonateHardnessScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Carbonate Hardness'),
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
            CarbonateHardnessDataScreen(aquariumId: aquariumId),
            CarbonateHardnessKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'High carbonate hardness (KH) levels can cause pH stability issues, making it difficult to adjust pH levels. '
                  'Low KH can lead to sudden pH swings, which are harmful to fish. '
                  "An appropriate alert can be to notify when carbonate hardness is above 12 dKH or below 4 dKH.",
              parameterName: "Carbonate hardness",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
