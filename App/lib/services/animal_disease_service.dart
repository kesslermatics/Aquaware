import 'dart:convert';
import 'dart:io';
import 'package:aquaware/constants.dart';
import 'package:aquaware/models/disease.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnimalDiseaseService {
  Future<String> _getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('api_key');
    if (apiKey == null) {
      throw Exception('API key not found. Please log in again.');
    }
    return apiKey;
  }

  Future<String> _getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    // Get the saved language, or use the default system language
    return prefs.getString('language') ?? Platform.localeName.split('_').first;
  }

  Future<AnimalDisease> diagnoseAnimalDisease(File imageFile) async {
    final String apiKey = await _getApiKey();
    final String currentLanguage = await _getCurrentLanguage();

    // Ensure the image file is valid
    final mimeType = lookupMimeType(imageFile.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      throw Exception('Invalid image type');
    }

    final uri = Uri.parse('$baseUrl/api/diseases/diagnosis/');
    final request = http.MultipartRequest('POST', uri)
      ..headers['x-api-key'] = apiKey
      ..headers['Content-Type'] = 'multipart/form-data'
      ..fields['language'] = currentLanguage; // Add language parameter

    // Add the image file to the request
    final multipartFile = http.MultipartFile.fromBytes(
      'image',
      imageFile.readAsBytesSync(),
      filename: imageFile.path.split("/").last,
      contentType: MediaType.parse(mimeType),
    );
    request.files.add(multipartFile);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 500) {
      throw Exception('Servers are overloaded. Please try again..');
    }

    if (response.statusCode == 200) {
      final String decodedBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> jsonResponse = json.decode(decodedBody);
      return AnimalDisease.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to diagnose animal disease');
    }
  }
}
