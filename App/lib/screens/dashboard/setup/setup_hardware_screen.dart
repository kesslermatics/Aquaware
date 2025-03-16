import 'package:aquaware/screens/dashboard/setup/wifi_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:confetti/confetti.dart'; // 🎊 Confetti-Effekt

class SetupHardwareScreen extends StatefulWidget {
  const SetupHardwareScreen({super.key});

  @override
  _SetupHardwareScreenState createState() => _SetupHardwareScreenState();
}

class _SetupHardwareScreenState extends State<SetupHardwareScreen> {
  BluetoothDevice? selectedDevice;
  bool isScanning = false;
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    _requestPermissions().then((_) => _startScan());
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  void _startScan() {
    setState(() {
      selectedDevice = null;
      isScanning = true;
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

    FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      for (var r in results) {
        if (r.device.name == "Aquaware BLE") {
          FlutterBluePlus.stopScan();
          _confettiController.play(); // 🎊 Confetti abspielen

          setState(() {
            selectedDevice = r.device;
            isScanning = false;
          });

          Get.snackbar(
            "🎉 ${AppLocalizations.of(context)!.successTitle}",
            AppLocalizations.of(context)!.deviceSelected,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          Future.delayed(const Duration(seconds: 2), () {
            Get.to(() => WifiSelectionScreen(device: selectedDevice!));
          });

          return;
        }
      }
    });

    Future.delayed(const Duration(seconds: 15), () {
      setState(() => isScanning = false);
      FlutterBluePlus.stopScan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.setupHardwareTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isScanning)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text(AppLocalizations.of(context)!.searchingSensorKit),
                ],
              ),
            if (!isScanning && selectedDevice == null)
              Text(AppLocalizations.of(context)!.noDevicesFound),
            ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive),
          ],
        ),
      ),
    );
  }
}
