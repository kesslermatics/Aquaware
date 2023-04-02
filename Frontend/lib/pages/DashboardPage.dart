import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/SingleMeasurement.dart';
import 'package:http/http.dart' as http;
import '../widgets/DrawerMenuWidget.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const DashboardPage({super.key, required this.openDrawer});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: DrawerMenuWidget(
          onClicked: widget.openDrawer,
        ),
        title: Text("Dashboard"),
      ),
      body: StreamBuilder<List<SingleMeasurement>>(
        stream: fetchMeasurements(),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text("Some error occured"),
                );
              }
              final List<SingleMeasurement>? data = snapshot.data;
              if (data == null) {
                return Text("Some error occured");
              } else {
                return Text(data.first.tds.toString());
              }
          }
        }),
      ),
    );
  }

  Stream<List<SingleMeasurement>> fetchMeasurements() =>
      Stream.periodic(Duration(seconds: 2)).asyncMap(
        (event) => getData(),
      );

  Future<List<SingleMeasurement>> getData() async {
    final response = await http.get(Uri.parse(
        'https://api.thingspeak.com/channels/2081657/feeds.json?api_key=KB25YBZI8HQJS3XS&results=1'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return fetchMesswert(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  List<SingleMeasurement> fetchMesswert(Map<String, dynamic> json) {
    List<dynamic> feeds = json['feeds'];
    List<SingleMeasurement> data = <SingleMeasurement>[];
    for (Map map in feeds) {
      data.add(
        SingleMeasurement(
          int.parse(map["field1"]),
          int.parse(map["field2"]),
          double.parse(map["field3"]),
        ),
      );
    }
    return data;
  }
}
