import 'dart:ui'; // For BackdropFilter
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

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
  bool isLocked = false;

  @override
  void initState() {
    super.initState();
    _alertSettingsFuture = _loadAlertSettings();
    _checkUserSubscription();
  }

  void _checkUserSubscription() {
    final userProfile = UserProfile.getInstance();
    if (userProfile.subscriptionTier == 1) {
      setState(() {
        isLocked = true;
      });
    }
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
      Get.snackbar(
        'Error',
        AppLocalizations.of(context)!.alertSettingsLoadError(error.toString()),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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

      Get.snackbar(
        'Success',
        AppLocalizations.of(context)!.alertSaved,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
      Get.snackbar(
        'Error',
        AppLocalizations.of(context)!.alertSaveError(error.toString()),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _alertSettingsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                      loc.alertSettingsLoadError(snapshot.error.toString())),
                );
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
                      Text(
                        loc.alertNotifyEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
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
                                Text('${widget.parameterName} ${loc.isUnder} '),
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
                                Text(widget.unit),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
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
                                Text('${widget.parameterName} ${loc.isAbove} '),
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
                                Text(widget.unit),
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
                                child: Text(loc.save),
                              ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          if (isLocked)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock, size: 60, color: Colors.white),
                        const SizedBox(height: 20),
                        Text(
                          loc.featureLockedMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
