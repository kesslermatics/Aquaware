import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.fetchProfileError,
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
        AppLocalizations.of(context)!.success,
        AppLocalizations.of(context)!.profileUpdated,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      Get.snackbar(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.updateProfileError,
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
        AppLocalizations.of(context)!.success,
        AppLocalizations.of(context)!.apiKeyRegenerated,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await _fetchUserProfile(); // Refresh user profile
    } catch (e) {
      Get.snackbar(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.regenerateApiKeyError,
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
        AppLocalizations.of(context)!.success,
        AppLocalizations.of(context)!.accountDeleted,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Navigator.of(context)
          .pushReplacementNamed('/onboarding'); // Redirect to onboarding
    } catch (e) {
      Get.snackbar(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.deleteAccountError,
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
        title: Text(AppLocalizations.of(context)!.regenerateApiKey),
        content: Text(AppLocalizations.of(context)!.regenerateApiKeyMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
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
                : Text(AppLocalizations.of(context)!.regenerate),
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
        title: Text(AppLocalizations.of(context)!.deleteAccount),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.deleteAccountMessage),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: confirmTextController,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.enterDeleteAccountText),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: _isDeleting
                ? null
                : () {
                    if (confirmTextController.text ==
                        AppLocalizations.of(context)!.deleteAccountText) {
                      Navigator.of(context).pop();
                      _deleteAccount(
                          emailController.text, passwordController.text);
                    } else {
                      Get.snackbar(
                        AppLocalizations.of(context)!.error,
                        AppLocalizations.of(context)!.deleteAccountError2,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
            child: _isDeleting
                ? const CircularProgressIndicator()
                : Text(AppLocalizations.of(context)!.delete),
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
        child: Text(
          _errorMessage,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              label: AppLocalizations.of(context)!.firstNameFieldLabel,
              value: userProfile.firstName,
              onChanged: (value) => setState(() {
                userProfile.firstName = value;
              }),
              isEditable: true,
            ),
            _buildTextField(
              label: AppLocalizations.of(context)!.lastNameFieldLabel,
              value: userProfile.lastName,
              onChanged: (value) => setState(() {
                userProfile.lastName = value;
              }),
              isEditable: true,
            ),
            _buildTextField(
              label: AppLocalizations.of(context)!.emailFieldLabel,
              value: userProfile.email,
            ),
            _buildTextField(
              label: AppLocalizations.of(context)!.subscriptionTierFieldLabel,
              value: userProfile.subscriptionTier.toString(),
            ),
            _buildTextField(
              label: AppLocalizations.of(context)!.dateJoinedFieldLabel,
              value: userProfile.dateJoined.toString(),
            ),
            _buildTextField(
              label: AppLocalizations.of(context)!.apiKeyFieldLabel,
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
              child: Text(AppLocalizations.of(context)!.regenerateApiKeyButton),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateProfile,
              child: _isUpdating
                  ? const CircularProgressIndicator()
                  : Text(AppLocalizations.of(context)!.updateProfileButton),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _showDeleteAccountDialog,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(AppLocalizations.of(context)!.deleteAccountButton),
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
