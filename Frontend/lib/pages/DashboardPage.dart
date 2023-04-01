import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../widgets/DrawerMenuWidget.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const DashboardPage({super.key, required this.openDrawer});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: DrawerMenuWidget(
          onClicked: widget.openDrawer,
        ),
      ),
    );
  }
}
