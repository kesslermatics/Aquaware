import 'package:flutter/material.dart';
import 'package:aquaware/services/environment_service.dart';
import 'package:aquaware/models/environment.dart';

class AddPublicEnvironmentScreen extends StatefulWidget {
  const AddPublicEnvironmentScreen({super.key});

  @override
  _AddPublicEnvironmentScreenState createState() =>
      _AddPublicEnvironmentScreenState();
}

class _AddPublicEnvironmentScreenState
    extends State<AddPublicEnvironmentScreen> {
  final EnvironmentService _environmentService = EnvironmentService();
  List<Environment> _publicEnvironments = [];
  List<Environment> _filteredEnvironments = [];
  String _searchQuery = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPublicEnvironments();
  }

  Future<void> _fetchPublicEnvironments() async {
    try {
      final environments = await _environmentService.getPublicEnvironments();
      setState(() {
        _publicEnvironments = environments;
        _filteredEnvironments = environments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching public environments: $e')),
      );
    }
  }

  void _filterEnvironments(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredEnvironments = _publicEnvironments
          .where((env) =>
              env.name.toLowerCase().contains(_searchQuery) ||
              (env.city.toLowerCase() ?? '').contains(_searchQuery) ||
              env.description.toLowerCase().contains(_searchQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Environments'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Environments',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterEnvironments,
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: _filteredEnvironments.isEmpty
                      ? const Center(
                          child: Text('No public environments found.'))
                      : ListView.builder(
                          itemCount: _filteredEnvironments.length,
                          itemBuilder: (context, index) {
                            final environment = _filteredEnvironments[index];
                            return Card(
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(10),
                                title: Text(
                                  environment.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        color: Colors.lightBlue[50],
                                        child: Text(
                                          environment.city,
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        environment.description,
                                        style: const TextStyle(
                                            color: Colors.black54),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () async {
                                    try {
                                      await _environmentService
                                          .subscribeToPublicEnvironment(
                                              environment.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Successfully subscribed!')),
                                      );
                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Failed to subscribe: $e')));
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }
}
