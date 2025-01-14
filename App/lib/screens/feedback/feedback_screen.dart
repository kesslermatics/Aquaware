import 'dart:convert';

import 'package:aquaware/constants.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendFeedback() async {
    final loc = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? apiKey = prefs.getString('api_key');

      if (apiKey == null) {
        throw Exception('API key is missing');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/feedback/'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
        },
        body: jsonEncode({
          'title': _titleController.text,
          'message': _messageController.text,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          loc.feedbackSuccessTitle,
          loc.feedbackSuccessMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _titleController.clear();
        _messageController.clear();
      } else {
        Get.snackbar(
          loc.feedbackErrorTitle,
          loc.feedbackErrorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        loc.feedbackErrorTitle,
        loc.feedbackErrorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: loc.feedbackTitleLabel),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.feedbackTitleValidation;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration:
                    InputDecoration(labelText: loc.feedbackMessageLabel),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.feedbackMessageValidation;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendFeedback,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(loc.sendFeedbackButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
