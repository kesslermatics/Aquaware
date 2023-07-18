import 'package:aquaware/pages/ChlorophyllAPage.dart';
import 'package:aquaware/pages/InfoPage.dart';
import 'package:aquaware/pages/MeasurementsPage.dart';
import 'package:aquaware/pages/NotificationsPage.dart';
import 'package:aquaware/pages/SettingsPage.dart';
import 'package:flutter/material.dart';

import '../model/DrawerItem.dart';
import '../model/DrawerItems.dart';
import '../widgets/DrawerWidget.dart';
import 'DashboardPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  bool isDragging = false;
  bool isDrawerOpen = false;
  DrawerItem item = DrawerItems.dashboard;

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  void openDrawer() => setState(() {
        xOffset = 230;
        yOffset = 125;
        scaleFactor = 0.6;
        isDrawerOpen = true;
      });

  void closeDrawer() => setState(() {
        xOffset = 0;
        yOffset = 0;
        scaleFactor = 1;
        isDrawerOpen = false;
      });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            buildDrawer(),
            buildCurrentPage(),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer() => Container(
        padding: EdgeInsets.fromLTRB(0, yOffset, 0, 0),
        width: xOffset,
        child: DrawerWidget(
          onSelectedItem: (item) {
            setState(() {
              this.item = item;
              closeDrawer();
            });
          },
        ),
      );

  Widget buildCurrentPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(xOffset, yOffset, 0)
          ..scale(scaleFactor),
        child: AbsorbPointer(
          absorbing: isDrawerOpen,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
            child: Container(
                color: isDrawerOpen
                    ? Colors.white12
                    : Theme.of(context).primaryColor,
                child: getCurrentPage()),
          ),
        ),
      ),
    );
  }

  Widget getCurrentPage() {
    switch (item) {
      case DrawerItems.measurements:
        return MeasurementsPage(openDrawer: openDrawer);
      case DrawerItems.chlorophyllA:
        return ChlorophyllAPage(openDrawer: openDrawer);
      case DrawerItems.info:
        return InfoPage(openDrawer: openDrawer);
      case DrawerItems.notifications:
        return NotificationsPage(openDrawer: openDrawer);
      case DrawerItems.settings:
        return SettingsPage(openDrawer: openDrawer);
      default:
        return DashboardPage(openDrawer: openDrawer);
    }
  }
}
