import 'dart:ui';
import 'dart:io';
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/screens/animal_detection/animal_result_screen.dart';
import 'package:aquaware/services/animal_detection_service.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AnimalDetectionScreen extends StatefulWidget {
  const AnimalDetectionScreen({super.key});

  @override
  _AnimalDetectionScreenState createState() => _AnimalDetectionScreenState();
}

class _AnimalDetectionScreenState extends State<AnimalDetectionScreen> {
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
        _errorMessage = 'Error picking image: $e';
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
        _errorMessage = 'Error capturing image: $e';
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      setState(() {
        _errorMessage = 'Please upload or capture an image first.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    Get.snackbar(
      "Analyzing Image",
      "Please wait while we analyze the image.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ColorProvider.n6,
      colorText: Colors.white,
    );

    try {
      final service = AnimalDetectionService();
      final detection = await service.detectFish(XFile(_selectedImage!.path));

      setState(() {
        _isLoading = false;
        if (detection.animalDetected) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AnimalResultScreen(animalResult: detection),
            ),
          );
        } else {
          _errorMessage = 'No aquatic animal was detected in the image.';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error analyzing image: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Upload or capture an image of the aquatic animal to identify its species.',
                  style: TextStyle(fontSize: 16),
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
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,
                                  size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text(
                                "Upload Image",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _captureImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Capture Image'),
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
                        child: const Text('Analyze'),
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
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock,
                          size: 60,
                          color: Colors.white,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'This feature is available only in the Advanced or Business Plan.',
                          style: TextStyle(
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
