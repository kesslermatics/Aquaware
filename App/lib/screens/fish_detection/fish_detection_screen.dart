import 'dart:io';
import 'package:aquaware/services/fish_detection_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FishDetectionScreen extends StatefulWidget {
  const FishDetectionScreen({super.key});

  @override
  _FishDetectionScreenState createState() => _FishDetectionScreenState();
}

class _FishDetectionScreenState extends State<FishDetectionScreen> {
  File? _selectedImage;
  String? _errorMessage;
  bool _isLoading = false;
  String? _detectedFishSpecies; // Holds the detected fish species

  final ImagePicker _picker = ImagePicker();

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null;
          _detectedFishSpecies = null; // Reset detected species
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking image: $e';
      });
    }
  }

  // Method to capture image from camera
  Future<void> _captureImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null;
          _detectedFishSpecies = null; // Reset detected species
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error capturing image: $e';
      });
    }
  }

  // Method to analyze the image using FishDetectionService
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
      _detectedFishSpecies = null; // Clear detected species for new analysis
    });

    try {
      final service = FishDetectionService();
      final detection = await service.detectFish(XFile(_selectedImage!.path));

      setState(() {
        _isLoading = false;
        if (detection.fishDetected) {
          _detectedFishSpecies = detection.species; // Display detected species
        } else {
          _errorMessage = 'No fish was detected in the image.';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Upload or capture an image of the fish to identify its species.',
              style: TextStyle(fontSize: 16),
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
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : const Center(
                        child: Icon(Icons.camera_alt,
                            size: 50, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Image'),
                ),
                ElevatedButton.icon(
                  onPressed: _captureImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Capture Image'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
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
            if (_detectedFishSpecies != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Detected Fish Species: $_detectedFishSpecies',
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
