import 'package:aquaware/models/environment.dart';
import 'package:aquaware/models/water_parameter.dart';
import 'package:aquaware/services/water_parameter_service.dart';
import 'package:flutter/material.dart';
import 'water_parameter_card.dart';

class DetailsScreen extends StatefulWidget {
  final Environment aquarium;

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
    _futureWaterParameters = _waterParameterService
        .fetchAllWaterParameters(widget.aquarium.id, number_of_entries: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<WaterParameter>>(
        future: _futureWaterParameters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No water parameters found.'));
          } else {
            DateTime sevenDaysAgo =
                DateTime.now().subtract(const Duration(days: 7));

            List<WaterParameter> recentParameters =
                snapshot.data!.where((param) {
              return param.values.any(
                  (waterValue) => waterValue.measuredAt.isAfter(sevenDaysAgo));
            }).toList();

            if (recentParameters.isEmpty) {
              return const Center(
                  child: Text('No water parameters found in the last 7 days.'));
            }

            return ListView.builder(
              itemCount: recentParameters.length,
              itemBuilder: (context, index) {
                final waterParameter = recentParameters[index];
                return WaterParameterCard(
                  aquariumId: widget.aquarium.id,
                  waterParameter: waterParameter,
                );
              },
            );
          }
        },
      ),
    );
  }
}
