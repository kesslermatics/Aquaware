import 'dart:convert';
import 'package:aquaware/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AlertService {
  Future<String> _getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('api_key');
    if (apiKey == null) {
      throw Exception('API key not found. Please log in again.');
    }
    return apiKey;
  }

  Future<void> saveAlertSettings(int aquariumId, String parameter,
      double? underValue, double? aboveValue) async {
    final apiKey = await _getApiKey();

    final response = await http.post(
      Uri.parse(
          '$baseUrl/api/measurements/environments/$aquariumId/save-alert-settings/'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'parameter': parameter,
        'under_value': underValue,
        'above_value': aboveValue,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save alert settings');
    }
  }

  Future<Map<String, dynamic>?> getAlertSettings(
      int aquariumId, String parameter) async {
    final apiKey = await _getApiKey();

    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/measurements/environments/$aquariumId/get_alerts/$parameter/'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      return null; // No alerts found
    } else {
      throw Exception('Failed to load alert settings');
    }
  }
}
