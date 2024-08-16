import 'package:aquaware/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmmoniaAlertsScreen extends StatefulWidget {
  final int aquariumId;

  const AmmoniaAlertsScreen({super.key, required this.aquariumId});

  @override
  _AmmoniaAlertsScreenState createState() => _AmmoniaAlertsScreenState();
}

class _AmmoniaAlertsScreenState extends State<AmmoniaAlertsScreen> {
  bool notifyUnder = false;
  bool notifyAbove = false;
  TextEditingController underController = TextEditingController();
  TextEditingController aboveController = TextEditingController();
  final AlertService _alertService = AlertService();

  @override
  void initState() {
    super.initState();
    _loadAlertSettings();
  }

  Future<void> _loadAlertSettings() async {
    try {
      final alertSettings =
          await _alertService.getAlertSettings(widget.aquariumId, 'Ammonia');

      if (alertSettings != null) {
        setState(() {
          notifyUnder = alertSettings['under_value'] != null;
          notifyAbove = alertSettings['above_value'] != null;
          underController.text = alertSettings['under_value']?.toString() ?? '';
          aboveController.text = alertSettings['above_value']?.toString() ?? '';
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load alert settings')),
      );
    }
  }

  void _saveAlertSettings() async {
    String parameter = 'Ammonia';
    double? underValue =
        notifyUnder ? double.tryParse(underController.text) : null;
    double? aboveValue =
        notifyAbove ? double.tryParse(aboveController.text) : null;

    try {
      await _alertService.saveAlertSettings(
        widget.aquariumId,
        parameter,
        underValue,
        aboveValue,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alert settings saved')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save alert settings')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: notifyUnder == null && notifyAbove == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ammonia levels that are too high can be dangerous for your fish, leading to stress, illness, and even death. '
                    'Ideally, ammonia levels should be kept at 0 ppm.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Notify me per E-Mail when...',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: notifyUnder,
                        onChanged: (bool? value) {
                          setState(() {
                            notifyUnder = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'Ammonia is under ',
                              style: TextStyle(
                                fontSize: 12, // Kleinere Schriftgröße
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: underController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(8, 8, 8, 8),
                                  isDense: true, // Weniger Innenabstand
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'ppm',
                              style: TextStyle(
                                fontSize: 12, // Kleinere Schriftgröße
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: notifyAbove,
                        onChanged: (bool? value) {
                          setState(() {
                            notifyAbove = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'Ammonia is above ',
                              style: TextStyle(
                                fontSize: 12, // Kleinere Schriftgröße
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: aboveController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'ppm',
                              style: TextStyle(
                                fontSize: 12, // Kleinere Schriftgröße
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveAlertSettings,
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
