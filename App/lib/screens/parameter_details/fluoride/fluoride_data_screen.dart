import 'package:flutter/material.dart';
import 'package:aquaware/services/water_parameter_service.dart';
import 'package:aquaware/models/water_value.dart';
import 'package:aquaware/services/color_provider.dart';

class FluorideDataScreen extends StatefulWidget {
  final int aquariumId;

  FluorideDataScreen({required this.aquariumId});

  @override
  _FluorideDataScreenState createState() => _FluorideDataScreenState();
}

class _FluorideDataScreenState extends State<FluorideDataScreen> {
  late Future<List<WaterValue>> _futureWaterValues;
  final WaterParameterService _waterParameterService = WaterParameterService();

  @override
  void initState() {
    super.initState();
    _futureWaterValues = _fetchWaterValues();
  }

  Future<List<WaterValue>> _fetchWaterValues() async {
    return await _waterParameterService.fetchSingleWaterParameter(
        widget.aquariumId, 'Fluoride');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fluoride Data'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<WaterValue>>(
        future: _futureWaterValues,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load water values'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No water values found'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(16.0),  
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final value = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text('\${value.value} \${value.unit}'),
                    subtitle: Text('Measured at: \${value.measuredAt}'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
