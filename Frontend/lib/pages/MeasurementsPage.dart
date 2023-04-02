import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../widgets/DrawerMenuWidget.dart';

class MeasurementsPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const MeasurementsPage({super.key, required this.openDrawer});

  @override
  State<MeasurementsPage> createState() => _MeasurementsPageState();
}

class _MeasurementsPageState extends State<MeasurementsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: DrawerMenuWidget(
            onClicked: widget.openDrawer,
          ),
          title: Text("Measurements"),
          bottom: TabBar(tabs: [
            Tab(text: "Temperature"),
            Tab(text: "PH"),
            Tab(text: "TDS"),
          ]),
        ),
        body: TabBarView(children: [
          Center(
            child: Text("Page 1"),
          ),
          Center(
            child: Text("Page 2"),
          ),
          Center(
            child: Text("Page 3"),
          ),
        ]),
      ),
    );
  }
}
