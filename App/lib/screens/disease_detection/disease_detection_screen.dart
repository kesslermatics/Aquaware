import 'dart:io';
import 'package:aquaware/services/animal_disease_service.dart';
import 'package:flutter/material.dart';
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

  final ImagePicker _picker = ImagePicker();

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null; // Clear error message if an image is selected
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
      final pickedFile = await _picker.pickImage(
          source: ImageSource.camera, maxWidth: 1024, maxHeight: 1024);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null; // Clear error message if an image is selected
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error capturing image: $e';
      });
    }
  }

  // Method to analyze the image using FishDiseaseService
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
          _errorMessage = 'No aquatic animal was found in this image';
        });
      }
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
              'Upload or capture an image of the aquatic animal to analyze its health.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Image preview area
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
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Icon(Icons.camera_alt,
                            size: 50, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 10),

            // Buttons for uploading and capturing image
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

            // Analyze button
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _analyzeImage,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Analyze'),
                  ),

            // Error message display
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
    );
  }
}
