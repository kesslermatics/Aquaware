import 'dart:convert';

import 'package:aquaware/pages/HomePage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Color.fromRGBO(21, 30, 61, 1),
      ),
      home: HomePage(),
    );
  }
}
