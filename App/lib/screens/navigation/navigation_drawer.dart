import 'package:aquaware/constants.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuDrawer extends StatelessWidget {
  final Function(int) onItemTapped;

  const MenuDrawer(this.onItemTapped, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorProvider.n6,
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
      color: ColorProvider.n6,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${UserProfile.getInstance().firstName} ${UserProfile.getInstance().lastName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              UserProfile.getInstance().email,
              style: const TextStyle(
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
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(FontAwesomeIcons.chartLine),
            title: Text(loc.drawerDashboard),
            onTap: () => onItemTapped(0),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.fish),
            title: Text(loc.drawerAnimalDetection),
            onTap: () => onItemTapped(1),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.heart),
            title: Text(loc.drawerDiseaseDetection),
            onTap: () => onItemTapped(2),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(FontAwesomeIcons.user),
            title: Text(loc.drawerProfile),
            onTap: () => onItemTapped(3),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.key),
            title: Text(loc.drawerPrivacy),
            onTap: () => onItemTapped(4),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(FontAwesomeIcons.envelope),
            title: Text(loc.drawerSendFeedback),
            onTap: () => onItemTapped(5),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.infoCircle),
            title: Text(loc.drawerAbout),
            onTap: () => onItemTapped(6),
          ),
        ],
      ),
    );
  }
}
