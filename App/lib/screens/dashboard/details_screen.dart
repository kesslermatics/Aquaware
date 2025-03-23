import 'package:aquaware/models/environment.dart';
import 'package:aquaware/models/water_parameter.dart';
import 'package:aquaware/services/water_parameter_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _futureWaterParameters =
              _waterParameterService.fetchAllWaterParameters(widget.aquarium.id,
                  number_of_entries: 10);
        });
      },
      child: FutureBuilder<List<WaterParameter>>(
        future: _futureWaterParameters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.blue),
                  const SizedBox(height: 16),
                  Text(
                    loc.gettingAllParameters,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    loc.errorLoadingParameters,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.info, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    loc.noParametersFound,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          } else {
            DateTime sevenDaysAgo =
                DateTime.now().subtract(const Duration(days: 7));

            List<WaterParameter> recentParameters =
                snapshot.data!.where((param) {
              return param.values.any(
                  (waterValue) => waterValue.measuredAt.isAfter(sevenDaysAgo));
            }).toList();

            bool hasRecentData = recentParameters.isNotEmpty;

            return Column(
              children: [
                if (!hasRecentData)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.amber),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              loc.noParametersLast7Days,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final waterParameter = snapshot.data![index];
                      return WaterParameterCard(
                        aquariumId: widget.aquarium.id,
                        waterParameter: waterParameter,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
