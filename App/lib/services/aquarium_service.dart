import 'dart:convert';
import 'package:aquaware/constants.dart';
import 'package:aquaware/models/aquarium.dart';
import 'package:http/http.dart' as http;

import 'user_service.dart';

class AquariumService {
  Future<Aquarium> createAquarium(String name, String description) async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.post(
        Uri.parse('$baseUrl/api/aquariums/create/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
        }),
      );
    });

    if (response.statusCode == 201) {
      return Aquarium.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create aquarium: ${response.body}');
    }
  }

  Future<List<Aquarium>> getUserAquariums() async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.get(
        Uri.parse("$baseUrl/api/aquariums/"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Aquarium.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get user aquariums: ${response.body}');
    }
  }

  Future<Aquarium> updateAquarium(int id, Map<String, dynamic> updates) async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.put(
        Uri.parse('$baseUrl/api/aquariums/$id/update/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updates),
      );
    });

    if (response.statusCode == 200) {
      return Aquarium.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update aquarium: ${response.body}');
    }
  }

  Future<void> deleteAquarium(int id) async {
    final response = await UserService().makeAuthenticatedRequest((token) {
      return http.delete(
        Uri.parse('$baseUrl/api/aquariums/$id/delete/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    });

    if (response.statusCode != 204) {
      throw Exception('Failed to delete aquarium: ${response.body}');
    }
  }
}
