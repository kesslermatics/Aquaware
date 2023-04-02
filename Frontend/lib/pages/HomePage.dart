import 'dart:collection';
import 'dart:convert';

import 'package:aquaware/pages/CyanobacteriaPage.dart';
import 'package:aquaware/pages/InfoPage.dart';
import 'package:aquaware/pages/MeasurementsPage.dart';
import 'package:aquaware/pages/NotificationsPage.dart';
import 'package:aquaware/pages/SettingsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/DrawerItem.dart';
import '../model/DrawerItems.dart';
import '../model/SingleMeasurement.dart';
import '../widgets/DrawerWidget.dart';
import 'DashboardPage.dart';
import 'package:http/http.dart' as http;

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
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          if (!isDragging) return;
          const delta = 1;
          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
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
      ),
    );
  }

  Widget getCurrentPage() {
    switch (item) {
      case DrawerItems.measurements:
        return MeasurementsPage(openDrawer: openDrawer);
      case DrawerItems.cyanobacteria:
        return CyanobacteriaPage(openDrawer: openDrawer);
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
