import 'dart:convert';
import 'package:aquaware/constants.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String signupUrl = '$baseUrl/api/users/auth/signup/';
  static const String loginUrl = '$baseUrl/api/users/auth/login/';
  static const String refreshTokenUrl =
      '$baseUrl/api/users/auth/token/refresh/';
  static const String profileUrl = '$baseUrl/api/users/profile/';
  static const String updateProfileUrl = '$baseUrl/api/users/profile/';
  static const String changePasswordUrl = '$baseUrl/api/users/password/change/';
  static const String deleteAccountUrl = '$baseUrl/api/users/profile/';
  static const String googleSignupUrl =
      '$baseUrl/api/users/auth/signup/google/';

  Future<String?> signup(String email, String password, String password2,
      String firstName, String lastName) async {
    final response = await http.post(
      Uri.parse(signupUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'password2': password2,
        'first_name': firstName,
        'last_name': lastName,
      }),
    );

    if (response.statusCode == 201) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      String accessToken = data['access'];
      String refreshToken = data['refresh'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);
      return null;
    } else if (response.statusCode == 500) {
      return "Server Error. Try again later";
    } else {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      List<String> errors = [];
      errorData.forEach((key, value) {
        if (value is List) {
          errors.addAll(List<String>.from(value.map((msg) => msg.toString())));
        }
      });
      return errors.join('\n'); // Fehlermeldungen zurückgeben
    }
  }

  Future<String?> googleSignup(String? googleToken) async {
    final response = await http.post(
      Uri.parse(googleSignupUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': googleToken}),
    );

    if (response.statusCode == 201) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      String accessToken = data['access'];
      String refreshToken = data['refresh'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);
      return null;
    } else {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      return errorData['error'] ?? 'Failed to sign up with Google';
    }
  }

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 202) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      String accessToken = data['access'];
      String refreshToken = data['refresh'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);
      return null; // Erfolgreiches Login
    } else {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      return errorData['message'] ??
          'Failed to log in'; // Fehlermeldung zurückgeben
    }
  }

  Future<String?> googleLogin(String googleToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/auth/login/google/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': googleToken}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      String accessToken = data['access'];
      String refreshToken = data['refresh'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);
      return null;
    } else {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      return errorData['error'] ?? 'Failed to log in';
    }
  }

  Future<void> getUserProfile() async {
    final response = await makeAuthenticatedRequest((token) {
      return http.get(
        Uri.parse(profileUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    });

    if (response.statusCode == 200) {
      UserProfile.setFromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to get user profile');
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    final response = await makeAuthenticatedRequest((token) {
      return http.put(
        Uri.parse(updateProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updatedData),
      );
    });

    if (response.statusCode == 200) {
      // Successfully updated profile
    } else {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(errorData['detail'] ?? 'Failed to update profile');
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final response = await makeAuthenticatedRequest((token) {
      return http.post(
        Uri.parse(changePasswordUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );
    });

    if (response.statusCode == 200) {
      // Successfully changed password
    } else {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(errorData['detail'] ?? 'Failed to change password');
    }
  }

  Future<String?> _getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<http.Response> makeAuthenticatedRequest(
      Future<http.Response> Function(String token) request) async {
    String? token = await _getAccessToken();
    if (token == null) throw Exception('No access token available');

    http.Response response = await request(token);

    if (response.statusCode == 401) {
      await refreshAccessToken();
      token = await _getAccessToken();
      if (token == null) {
        throw Exception('No access token available after refresh');
      }

      response = await request(token);
    }

    return response;
  }

  Future<void> deleteUserAccount() async {
    final response = await makeAuthenticatedRequest((token) {
      return http.delete(
        Uri.parse(deleteAccountUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    });

    if (response.statusCode == 204) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
    } else {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(errorData['detail'] ?? 'Failed to delete user account');
    }
  }

  Future<String?> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/api/users/auth/password/forgot/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return null; // Success
    } else {
      return response.body; // Return error message
    }
  }

  Future<String?> resetPassword(
      String email, String resetCode, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/auth/password/reset/'),
        body: {
          'email': email,
          'reset_code': resetCode,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        return null; // Erfolgreich
      } else {
        return response.body; // Fehlernachricht
      }
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  Future<String?> refreshAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? refreshToken = prefs.getString('refreshToken');
    if (refreshToken == null) {
      return 'No refresh token available';
    }

    final response = await http.post(
      Uri.parse(refreshTokenUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      String accessToken = data['access'];
      await prefs.setString('accessToken', accessToken);
      return null;
    } else {
      return 'Failed to refresh access token';
    }
  }

  Future<String> regenerateApiKey() async {
    final response = await makeAuthenticatedRequest((token) {
      return http.post(
        Uri.parse('$baseUrl/api/users/auth/api-key/regenerate/'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['api_key'];
    } else {
      throw Exception('Failed to regenerate API key');
    }
  }
}
