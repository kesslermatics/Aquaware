import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerMenuWidget extends StatelessWidget {
  final VoidCallback onClicked;
  const DrawerMenuWidget({super.key, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: FaIcon(FontAwesomeIcons.alignLeft),
      color: Colors.white,
      onPressed: onClicked,
    );
  }
}
