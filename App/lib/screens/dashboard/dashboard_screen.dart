import 'package:aquaware/models/environment.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/screens/dashboard/add_public_environment_screen.dart';
import 'package:aquaware/screens/dashboard/create_environment_screen.dart';
import 'package:aquaware/services/environment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardScreen extends StatefulWidget {
  final Function(Environment) onEnvironmentTapped;

  const DashboardScreen({required this.onEnvironmentTapped, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EnvironmentService _environmentService = EnvironmentService();
  List<Environment> _environments = [];
  final List<Environment> _publicEnvironments = [];
  final List<Environment> _filteredEnvironments = [];
  bool _isLoading = true;
  String? _error;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cityController =
      TextEditingController(); // New Controller for City
  final String _selectedEnvironmentType = 'aquarium';
  final bool _isPublic = false;
  final String _searchQuery = "";

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
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        (_isPublic && _cityController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields')),
      );
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        await _environmentService.createEnvironment(
          _nameController.text,
          _descriptionController.text,
          _selectedEnvironmentType,
          _isPublic,
          _cityController.text,
        );
        _nameController.clear();
        _descriptionController.clear();
        _cityController.clear();
        _fetchEnvironments();
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }

      Navigator.of(context).pop();
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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateEnvironmentScreen(),
                  ),
                ).then((result) {
                  if (result == true) {
                    // Refresh environments after creation
                    _fetchEnvironments();
                  }
                }),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Add a publicly available Environment"),
              const SizedBox(width: 20),
              FloatingActionButton.small(
                heroTag: null,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPublicEnvironmentScreen(),
                  ),
                ).then((selectedEnvironment) {
                  if (selectedEnvironment != null) {
                    // Handle the selected public environment
                  }
                }),
                child: const Icon(Icons.public),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
