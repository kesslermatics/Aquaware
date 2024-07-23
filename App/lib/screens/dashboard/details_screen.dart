import 'package:aquaware/models/aquarium.dart';
import 'package:aquaware/models/water_parameter.dart';
import 'package:aquaware/services/water_parameter_service.dart';
import 'package:flutter/material.dart';
import 'water_parameter_card.dart';

class DetailsScreen extends StatefulWidget {
  final Aquarium aquarium;

  const DetailsScreen({required this.aquarium, super.key});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final WaterParameterService _waterParameterService = WaterParameterService();
  late Future<List<WaterParameter>> _futureWaterParameters;

  @override
  void initState() {
    super.initState();
    _futureWaterParameters =
        _waterParameterService.fetchWaterParameters(widget.aquarium.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<WaterParameter>>(
        future: _futureWaterParameters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No water parameters found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final waterParameter = snapshot.data![index];
                return WaterParameterCard(waterParameter: waterParameter);
              },
            );
          }
        },
      ),
    );
  }
}
