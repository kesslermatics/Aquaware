import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MinMaxWidget extends StatefulWidget {
  final List<double> data;
  MinMaxWidget({super.key, required this.data});

  @override
  State<MinMaxWidget> createState() => _MinMaxWidgetState();
}

class _MinMaxWidgetState extends State<MinMaxWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
      color: Colors.white12,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Min: " +
                  widget.data
                      .reduce(
                          (current, next) => current < next ? current : next)
                      .toString() +
                  " | " +
                  "Max: " +
                  widget.data
                      .reduce(
                          (current, next) => current > next ? current : next)
                      .toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
