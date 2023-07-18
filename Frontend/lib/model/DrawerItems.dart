import 'package:aquaware/model/DrawerItem.dart';
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
  static const chlorophyllA = DrawerItem(
    "Chlorophyll-A",
    FontAwesomeIcons.leaf,
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
    chlorophyllA,
    info,
    notifications,
    settings
  ];
}
