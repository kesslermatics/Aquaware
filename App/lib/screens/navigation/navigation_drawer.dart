import 'package:aquaware/constants.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuDrawer extends StatelessWidget {
  final UserProfile? profile;
  final Function(int) onItemTapped;

  MenuDrawer(this.profile, this.onItemTapped, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      color: blue,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile != null
                  ? '${profile!.firstName} ${profile!.lastName}'
                  : 'Guest',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              profile != null ? profile!.email : '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(FontAwesomeIcons.gauge),
            title: Text("Dashboard"),
            onTap: () => onItemTapped(0),
          ),
          Divider(),
          ListTile(
            leading: Icon(FontAwesomeIcons.user),
            title: Text("Profile"),
            onTap: () => onItemTapped(1),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () => onItemTapped(2),
          ),
        ],
      ),
    );
  }
}
