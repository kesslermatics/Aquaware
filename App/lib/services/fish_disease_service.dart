import 'dart:convert';
import 'dart:io';
import 'package:aquaware/constants.dart';
import 'package:aquaware/models/disease.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'user_service.dart';

class FishDiseaseService {
  Future<FishDisease> diagnoseFishDisease(File imageFile) async {
    // Ensure the image file is valid
    final mimeType = lookupMimeType(imageFile.path);

    if (mimeType == null || !mimeType.startsWith('image/')) {
      throw Exception('Invalid image type');
    }

    // Make authenticated request
    final response =
        await UserService().makeAuthenticatedRequest((token) async {
      final uri = Uri.parse('$baseUrl/api/diseases/diagnosis-from-image/');

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Content-Type'] = 'multipart/form-data';

      // Add the image file to the request
      final multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageFile.readAsBytesSync(),
        filename: imageFile.path.split("/").last,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      return await http.Response.fromStream(
          streamedResponse); // Convert StreamedResponse to Response
    });

    // Handle response

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final Map<String, dynamic> jsonResponse = json.decode(responseBody);

      // Return FishDisease object from the JSON response
      return FishDisease.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to diagnose fish disease');
    }
  }
}
