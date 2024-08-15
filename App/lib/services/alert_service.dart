import 'dart:convert';
import 'package:aquaware/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AlertService {
  final UserService _userService = UserService();
  static const String baseUrl =
      'https://aquaware-production.up.railway.app/api/measurements/aquariums/';

  Future<String?> _getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _handleUnauthorized() async {
    await _userService.refreshAccessToken();
  }

  Future<http.Response> _makeAuthenticatedRequest(
      Future<http.Response> Function(String token) request) async {
    String? token = await _getAccessToken();
    if (token == null) throw Exception('No access token available');

    http.Response response = await request(token);

    if (response.statusCode == 401) {
      await _handleUnauthorized();
      token = await _getAccessToken();
      if (token == null)
        throw Exception('No access token available after refresh');

      response = await request(token);
    }

    return response;
  }

  Future<void> saveAlertSettings(int aquariumId, String parameter,
      double? underValue, double? aboveValue) async {
    final response = await _makeAuthenticatedRequest((token) {
      return http.post(
        Uri.parse('$baseUrl/aquariums/$aquariumId/save-alert-settings/'),
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
}
