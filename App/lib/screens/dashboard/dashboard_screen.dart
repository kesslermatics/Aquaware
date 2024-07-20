import 'package:aquaware/models/aquarium.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/services/aquarium_service.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final UserProfile profile;

  const DashboardScreen({required this.profile, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AquariumService _aquariumService = AquariumService();
  List<Aquarium> _aquariums = [];
  bool _isLoading = true;
  String? _error;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAquariums();
  }

  Future<void> _fetchAquariums() async {
    try {
      final aquariums = await _aquariumService.getUserAquariums();
      setState(() {
        _aquariums = aquariums;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createAquarium() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _aquariumService.createAquarium(
        _nameController.text,
        _descriptionController.text,
      );
      _nameController.clear();
      _descriptionController.clear();
      _fetchAquariums();
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
              child: Text('Welcome, ${widget.profile.firstName}!',
                  style: TextStyle(fontSize: 24)),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Error: $_error'))
                    : _aquariums.isEmpty
                        ? Center(
                            child: Text('No aquariums found. Please add one.'))
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: _aquariums.length,
                            itemBuilder: (context, index) {
                              final aquarium = _aquariums[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 16),
                                child: ListTile(
                                  title: Text(aquarium.name),
                                  subtitle: Text(aquarium.description),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
      // Floating Action Button to create a new aquarium
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateAquariumDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Create Aquarium',
      ),
    );
  }

  void _showCreateAquariumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add an Aquarium',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _createAquarium();
              Navigator.of(context).pop();
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }
}
