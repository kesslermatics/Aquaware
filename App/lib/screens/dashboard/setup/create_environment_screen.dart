import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:aquaware/services/environment_service.dart';

class CreateEnvironmentScreen extends StatefulWidget {
  const CreateEnvironmentScreen({super.key});

  @override
  _CreateEnvironmentScreenState createState() =>
      _CreateEnvironmentScreenState();
}

class _CreateEnvironmentScreenState extends State<CreateEnvironmentScreen> {
  final EnvironmentService _environmentService = EnvironmentService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String _selectedEnvironmentType = 'aquarium';
  bool _isLoading = false;

  static const List<Map<String, String>> ENVIRONMENT_TYPES = [
    {'value': 'aquarium', 'label': 'Aquarium'},
    {'value': 'pond', 'label': 'Pond'},
    {'value': 'lake', 'label': 'Lake'},
    {'value': 'sea', 'label': 'Sea'},
    {'value': 'pool', 'label': 'Pool'},
    {'value': 'other', 'label': 'Other'},
  ];

  Future<void> _createEnvironment() async {
    final loc = AppLocalizations.of(context)!;

    if (_nameController.text.isEmpty) {
      Get.snackbar(
        loc.missingInfoTitle,
        loc.missingInfoMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _environmentService.createEnvironment(
        _nameController.text,
        _descriptionController.text.isEmpty ? "" : _descriptionController.text,
        _selectedEnvironmentType,
        false,
        _cityController.text.isEmpty ? "" : _cityController.text,
      );

      Get.snackbar(
        loc.successTitle,
        loc.environmentCreated(_nameController.text),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        loc.errorTitle,
        loc.environmentCreateError(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.addEnvironment),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: loc.name,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: loc.description,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: loc.city,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedEnvironmentType,
              decoration: InputDecoration(
                labelText: loc.environmentType,
                border: const OutlineInputBorder(),
              ),
              items: ENVIRONMENT_TYPES.map((type) {
                return DropdownMenuItem<String>(
                  value: type['value'],
                  child: Text(type['label']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedEnvironmentType = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createEnvironment,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        loc.createEnvironment,
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
