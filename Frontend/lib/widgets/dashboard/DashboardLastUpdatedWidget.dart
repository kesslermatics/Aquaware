import 'package:aquaware/model/SingleMeasurement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../model/ChannelInfo.dart';

class DashboardLastUpdatedWidget extends StatelessWidget {
  late String lastDate = "";
  late SingleMeasurement data;
  late FlashingCircle flashingCircle;
  DashboardLastUpdatedWidget(SingleMeasurement data, {super.key}) {
    if (lastDate == "") {
      lastDate = DateTime.now().toIso8601String();
    } else {
      this.lastDate = this.data.createdAt;
    }
    this.data = data;
    flashingCircle = FlashingCircle(
        duration: const Duration(seconds: 1), color: Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    int minutesDifference = DateTime.now()
        .difference(DateTime.parse(data.createdAt).toLocal())
        .inMinutes;
    if (minutesDifference > 30) {
      flashingCircle.color = Colors.red;
    }
    return Card(
      margin: EdgeInsets.all(14),
      color: Colors.white12,
      child: Row(
        children: [
          flashingCircle,
          Text(
            "Last updated: ${DateTime.now().difference(DateTime.parse(data.createdAt).toLocal()).inMinutes} minutes ago",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class FlashingCircle extends StatefulWidget {
  final Duration? duration;
  Color? color;
  FlashingCircle({Key? key, this.duration, this.color}) : super(key: key);
  @override
  _FlashingIconState createState() => _FlashingIconState();
}

class _FlashingIconState extends State<FlashingCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: widget.duration);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget get _circle => Container(
        height: 25,
        width: 25,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      );

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return FadeTransition(opacity: _animationController, child: _circle);
  }
}
