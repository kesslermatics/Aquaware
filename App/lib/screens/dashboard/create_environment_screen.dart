import 'package:flutter/material.dart';
import 'package:aquaware/services/environment_service.dart';
import 'package:aquaware/models/environment.dart';

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
  bool _isPublic = false;
  bool _isLoading = false;

  static const List<Map<String, String>> ENVIRONMENT_TYPES = [
    {'value': 'aquarium', 'label': 'Aquarium'},
    {'value': 'lake', 'label': 'Lake'},
    {'value': 'sea', 'label': 'Sea'},
    {'value': 'pool', 'label': 'Pool'},
    {'value': 'other', 'label': 'Other'},
  ];

  Future<void> _createEnvironment() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        (_isPublic && _cityController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields')),
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
        _isPublic,
        _isPublic ? _cityController.text : '',
      );
      Navigator.pop(context, true); // Return success to the previous screen
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Environment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedEnvironmentType,
              decoration: const InputDecoration(labelText: 'Environment Type'),
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
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Public'),
                Checkbox(
                  value: _isPublic,
                  onChanged: (value) {
                    if (value!) {
                      _showPublicWarning();
                    }
                    setState(() {
                      _isPublic = value;
                    });
                  },
                ),
              ],
            ),
            if (_isPublic) ...[
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _createEnvironment,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Create Environment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPublicWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Warning'),
        content: const Text(
            'By making this environment public, everyone will be able to see its values.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
