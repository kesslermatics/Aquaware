import 'package:aquaware/models/environment.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/screens/dashboard/add_public_environment_screen.dart';
import 'package:aquaware/screens/dashboard/create_environment_screen.dart';
import 'package:aquaware/screens/dashboard/tutorial/tutorial_page.dart';
import 'package:aquaware/services/color_provider.dart';
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
    final TextEditingController nameController = TextEditingController();
    bool isDeleting = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: ColorProvider.n6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Delete Environment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please enter the name of the environment to confirm deletion:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Environment Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
                          'Success',
                          'Environment "${environment.name}" deleted successfully',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      } else {
                        Get.snackbar(
                          'Error',
                          'Environment name does not match. Please try again.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
              child: isDeleting
                  ? const CircularProgressIndicator()
                  : const Text('Delete'),
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
                    ? const Center(
                        child: Text(
                          'Error: Something went wrong. Please try again later.',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
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
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: _environments.length,
                            itemBuilder: (context, index) {
                              final environment = _environments[index];
                              return GestureDetector(
                                onTap: () =>
                                    widget.onEnvironmentTapped(environment),
                                onLongPress: () {
                                  _deleteEnvironment(context, environment);
                                },
                                child: Card(
                                  color: ColorProvider.n6,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ID: ${environment.id}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white54,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                environment.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                environment.description,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                environment.city,
                                                style: const TextStyle(
                                                  color: Colors.white38,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white54,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
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
          color: Colors.white.withOpacity(0.2),
        ),
        children: [
          Row(
            children: [
              const Text(
                "Add a new Aquatic Environment",
                style: TextStyle(
                  color: ColorProvider.n1,
                ),
              ),
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
              const Text(
                "Add a publicly available Environment",
                style: TextStyle(
                  color: ColorProvider.n1,
                ),
              ),
              const SizedBox(width: 20),
              FloatingActionButton.small(
                heroTag: null,
                onPressed: () => Get.to(() => const CreateEnvironmentScreen())
                    ?.then((result) {
                  if (result == true) {
                    _fetchEnvironments();
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
