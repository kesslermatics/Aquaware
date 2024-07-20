import 'dart:convert';
import 'package:aquaware/constants.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String signupUrl = '${baseUrl}/api/users/signup/';
  static const String loginUrl = '${baseUrl}/api/users/login/';
  static const String refreshTokenUrl = '${baseUrl}/api/users/token/refresh/';
  static const String profileUrl = '${baseUrl}/api/users/profile/';
  static const String updateProfileUrl = '${baseUrl}profile/update/';
  static const String changePasswordUrl = '${baseUrl}change-password/';
  static const String deleteAccountUrl = '${baseUrl}delete-account/';
  static const String testUrl = '${baseUrl}test/';

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
      login(email, password);
      return null; // Erfolgreiche Registrierung
    } else if (response.statusCode == 500) {
      return "Server Error. Try again later";
    } else {
      var errorData = jsonDecode(response.body);
      List<String> errors = [];
      errorData.forEach((key, value) {
        if (value is List) {
          errors.addAll(List<String>.from(value.map((msg) => msg.toString())));
        }
      });
      return errors.join('\n'); // Fehlermeldungen zurückgeben
    }
  }

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 202) {
      var data = jsonDecode(response.body);
      String accessToken = data['access'];
      String refreshToken = data['refresh'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('refreshToken', refreshToken);
      return null; // Erfolgreiches Login
    } else {
      var errorData = jsonDecode(response.body);
      return errorData['message'] ??
          'Failed to log in'; // Fehlermeldung zurückgeben
    }
  }

  Future<UserProfile> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final response = await http.get(
      Uri.parse(profileUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user profile');
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final response = await http.put(
      Uri.parse(updateProfileUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      var errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? 'Failed to update profile');
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final response = await http.post(
      Uri.parse(changePasswordUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      print('Password changed successfully');
    } else {
      var errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? 'Failed to change password');
    }
  }

  Future<void> deleteUserAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');

    final response = await http.delete(
      Uri.parse(deleteAccountUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 204) {
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      print('User account deleted successfully');
    } else {
      var errorData = jsonDecode(response.body);
      throw Exception(errorData['detail'] ?? 'Failed to delete user account');
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
      var data = jsonDecode(response.body);
      String accessToken = data['access'];
      await prefs.setString('accessToken', accessToken);
      return null;
    } else {
      return 'Failed to refresh access token';
    }
  }
}
