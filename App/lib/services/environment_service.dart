import 'dart:convert';
import 'package:aquaware/constants.dart';
import 'package:aquaware/models/environment.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EnvironmentService {
  Future<String> _getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('api_key');
    if (apiKey == null) {
      throw Exception('API key not found. Please log in again.');
    }
    return apiKey;
  }

  Future<Environment> createEnvironment(
    String name,
    String? description,
    String environmentType,
    bool public,
    String? city,
  ) async {
    final apiKey = await _getApiKey();

    final response = await http.post(
      Uri.parse('$baseUrl/api/environments/'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'name': name,
        'description': description!.isEmpty ? "-" : description,
        "environment_type": environmentType,
        "public": public,
        "city": city!.isEmpty ? "-" : city,
      }),
    );

    if (response.statusCode == 201) {
      return Environment.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception("Failed");
    }
  }

  Future<List<Environment>> getUserEnvironment() async {
    final apiKey = await _getApiKey();

    final response = await http.get(
      Uri.parse("$baseUrl/api/environments/"),
      headers: {
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Environment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get user environments: ${response.body}');
    }
  }

  Future<Environment> updateEnvironment(
      int id, Map<String, dynamic> updates) async {
    final apiKey = await _getApiKey();

    final response = await http.put(
      Uri.parse('$baseUrl/api/environments/$id/'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      return Environment.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to update environment: ${response.body}');
    }
  }

  Future<void> deleteEnvironment(int id) async {
    final apiKey = await _getApiKey();

    final response = await http.delete(
      Uri.parse('$baseUrl/api/environments/$id/'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete environment: ${response.body}');
    }
  }

  Future<List<Environment>> getPublicEnvironments() async {
    final apiKey = await _getApiKey();

    final response = await http.get(
      Uri.parse('$baseUrl/api/environments/public/'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Environment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get public environments: ${response.body}');
    }
  }

  Future<void> subscribeToPublicEnvironment(int environmentId) async {
    final apiKey = await _getApiKey();

    final response = await http.post(
      Uri.parse('$baseUrl/api/environments/$environmentId/subscribe/'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to subscribe: ${response.body}');
    }
  }
}
