import 'package:aquaware/models/environment.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/services/environment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class DashboardScreen extends StatefulWidget {
  final Function(Environment) onEnvironmentTapped;

  const DashboardScreen({required this.onEnvironmentTapped, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EnvironmentService _environmentService = EnvironmentService();
  List<Environment> _environments = [];
  bool _isLoading = true;
  String? _error;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedEnvironmentType = 'aquarium';
  bool _isPublic = false;

  static const List<Map<String, String>> ENVIRONMENT_TYPES = [
    {'value': 'aquarium', 'label': 'Aquarium'},
    {'value': 'lake', 'label': 'Lake'},
    {'value': 'sea', 'label': 'Sea'},
    {'value': 'pool', 'label': 'Pool'},
    {'value': 'other', 'label': 'Other'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchEnvironments();
  }

  Future<void> _fetchEnvironments() async {
    try {
      final environments = await _environmentService.getUserEnvironment();
      setState(() {
        _environments = environments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createEnvironment() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
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
      );
      _nameController.clear();
      _descriptionController.clear();
      _fetchEnvironments();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Welcome, ${UserProfile.getInstance().firstName}!',
                  style: const TextStyle(fontSize: 24)),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Error: $_error'))
                    : _environments.isEmpty
                        ? const Center(
                            child:
                                Text('No environments found. Please add one.'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _environments.length,
                            itemBuilder: (context, index) {
                              final environment = _environments[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: ListTile(
                                  title: Text(environment.name),
                                  subtitle: Text(environment.description),
                                  trailing: const Icon(Icons.arrow_forward),
                                  onTap: () =>
                                      widget.onEnvironmentTapped(environment),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.add),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(
          child: const Icon(Icons.close),
          fabSize: ExpandableFabSize.regular,
          shape: const CircleBorder(),
        ),
        type: ExpandableFabType.up,
        childrenAnimation: ExpandableFabAnimation.none,
        distance: 70,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.white.withOpacity(0.9),
        ),
        children: [
          Row(
            children: [
              const Text("Add a new Aquatic Environment"),
              const SizedBox(width: 20),
              FloatingActionButton.small(
                heroTag: null,
                onPressed: () => _showCreateEnvironmentDialog(context),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateEnvironmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'Add an Aquatic Environment',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                value: _selectedEnvironmentType,
                decoration:
                    const InputDecoration(labelText: 'Environment Type'),
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
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text('Public'),
                  Checkbox(
                    value: _isPublic,
                    onChanged: (value) {
                      setState(() {
                        _isPublic = value!;
                      });
                      if (value != null && value) {
                        _showPublicWarning();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _createEnvironment();
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
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
