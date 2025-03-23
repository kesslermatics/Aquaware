import 'dart:convert';

import 'package:aquaware/models/environment.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/services/environment_service.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class SetupHardwareScreen extends StatefulWidget {
  const SetupHardwareScreen({super.key});

  @override
  _SetupHardwareScreenState createState() => _SetupHardwareScreenState();
}

class _SetupHardwareScreenState extends State<SetupHardwareScreen> {
  BluetoothDevice? selectedDevice;
  String? currentSsid;
  bool isScanning = false;
  bool isLoading = false;
  bool isPasswordVisible = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String _selectedEnvironmentType = 'aquarium';
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  static const List<Map<String, String>> ENVIRONMENT_TYPES = [
    {'value': 'aquarium', 'label': 'Aquarium'},
    {'value': 'pond', 'label': 'Pond'},
    {'value': 'lake', 'label': 'Lake'},
    {'value': 'sea', 'label': 'Sea'},
    {'value': 'pool', 'label': 'Pool'},
    {'value': 'other', 'label': 'Other'},
  ];

  @override
  void initState() {
    super.initState();
    _startSetup();
  }

  Future<void> _startSetup() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulated delay
    await _scanBleDevices();
    await _getCurrentWifi();
  }

  /// Scans for BLE devices and selects the first found "Aquaware BLE" device.
  Future<void> _scanBleDevices() async {
    setState(() => isScanning = true);
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      for (var r in results) {
        if (r.device.name == "Aquaware BLE" && selectedDevice == null) {
          setState(() {
            selectedDevice = r.device;
            isScanning = false;
          });
          FlutterBluePlus.stopScan();
          break;
        }
      }
    });

    Future.delayed(const Duration(seconds: 10), () {
      setState(() => isScanning = false);
      FlutterBluePlus.stopScan();
    });
  }

  /// Retrieves the currently connected WiFi SSID.
  Future<void> _getCurrentWifi() async {
    String? ssid = await NetworkInfo().getWifiName();
    if (ssid != null && ssid.startsWith('"') && ssid.endsWith('"')) {
      ssid = ssid.substring(1, ssid.length - 1);
    }
    setState(() => currentSsid = ssid ?? "Unknown");
  }

  /// Completes the setup process and sends data via BLE.
  void _finishSetup() async {
    final loc = AppLocalizations.of(context)!;

    if (selectedDevice == null ||
        currentSsid == null ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      Get.snackbar(
        loc.errorTitle,
        loc.missingInfoMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      Get.snackbar(
        loc.infoTitle,
        loc.setupMightTakeTime, // z. B. „Dies kann bis zu einer Minute dauern – bitte habe Geduld.“
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
      );

      EnvironmentService service = EnvironmentService();
      String description = _descriptionController.text.isEmpty
          ? ""
          : _descriptionController.text;
      String city = _cityController.text.isEmpty ? "" : _cityController.text;

      var environment = await service.createEnvironment(
        _nameController.text,
        description,
        _selectedEnvironmentType,
        false,
        city,
      );

      int environmentId = environment.id;
      String apiKey = UserProfile.getInstance().apiKey;
      String bleData =
          "$currentSsid,${_passwordController.text},$apiKey,$environmentId";

      BluetoothCharacteristic? characteristic =
          await findWriteCharacteristic(selectedDevice!);

      if (characteristic != null) {
        await characteristic.setNotifyValue(true);

        await characteristic.write(bleData.codeUnits, withoutResponse: false);

        // Warte 30 Sekunden, bis Controller Setup abschließt
        await Future.delayed(const Duration(seconds: 30));

        // Setup-Status prüfen
        bool isSetup = false;
        try {
          var checkResponse = await service.checkSetupStatus(environmentId);
          isSetup = checkResponse;
        } catch (e) {
          print("Fehler beim Setup-Check: $e");
        }

        if (isSetup) {
          Get.snackbar(
            loc.successTitle,
            loc.deviceSetupComplete,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          _confettiController.play();
          Get.offAllNamed('/homepage');
        } else {
          await service.deleteEnvironment(environmentId);
          Get.snackbar(
            loc.errorTitle,
            loc.deviceSetupFailed,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          loc.errorTitle,
          loc.bleWriteFailed,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        loc.errorTitle,
        loc.environmentCreateError(e.toString()),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.setupHardwareTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // BLE Scan Result
            Card(
              color: selectedDevice != null ? Colors.green[200] : null,
              child: ListTile(
                leading: const Icon(Icons.bluetooth),
                title: Text(
                  selectedDevice != null
                      ? loc.deviceFound
                      : loc.searchingSensorKit,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selectedDevice != null ? Colors.green[800] : null),
                ),
                subtitle: selectedDevice != null
                    ? Text(selectedDevice!.id.toString())
                    : isScanning
                        ? const LinearProgressIndicator()
                        : Text(loc.noDevicesFound),
              ),
            ),
            const SizedBox(height: 20),

            // WiFi Selection & Password Entry
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.selectWifi,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentSsid ?? loc.searchingWifi,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: loc.password,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Environment Name Input
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: loc.name,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Description Input (Optional)
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: loc.description,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // City Input (Optional)
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: loc.city,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown for Environment Type
            DropdownButtonFormField<String>(
              value: _selectedEnvironmentType,
              decoration: InputDecoration(
                labelText: loc.environmentType,
                border: const OutlineInputBorder(),
              ),
              items: ENVIRONMENT_TYPES.map((type) {
                return DropdownMenuItem<String>(
                  value: type['value'],
                  child: Text(type['label']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedEnvironmentType = value!;
                });
              },
            ),
            const SizedBox(height: 32),

            // Finish Setup Button
            ElevatedButton(
              onPressed: _finishSetup,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white) // ⏳ Lade-Icon während Verarbeitung
                  : Text(loc.finishSetup),
            ),
          ],
        ),
      ),
    );
  }

  Future<BluetoothCharacteristic?> findWriteCharacteristic(
      BluetoothDevice device) async {
    if (device.connectionState != BluetoothConnectionState.connected) {
      await _connectToDevice(device);
    }

    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      if (service.uuid.toString().toLowerCase() ==
          "12345678-1234-5678-1234-56789abcdef0") {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString().toLowerCase() ==
                  "abcd1234-5678-1234-5678-abcdef123456" &&
              characteristic.properties.write) {
            return characteristic;
          }
        }
      }
    }
    return null;
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false);
      await Future.delayed(
          const Duration(seconds: 2)); // Wartezeit für stabile Verbindung
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to connect to the device: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
