import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MeasurementsPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const MeasurementsPage({super.key, required this.openDrawer});

  @override
  State<MeasurementsPage> createState() => _MeasurementsPageState();
}

class _MeasurementsPageState extends State<MeasurementsPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
