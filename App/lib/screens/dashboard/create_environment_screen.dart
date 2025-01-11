import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _cityController.text.isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please fill out all required fields',
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
        _descriptionController.text,
        _selectedEnvironmentType,
        false, // Public is removed, default to false
        _cityController.text,
      );

      Get.snackbar(
        'Success',
        'Environment "${_nameController.text}" created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Navigator.pop(context, true); // Return success to the previous screen
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to create environment: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Environment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedEnvironmentType,
              decoration: const InputDecoration(
                labelText: 'Environment Type',
                border: OutlineInputBorder(),
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
                    : const Text(
                        'Create Environment',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
