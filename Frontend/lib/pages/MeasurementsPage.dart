import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../model/ChannelInfo.dart';
import '../model/SingleMeasurement.dart';
import 'package:http/http.dart' as http;
import '../widgets/DrawerMenuWidget.dart';
import '../widgets/measurements/MeasurementsWidget.dart';

class MeasurementsPage extends StatefulWidget {
  final VoidCallback openDrawer;

  const MeasurementsPage({super.key, required this.openDrawer});

  @override
  State<MeasurementsPage> createState() => _MeasurementsPageState();
}

class _MeasurementsPageState extends State<MeasurementsPage> {
  late StreamBuilder streamBuilder;
  @override
  void initState() {
    streamBuilder = StreamBuilder<List>(
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
            final List<SingleMeasurement> data = snapshot.data![0];
            final ChannelInfo info = snapshot.data![1];
            if (data == null) {
              return Text("Some error occured");
            } else {
              return MeasurementsWidget(
                data: data,
                info: info,
              );
            }
        }
      }),
    );
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: DrawerMenuWidget(
            onClicked: widget.openDrawer,
          ),
          title: Text("Measurements"),
          bottom: TabBar(tabs: [
            Tab(text: "Temperature"),
            Tab(text: "PH"),
            Tab(text: "TDS"),
          ]),
        ),
        body: streamBuilder,
      ),
    );
  }

  Stream<List> fetchMeasurements() =>
      Stream.periodic(Duration(seconds: 1)).asyncMap(
        (event) async {
          final response = await http.get(Uri.parse(
              'https://api.thingspeak.com/channels/2081657/feeds.json?api_key=KB25YBZI8HQJS3XS&results=340'));

          if (response.statusCode == 200) {
            // If the server did return a 200 OK response,
            // then parse the JSON.
            return getData(jsonDecode(response.body));
          } else {
            // If the server did not return a 200 OK response,
            // then throw an exception.
            throw Exception('Failed to load data');
          }
        },
      );

  List getData(Map<String, dynamic> json) {
    List<dynamic> feeds = json['feeds'];
    List<SingleMeasurement> data = <SingleMeasurement>[];
    ChannelInfo info = ChannelInfo(
        json["channel"]["name"],
        json["channel"]["created_at"],
        json["channel"]["updated_at"],
        json["channel"]["last_entry_id"]);
    for (Map map in feeds) {
      data.add(
        SingleMeasurement(
          double.parse(map["field1"]),
          double.parse(map["field2"]),
          double.parse(map["field3"]),
          map["created_at"],
          map["entry_id"],
        ),
      );
    }
    return [
      data,
      info,
    ];
  }
}
