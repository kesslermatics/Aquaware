import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'boron_data_screen.dart';
import 'boron_knowledge_screen.dart';

class BoronScreen extends StatelessWidget {
  final int aquariumId;

  BoronScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Boron'),
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
            BoronDataScreen(aquariumId: aquariumId),
            BoronKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'High levels of boron can be toxic to plants and invertebrates in your aquarium. '
                  'It can also lead to stress and illness in sensitive fish species. '
                  "An appropriate alert can be to notify when boron levels are above 1.0 ppm, depending on the species in your tank.",
              parameterName: "Boron",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
