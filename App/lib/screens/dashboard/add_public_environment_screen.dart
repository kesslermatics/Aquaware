import 'package:flutter/material.dart';
import 'package:aquaware/services/environment_service.dart';
import 'package:aquaware/models/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .errorFetchingEnvironments(e.toString())),
        ),
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
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.publicEnvironmentsTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: loc.searchEnvironmentsLabel,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _filterEnvironments,
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: _filteredEnvironments.isEmpty
                      ? Center(
                          child: Text(loc.noPublicEnvironmentsFound),
                        )
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
                                        SnackBar(
                                          content:
                                              Text(loc.subscriptionSuccess),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(loc.subscriptionFailed(
                                              e.toString())),
                                        ),
                                      );
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
