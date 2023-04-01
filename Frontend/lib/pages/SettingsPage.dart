import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const SettingsPage({super.key, required this.openDrawer});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
