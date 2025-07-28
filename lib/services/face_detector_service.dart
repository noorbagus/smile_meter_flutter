// lib/services/face_detector_service.dart
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../utils/image_converter.dart';

class FaceDetectorService extends ChangeNotifier {
  FaceDetector? _faceDetector;
  bool _isInitialized = false;

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

    _isInitialized = true;
    notifyListeners();
  }

  Future<double?> processImage(CameraImage cameraImage) async {
    if (!_isInitialized || _faceDetector == null) return null;

    final inputImage = ImageConverter.convertCameraImage(cameraImage, camera);
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

  InputImage? _convertCameraImageToInputImage(CameraImage cameraImage) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final imageSize = Size(
      cameraImage.width.toDouble(),
      cameraImage.height.toDouble(),
    );

    final imageRotation = InputImageRotation.rotation0deg;
    final inputImageFormat = InputImageFormat.nv21;

    final planeData = cameraImage.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: cameraImage.height,
          width: cameraImage.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    return InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );
  }

  @override
  void dispose() {
    _faceDetector?.close();
    super.dispose();
  }
}