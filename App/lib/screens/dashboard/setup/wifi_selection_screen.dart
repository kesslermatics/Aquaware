import 'package:aquaware/screens/dashboard/setup/create_kit_environment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:wifi_scan/wifi_scan.dart'; // WLAN-Scan Library
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class WifiSelectionScreen extends StatefulWidget {
  final BluetoothDevice device;

  const WifiSelectionScreen({super.key, required this.device});

  @override
  _WifiSelectionScreenState createState() => _WifiSelectionScreenState();
}

class _WifiSelectionScreenState extends State<WifiSelectionScreen> {
  List<WiFiAccessPoint> availableNetworks = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _scanWifiNetworks();
  }

  void _scanWifiNetworks() async {
    setState(() => isScanning = true);
    final wifiScan = WiFiScan.instance;

    final canGetScannedResults = await wifiScan.canGetScannedResults();
    if (canGetScannedResults == CanGetScannedResults.yes) {
      final accessPoints = await wifiScan.getScannedResults();
      setState(() => availableNetworks = accessPoints);
    }

    setState(() => isScanning = false);
  }

  Future<void> _enterWifiPassword(WiFiAccessPoint wifi) async {
    TextEditingController passwordController = TextEditingController();
    final loc = AppLocalizations.of(context)!;

    String? password = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(wifi.ssid),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: loc.password),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, passwordController.text),
              child: Text(loc.confirm),
            ),
          ],
        );
      },
    );

    if (password != null && password.isNotEmpty) {
      bool isConnected = await _connectToWifi(wifi.ssid, password);
      if (isConnected) {
        Get.offAll(() => CreateKitEnvironmentScreen(
              selectedDevice: widget.device,
              ssid: wifi.ssid,
              password: password,
            ));
      } else {
        Get.snackbar(
          loc.errorTitle,
          loc.genericErrorMessage, // Falls wifiConnectionFailed nicht existiert
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  /// Tries to connect to the selected WiFi network and checks if the connection was successful
  Future<bool> _connectToWifi(String ssid, String password) async {
    final info = NetworkInfo();
    final connectivity = Connectivity();

    // Simulate connecting to WiFi (actual connection requires platform-specific implementation)
    await Future.delayed(const Duration(seconds: 3));

    List<ConnectivityResult> results = await connectivity.checkConnectivity();
    String? currentSsid = await info.getWifiName();

    // Check if we are now connected to the selected WiFi
    return results.contains(ConnectivityResult.wifi) && currentSsid == ssid;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.selectWifi),
        automaticallyImplyLeading: false, // Entfernt den Zurück-Button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isScanning)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text(loc.searchingSensorKit),
                ],
              )
            else if (availableNetworks.isEmpty)
              Text(loc.noNetworksFound)
            else
              Expanded(
                child: ListView.builder(
                  itemCount: availableNetworks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(availableNetworks[index].ssid),
                        trailing: const Icon(Icons.wifi),
                        onTap: () =>
                            _enterWifiPassword(availableNetworks[index]),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _scanWifiNetworks,
              child: Text(loc.retryScan),
            ),
          ],
        ),
      ),
    );
  }
}
