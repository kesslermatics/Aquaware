import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class InfoPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const InfoPage({super.key, required this.openDrawer});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
