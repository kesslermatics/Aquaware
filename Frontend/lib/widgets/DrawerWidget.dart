import 'package:aquaware/model/DrawerItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../model/DrawerItem.dart';

class DrawerWidget extends StatelessWidget {
  final ValueChanged<DrawerItem> onSelectedItem;

  const DrawerWidget({super.key, required this.onSelectedItem});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildDrawerItems(context),
            ],
          ),
        ),
      );

  Widget buildDrawerItems(BuildContext context) => Column(
      children: DrawerItems.all
          .map(
            (item) => ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 23,
                vertical: 8,
              ),
              leading: Icon(
                item.icon,
                color: Colors.white,
              ),
              title: Text(
                item.title,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () => onSelectedItem(item),
            ),
          )
          .toList());
}
