import 'package:aquaware/screens/dashboard/alert_screen.dart';
import 'package:flutter/material.dart';
import 'package:aquaware/services/color_provider.dart';

class ParameterScreen extends StatelessWidget {
  final int aquariumId;
  final String parameterName;
  final Widget dataScreen;
  final Widget knowledgeScreen;
  final Widget alertScreen;

  ParameterScreen({
    required this.aquariumId,
    required this.parameterName,
    required this.dataScreen,
    required this.knowledgeScreen,
    required this.alertScreen,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(parameterName),
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
            dataScreen,
            knowledgeScreen,
            alertScreen,
          ],
        ),
      ),
    );
  }
}
