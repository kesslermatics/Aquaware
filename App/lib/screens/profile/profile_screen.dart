import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  bool _isLoading = true;
  bool _isUpdating = false;
  bool _isRegenerating = false;
  bool _isDeleting = false;
  bool _apiKeyVisible = false;
  String _errorMessage = "";

  late UserProfile userProfile;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      await _userService.getUserProfile(); // Fetch and set UserProfile
      setState(() {
        userProfile = UserProfile.getInstance(); // Access the instance
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isUpdating = true;
      _errorMessage = "";
    });

    try {
      await _userService.updateUserProfile({
        'first_name': userProfile.firstName,
        'last_name': userProfile.lastName,
      });
      Get.snackbar(
        "Success",
        "Profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  Future<void> _regenerateApiKey() async {
    setState(() {
      _isRegenerating = true;
    });

    try {
      await _userService
          .regenerateApiKey(); // Implement this method in UserService
      Get.snackbar(
        "Success",
        "API Key regenerated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await _fetchUserProfile(); // Refresh user profile
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isRegenerating = false;
      });
    }
  }

  Future<void> _deleteAccount(String email, String password) async {
    setState(() {
      _isDeleting = true;
    });

    try {
      await _userService
          .deleteUserAccount(); // Implement this method in UserService
      Get.snackbar(
        "Success",
        "Account deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Navigator.of(context)
          .pushReplacementNamed('/onboarding'); // Redirect to onboarding
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  void _showRegenerateApiKeyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Regenerate API Key"),
        content: const Text(
            "Regenerating your API key will revoke the old key, and any devices using it will need to be updated with the new key. Are you sure you want to continue?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: _isRegenerating
                ? null
                : () {
                    Navigator.of(context).pop();
                    _regenerateApiKey();
                  },
            child: _isRegenerating
                ? const CircularProgressIndicator()
                : const Text("Regenerate"),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmTextController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "This action is irreversible. Please confirm your email, password, and enter 'DELETE ACCOUNT' to proceed."),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: confirmTextController,
              decoration:
                  const InputDecoration(labelText: "Enter 'DELETE ACCOUNT'"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: _isDeleting
                ? null
                : () {
                    if (confirmTextController.text == "DELETE ACCOUNT") {
                      Navigator.of(context).pop();
                      _deleteAccount(
                          emailController.text, passwordController.text);
                    } else {
                      Get.snackbar(
                        "Error",
                        "You must enter 'DELETE ACCOUNT' exactly.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
            child: _isDeleting
                ? const CircularProgressIndicator()
                : const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
          child:
              Text(_errorMessage, style: const TextStyle(color: Colors.red)));
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              label: "First Name",
              value: userProfile.firstName,
              onChanged: (value) => setState(() {
                userProfile.firstName = value;
              }),
              isEditable: true,
            ),
            _buildTextField(
              label: "Last Name",
              value: userProfile.lastName,
              onChanged: (value) => setState(() {
                userProfile.lastName = value;
              }),
              isEditable: true,
            ),
            _buildTextField(label: "Email", value: userProfile.email),
            _buildTextField(
                label: "Subscription Tier",
                value: userProfile.subscriptionTier.toString()),
            _buildTextField(
                label: "Date Joined", value: userProfile.dateJoined.toString()),
            _buildTextField(
              label: "API Key",
              value: userProfile.apiKey,
              isPassword: !_apiKeyVisible,
              suffixIcon: IconButton(
                icon: Icon(
                    _apiKeyVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() {
                  _apiKeyVisible = !_apiKeyVisible;
                }),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showRegenerateApiKeyDialog,
              child: const Text("Regenerate API Key"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateProfile,
              child: _isUpdating
                  ? const CircularProgressIndicator()
                  : const Text("Update Profile"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showDeleteAccountDialog,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete Account"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    bool isEditable = false,
    bool isPassword = false,
    ValueChanged<String>? onChanged,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        readOnly: !isEditable,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        controller: TextEditingController(text: value),
        onChanged: onChanged,
      ),
    );
  }
}
