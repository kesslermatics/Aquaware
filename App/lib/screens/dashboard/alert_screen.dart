import 'package:aquaware/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlertScreen extends StatefulWidget {
  final String infotext;
  final String parameterName;
  final int aquariumId;
  final String unit;

  const AlertScreen({
    super.key,
    required this.infotext,
    required this.parameterName,
    required this.aquariumId,
    required this.unit,
  });

  @override
  _AlertScreenState createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  bool notifyUnder = false;
  bool notifyAbove = false;
  TextEditingController underController = TextEditingController();
  TextEditingController aboveController = TextEditingController();
  final AlertService _alertService = AlertService();
  late Future<Map<String, dynamic>?> _alertSettingsFuture;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _alertSettingsFuture = _loadAlertSettings();
  }

  Future<Map<String, dynamic>?> _loadAlertSettings() async {
    try {
      final alertSettings = await _alertService.getAlertSettings(
          widget.aquariumId, widget.parameterName);
      if (alertSettings != null) {
        notifyUnder = alertSettings['under_value'] != null;
        notifyAbove = alertSettings['above_value'] != null;
        underController.text = alertSettings['under_value']?.toString() ?? '';
        aboveController.text = alertSettings['above_value']?.toString() ?? '';
      }
      return alertSettings;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load alert settings')),
      );
      return null;
    }
  }

  void _saveAlertSettings() async {
    setState(() {
      isSaving = true;
    });

    double? underValue =
        notifyUnder ? double.tryParse(underController.text) : null;
    double? aboveValue =
        notifyAbove ? double.tryParse(aboveController.text) : null;

    try {
      await _alertService.saveAlertSettings(
        widget.aquariumId,
        widget.parameterName,
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
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _alertSettingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load alert settings'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.infotext,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Notify me per E-Mail when...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            Text(
                              '${widget.parameterName} is under ',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: underController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.unit,
                              style: TextStyle(
                                fontSize: 14,
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
                            Text(
                              '${widget.parameterName} is above ',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: aboveController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.unit,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: isSaving
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _saveAlertSettings,
                            child: const Text('Save'),
                          ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
