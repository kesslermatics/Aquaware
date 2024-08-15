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

  void _saveAlertSettings() async {
    String parameter = 'Ammonia';
    double? underValue =
        notifyUnder ? double.tryParse(underController.text) : null;
    double? aboveValue =
        notifyAbove ? double.tryParse(aboveController.text) : null;

    // Implement your AlertService here to save the settings
    await AlertService().saveAlertSettings(
      widget.aquariumId,
      parameter,
      underValue,
      aboveValue,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alert settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ammonia levels that are too high can be dangerous for your fish, leading to stress, illness, and even death. '
              'Ideally, ammonia levels should be kept at 0 ppm.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Notify me per E-Mail when...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CheckboxListTile(
              title: Row(
                children: [
                  Text('Ammonia is under '),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: underController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'e.g., 0.25',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Text(' ppm'),
                ],
              ),
              value: notifyUnder,
              onChanged: (bool? value) {
                setState(() {
                  notifyUnder = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Row(
                children: [
                  Text('Ammonia is above '),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: aboveController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'e.g., 1.0',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Text(' ppm'),
                ],
              ),
              value: notifyAbove,
              onChanged: (bool? value) {
                setState(() {
                  notifyAbove = value ?? false;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveAlertSettings,
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
