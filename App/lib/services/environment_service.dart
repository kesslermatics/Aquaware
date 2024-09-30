import 'dart:convert';
import 'package:aquaware/constants.dart';
import 'package:aquaware/models/environment.dart';
import 'package:http/http.dart' as http;

import 'user_service.dart';

class EnvironmentService {
  Future<Environment> createEnvironment(
    String name,
    String description,
    String environmentType,
    bool public,
    String? city,
  ) async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.post(
        Uri.parse('$baseUrl/api/environments/create/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          "environment_type": environmentType,
          "public": public,
          "city": city,
        }),
      );
    });

    if (response.statusCode == 201) {
      return Environment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create environment: ${response.body}');
    }
  }

  Future<List<Environment>> getUserEnvironment() async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.get(
        Uri.parse("$baseUrl/api/environments/"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Environment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get user environments: ${response.body}');
    }
  }

  Future<Environment> updateEnvironment(
      int id, Map<String, dynamic> updates) async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.put(
        Uri.parse('$baseUrl/api/environments/$id/update/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updates),
      );
    });

    if (response.statusCode == 200) {
      return Environment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update environment: ${response.body}');
    }
  }

  Future<void> deleteEnvironment(int id) async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.delete(
        Uri.parse('$baseUrl/api/environments/$id/delete/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    });

    if (response.statusCode != 204) {
      throw Exception('Failed to delete environment: ${response.body}');
    }
  }

  // Neue Methode für öffentliche Environments
  Future<List<Environment>> getPublicEnvironments() async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.get(
        Uri.parse('$baseUrl/api/environments/public/'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Environment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get public environments: ${response.body}');
    }
  }
}
