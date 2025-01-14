import 'dart:convert';
import 'dart:io';
import 'package:aquaware/constants.dart';
import 'package:aquaware/models/fish_detection.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // for MediaType
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimalDetectionService {
  Future<String> _getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('api_key');
    if (apiKey == null) {
      throw Exception('API key not found. Please log in again.');
    }
    return apiKey;
  }

  Future<String> _getCurrentLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get the saved language, or use the default system language
    return prefs.getString('language') ?? Platform.localeName.split('_').first;
  }

  Future<AnimalDetection> detectFish(XFile imageFile) async {
    final String apiKey = await _getApiKey();
    final String currentLanguage = await _getCurrentLanguage();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/animal/identify/'),
    )
      ..headers['x-api-key'] = apiKey
      ..fields['language'] = currentLanguage // Add language parameter
      ..files.add(
        http.MultipartFile(
          'image',
          imageFile.readAsBytes().asStream(),
          await imageFile.length(),
          filename: imageFile.name,
          contentType: MediaType('image', 'jpeg'), // Adjust type if necessary
        ),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 500) {
      throw Exception('Servers are overloaded. Please try again..');
    }

    if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> responseBody = jsonDecode(decodedBody);

      return AnimalDetection.fromJson(responseBody);
    } else {
      throw Exception('Failed to detect animal. Please try again later.');
    }
  }
}
