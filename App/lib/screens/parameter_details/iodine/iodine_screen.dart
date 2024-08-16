import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';
import 'iodine_data_screen.dart';
import 'iodine_knowledge_screen.dart';

class IodineScreen extends StatelessWidget {
  final int aquariumId;

  IodineScreen({required this.aquariumId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Iodine'),
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
            IodineDataScreen(aquariumId: aquariumId),
            IodineKnowledgeScreen(),
            AlertScreen(
              infotext:
                  'Iodine is necessary for invertebrate health but in high concentrations, it can be toxic to both fish and invertebrates. '
                  "An appropriate alert can be to notify when iodine levels are above 0.06 ppm.",
              parameterName: "Iodine",
              aquariumId: aquariumId,
            )
          ],
        ),
      ),
    );
  }
}
