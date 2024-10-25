import 'dart:convert';
import 'dart:io';
import 'package:aquaware/constants.dart';
import 'package:aquaware/models/fish_detection.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // for MediaType
import 'package:image_picker/image_picker.dart';

class FishDetectionService {
  Future<FishDetection> detectFish(XFile imageFile) async {
    final response =
        await UserService().makeAuthenticatedRequest((token) async {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/fish-detection/identify_fish_from_image/'),
      )
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(
          http.MultipartFile(
            'image',
            imageFile.readAsBytes().asStream(),
            await imageFile.length(),
            filename: imageFile.name,
            contentType: MediaType('image', 'jpeg'), // Adjust type if necessary
          ),
        );

      // Send the request and wait for the response
      final streamedResponse = await request.send();
      return http.Response.fromStream(streamedResponse);
    });

    if (response.statusCode == 500) {
      throw Exception('Servers are overloaded. Please try again..');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      return FishDetection.fromJson(responseBody);
    } else {
      throw Exception(
          'Failed to detect fish. Status code: ${response.statusCode}');
    }
  }
}
