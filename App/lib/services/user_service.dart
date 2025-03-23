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
    email = email.trim();
    password = password.trim();
    password2 = password2.trim();

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
      String apiKey = data['api_key'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_key', apiKey);
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
      return errors.join('\n');
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
      String apiKey = data['api_key'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_key', apiKey);
      return null;
    } else {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      return errorData['error'] ?? 'Failed to sign up with Google';
    }
  }

  Future<String?> login(String email, String password) async {
    email = email.trim();
    password = password.trim();

    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 202) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      String apiKey = data['api_key'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_key', apiKey);
      return null;
    } else {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      return errorData['message'] ?? 'Failed to log in';
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
      String apiKey = data['api_key'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('api_key', apiKey);
      return null;
    } else {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      return errorData['error'] ?? 'Failed to log in';
    }
  }

  Future<void> getUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('api_key');

    if (apiKey == null) {
      throw Exception('No API key found. Please log in again.');
    }

    final response = await http.get(
      Uri.parse(profileUrl),
      headers: {'x-api-key': apiKey},
    );

    if (response.statusCode == 200) {
      UserProfile.setFromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to get user profile');
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? apiKey = prefs.getString('api_key');

    if (apiKey == null) {
      throw Exception('No API key found. Please log in again.');
    }

    final response = await http.put(
      Uri.parse(updateProfileUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(errorData['detail'] ?? 'Failed to update profile');
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? apiKey = prefs.getString('api_key');

    if (apiKey == null) {
      throw Exception('No API key found. Please log in again.');
    }

    final response = await http.post(
      Uri.parse(changePasswordUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(errorData['detail'] ?? 'Failed to change password');
    }
  }

  Future<void> deleteUserAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? apiKey = prefs.getString('api_key');

    if (apiKey == null) {
      throw Exception('No API key found. Please log in again.');
    }

    final response = await http.delete(
      Uri.parse(deleteAccountUrl),
      headers: {
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 204) {
      await prefs.remove('api_key');
    } else {
      var errorData = jsonDecode(utf8.decode(response.bodyBytes));
      throw Exception(errorData['detail'] ?? 'Failed to delete user account');
    }
  }

  Future<String?> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/auth/password/forgot/'),
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
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/auth/password/reset/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'reset_code': resetCode,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return null; // Success
    } else {
      return response.body; // Error message
    }
  }

  Future<void> regenerateApiKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? apiKey = prefs.getString('api_key');

    if (apiKey == null) {
      throw Exception('No API key found. Please log in again.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/users/auth/api-key/regenerate/'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String newApiKey = data['api_key'];
      await prefs.setString('api_key', newApiKey);
    } else {
      throw Exception('Failed to regenerate API key');
    }
  }
}
