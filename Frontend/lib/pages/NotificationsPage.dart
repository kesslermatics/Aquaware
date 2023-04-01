import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NotificationsPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const NotificationsPage({super.key, required this.openDrawer});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
