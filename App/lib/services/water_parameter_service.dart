import 'dart:convert';
import 'package:aquaware/models/water_parameter.dart';
import 'package:aquaware/models/water_value.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'user_service.dart';

class WaterParameterService {
  static const String baseUrl =
      'https://aquaware-production.up.railway.app/api/measurements/aquariums/';
  final UserService _userService = UserService();

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

  Future<List<WaterParameter>> fetchAllWaterParameters(int aquariumId) async {
    final response = await _makeAuthenticatedRequest((token) {
      return http.get(
        Uri.parse('$baseUrl$aquariumId/water-values/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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
      int aquariumId, String parameter) async {
    final response = await _makeAuthenticatedRequest((token) {
      return http.get(
        Uri.parse('$baseUrl$aquariumId/water-values/$parameter'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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
}
