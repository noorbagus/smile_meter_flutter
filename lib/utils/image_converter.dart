// lib/utils/image_converter.dart
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ImageConverter {
  static InputImage? convertCameraImage(CameraImage image, CameraDescription camera) {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final imageRotation = _getInputImageRotation(camera.sensorOrientation);
      
      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: imageRotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    } catch (e) {
      print('Error converting camera image: $e');
      return null;
    }
  }

  static InputImageRotation _getInputImageRotation(int sensorOrientation) {
    switch (sensorOrientation) {
      case 0: return InputImageRotation.rotation0deg;
      case 90: return InputImageRotation.rotation90deg;
      case 180: return InputImageRotation.rotation180deg;
      case 270: return InputImageRotation.rotation270deg;
      default: return InputImageRotation.rotation0deg;
    }
  }
}