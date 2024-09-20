import 'dart:convert';
import 'package:aquaware/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AlertService {
  static const String baseUrl =
      'https://aquaware-production.up.railway.app/api/measurements/environments';

  Future<void> saveAlertSettings(int aquariumId, String parameter,
      double? underValue, double? aboveValue) async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.post(
        Uri.parse('$baseUrl/$aquariumId/save-alert-settings/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'parameter': parameter,
          'under_value': underValue,
          'above_value': aboveValue,
        }),
      );
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to save alert settings');
    }
  }

  Future<Map<String, dynamic>?> getAlertSettings(
      int aquariumId, String parameter) async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.get(
        Uri.parse('$baseUrl/$aquariumId/get_alerts/$parameter/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      return null; // No alerts found
    } else {
      throw Exception('Failed to load alert settings');
    }
  }
}
