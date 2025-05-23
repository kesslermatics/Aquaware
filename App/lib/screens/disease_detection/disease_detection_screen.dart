import 'dart:ui';
import 'dart:io';
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/services/animal_disease_service.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'disease_result_screen.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  _DiseaseDetectionScreenState createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  File? _selectedImage;
  String? _errorMessage;
  bool _isLoading = false;
  bool isLocked = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
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

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            AppLocalizations.of(context)!.errorPickingImage(e.toString());
      });
    }
  }

  Future<void> _captureImage() async {
    try {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.camera, maxWidth: 1024, maxHeight: 1024);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            AppLocalizations.of(context)!.errorCapturingImage(e.toString());
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.uploadOrCaptureImageFirst;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    Get.snackbar(
      AppLocalizations.of(context)!.analyzingImage,
      AppLocalizations.of(context)!.pleaseWait,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ColorProvider.n6,
      colorText: Colors.white,
    );

    try {
      final service = AnimalDiseaseService();
      final diagnosis = await service.diagnoseAnimalDisease(_selectedImage!);

      setState(() {
        _isLoading = false;
      });

      if (diagnosis.animalDetected) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiseaseResultScreen(animalDisease: diagnosis),
          ),
        );
      } else {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.noAnimalDetected;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            AppLocalizations.of(context)!.errorAnalyzingImage(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  loc.uploadOrCaptureImage,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt,
                                  size: 50, color: Colors.grey),
                              const SizedBox(height: 10),
                              Text(
                                loc.uploadImage,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(loc.or),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _captureImage,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(loc.captureImage),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _analyzeImage,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(loc.analyze),
                      ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
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
                          loc.lockedFeatureMessage,
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
