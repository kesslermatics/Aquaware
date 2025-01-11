import 'package:aquaware/models/environment.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/screens/dashboard/add_public_environment_screen.dart';
import 'package:aquaware/screens/dashboard/create_environment_screen.dart';
import 'package:aquaware/screens/dashboard/tutorial/tutorial_page.dart';
import 'package:aquaware/services/environment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';

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

  Future<void> _deleteEnvironment(
      BuildContext context, Environment environment) async {
    TextEditingController nameController = TextEditingController();
    bool isDeleting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Delete Environment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Please enter the name of the environment to confirm deletion:'),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Environment Name',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: isDeleting
                  ? null
                  : () async {
                      if (nameController.text == environment.name) {
                        setState(() {
                          isDeleting = true;
                        });
                        await _environmentService
                            .deleteEnvironment(environment.id);
                        setState(() {
                          _environments.remove(environment);
                          isDeleting = false;
                          _fetchEnvironments();
                        });
                        Navigator.of(context).pop();
                        Get.snackbar(
                            'Success', 'Environment deleted successfully',
                            snackPosition: SnackPosition.BOTTOM);
                      } else {
                        Get.snackbar('Error',
                            'Environment name does not match. Please try again.',
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    },
              child: isDeleting
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, ${UserProfile.getInstance().firstName}!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Text('Error: $_error'),
                      )
                    : _environments.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Hmm, seems like there’s no environment yet. Why don\'t you click here for a quick guide on how to start:',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => const TutorialPage());
                                  },
                                  child: const Text('Getting Started'),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _environments.length,
                            itemBuilder: (context, index) {
                              final environment = _environments[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                child: ListTile(
                                  leading: environment.public
                                      ? const Icon(Icons.public,
                                          color: Colors.blue)
                                      : null,
                                  title: Text(environment.name),
                                  subtitle: Text(environment.description),
                                  trailing: const Icon(Icons.arrow_forward),
                                  onTap: () =>
                                      widget.onEnvironmentTapped(environment),
                                  onLongPress: () {
                                    _deleteEnvironment(context, environment);
                                  },
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
                onPressed: () => Get.to(() => const CreateEnvironmentScreen())
                    ?.then((result) {
                  if (result == true) {
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
                onPressed: () =>
                    Get.to(() => const AddPublicEnvironmentScreen())
                        ?.then((result) {
                  _fetchEnvironments();
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
