import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/calorie_counter_service.dart';

class FoodCameraButton extends StatefulWidget {
  const FoodCameraButton({super.key});

  @override
  State<FoodCameraButton> createState() => _FoodCameraButtonState();
}

class _FoodCameraButtonState extends State<FoodCameraButton> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file =
          await _picker.pickImage(source: source, imageQuality: 80);
      if (file == null) {
        _showError('No image selected');
        return;
      }

      final imageFile = File(file.path);
      if (!imageFile.existsSync()) {
        _showError('Image file not found');
        return;
      }

      setState(() => _isAnalyzing = true);

      // For now use a stubbed analyzer. Replace this with a backend call
      // or Gemini Vision analysis to get actual nutrition data.
      final analysis = await _analyzeImageStub(imageFile);

      setState(() => _isAnalyzing = false);

      if (!mounted) return;

      // Show result dialog with Cancel / Add
      _showResultDialog(imageFile, analysis);
    } catch (e) {
      setState(() => _isAnalyzing = false);
      _showError('Error picking image: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showResultDialog(File imageFile, Map<String, dynamic> analysis) {
    final TextEditingController nameCtl =
        TextEditingController(text: analysis['name'] ?? 'Food');
    final TextEditingController caloriesCtl =
        TextEditingController(text: (analysis['calories'] ?? 0).toString());
    final TextEditingController proteinCtl =
        TextEditingController(text: (analysis['protein'] ?? 0).toString());
    final TextEditingController carbsCtl =
        TextEditingController(text: (analysis['carbs'] ?? 0).toString());
    final TextEditingController fatsCtl =
        TextEditingController(text: (analysis['fats'] ?? 0).toString());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Scanned Food Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(imageFile, height: 150, fit: BoxFit.cover),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtl,
                  decoration: const InputDecoration(
                    labelText: 'Food Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: caloriesCtl,
                  decoration: const InputDecoration(
                    labelText: 'Calories',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: proteinCtl,
                        decoration: const InputDecoration(
                          labelText: 'Protein (g)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: carbsCtl,
                        decoration: const InputDecoration(
                          labelText: 'Carbs (g)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: fatsCtl,
                  decoration: const InputDecoration(
                    labelText: 'Fats (g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameCtl.dispose();
                caloriesCtl.dispose();
                proteinCtl.dispose();
                carbsCtl.dispose();
                fatsCtl.dispose();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  final data = {
                    'name': nameCtl.text.trim(),
                    'calories': int.tryParse(caloriesCtl.text) ?? 0,
                    'protein': int.tryParse(proteinCtl.text) ?? 0,
                    'carbs': int.tryParse(carbsCtl.text) ?? 0,
                    'fats': int.tryParse(fatsCtl.text) ?? 0,
                  };

                  if (data['name'].isEmpty) {
                    _showError('Please enter a food name');
                    return;
                  }

                  CalorieCounterService().addScannedFood(data);

                  nameCtl.dispose();
                  caloriesCtl.dispose();
                  proteinCtl.dispose();
                  carbsCtl.dispose();
                  fatsCtl.dispose();

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Added ${data['name']} (${data['calories']} cal)'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  _showError('Error adding food: $e');
                }
              },
              child: const Text('Add to Calories'),
            ),
          ],
        );
      },
    );
  }

  // This stub returns fake nutrition data. Integrate a backend or
  // remote analyzer (Cloud Vision + food database) or Gemini Vision here.
  Future<Map<String, dynamic>> _analyzeImageStub(File image) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Return sample nutrition data
    return {
      'name': 'Sample Meal',
      'calories': 350,
      'protein': 20,
      'carbs': 40,
      'fats': 12,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      child: FloatingActionButton(
        heroTag: 'food_camera',
        onPressed: _isAnalyzing ? null : () => _showPickOptions(),
        backgroundColor: Colors.deepOrange,
        disabledElevation: 0,
        child: _isAnalyzing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.camera_alt),
      ),
    );
  }

  void _showPickOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
