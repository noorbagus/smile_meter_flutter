// lib/services/face_detector_service.dart
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../utils/image_converter.dart';

class FaceDetectorService extends ChangeNotifier {
  FaceDetector? _faceDetector;
  bool _isInitialized = false;
  CameraDescription? _camera;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true, // For smile detection
        minFaceSize: 0.1,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );

    // Get camera for image conversion
    final cameras = await availableCameras();
    _camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _isInitialized = true;
    notifyListeners();
  }

  Future<double?> processImage(CameraImage cameraImage) async {
    if (!_isInitialized || _faceDetector == null || _camera == null) return null;

    final inputImage = ImageConverter.convertCameraImage(cameraImage, _camera!);
    if (inputImage == null) return null;

    try {
      final faces = await _faceDetector!.processImage(inputImage);
      
      if (faces.isEmpty) {
        return 0.0; // No face detected
      }

      // Use the first face detected (assuming single user)
      final face = faces.first;
      
      // ML Kit provides smilingProbability between 0.0 and 1.0
      final smileValue = face.smilingProbability ?? 0.0;
      
      return smileValue;
    } catch (e) {
      print('Error processing face detection: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _faceDetector?.close();
    super.dispose();
  }
}