import 'package:aquaware/models/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:aquaware/services/environment_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateKitEnvironmentScreen extends StatelessWidget {
  final BluetoothDevice selectedDevice;
  final String ssid;
  final String password;

  const CreateKitEnvironmentScreen({
    super.key,
    required this.selectedDevice,
    required this.ssid,
    required this.password,
  });

  Future<void> _createEnvironment(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    EnvironmentService service = EnvironmentService();

    String? apiKey = await getApiKeyFromStorage();
    if (apiKey == null) {
      Get.snackbar(loc.errorTitle, loc.apiKeyMissing,
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Environment environment = await service.createEnvironment(
        "My Aquarium", "", "aquarium", false, null);
    String environmentId = environment.id.toString();

    String bleData = "$ssid,$password,$apiKey,$environmentId";
    BluetoothCharacteristic? characteristic =
        await findWriteCharacteristic(selectedDevice);

    if (characteristic != null) {
      await characteristic.write(bleData.codeUnits);
      Get.snackbar(loc.successTitle, loc.deviceSetupComplete,
          backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar(loc.errorTitle, loc.bleWriteFailed,
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<String?> getApiKeyFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_key');
  }

  Future<BluetoothCharacteristic?> findWriteCharacteristic(
      BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          return characteristic;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Environment")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _createEnvironment(context),
          child: const Text("Finish Setup"),
        ),
      ),
    );
  }
}
