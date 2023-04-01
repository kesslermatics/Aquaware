import 'package:aquaware/model/DrawerItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerItems {
  static const dashboard = DrawerItem(
    "Dashboard",
    FontAwesomeIcons.gauge,
  );
  static const measurements = DrawerItem(
    "Measurements",
    FontAwesomeIcons.chartLine,
  );
  static const cyanobacteria = DrawerItem(
    "Cyanobacteria",
    FontAwesomeIcons.bacteria,
  );
  static const info = DrawerItem(
    "Info",
    FontAwesomeIcons.info,
  );
  static const notifications = DrawerItem(
    "Notifications",
    FontAwesomeIcons.bell,
  );
  static const settings = DrawerItem(
    "Settings",
    FontAwesomeIcons.gear,
  );

  static final List<DrawerItem> all = [
    dashboard,
    measurements,
    cyanobacteria,
    info,
    notifications,
    settings
  ];
}
