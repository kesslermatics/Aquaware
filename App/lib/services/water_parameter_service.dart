import 'dart:convert';
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/models/water_parameter.dart';
import 'package:aquaware/models/water_value.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'user_service.dart';
import 'package:aquaware/constants.dart';

class WaterParameterService {
  Future<List<WaterParameter>> fetchAllWaterParameters(int environmentId,
      {int number_of_entries = 336}) async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.get(
        Uri.parse(
            '$baseUrl/api/environments/$environmentId/values/latest/$number_of_entries/'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': UserProfile.getInstance().apiKey,
        },
      );
    });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body.replaceAll('Â', ''));
      return data.map((json) => WaterParameter.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load water parameters');
    }
  }

  Future<List<WaterValue>> fetchSingleWaterParameter(
      int environmentId, String parameter,
      {int numberOfEntries = 1000}) async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.get(
        Uri.parse(
            '$baseUrl/api/environments/$environmentId/values/parameters/$parameter/$numberOfEntries'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': UserProfile.getInstance().apiKey,
        },
      );
    });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body.replaceAll('Â', ''));
      return data.map((json) => WaterValue.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load water values');
    }
  }

  Future<int> fetchTotalEntries(int aquariumId, String parameter) async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.get(
        Uri.parse(
            '$baseUrl/api/environments/$aquariumId/values/parameters/$parameter/total'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': UserProfile.getInstance().apiKey,
        },
      );
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['total_entries'];
    } else {
      throw Exception('Failed to load total entries');
    }
  }
}
