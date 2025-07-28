// lib/services/camera_service.dart
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class CameraService extends ChangeNotifier {
  CameraController? _controller;
  CameraController? get controller => _controller;

  CameraDescription? _cameraDescription;
  CameraDescription? get cameraDescription => _cameraDescription;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  StreamController<CameraImage>? _imageStreamController;
  Stream<CameraImage>? _imageStream;
  Stream<CameraImage> get imageStream => _imageStream!;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraDescription = frontCamera;
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      _isInitialized = true;

      _imageStreamController = StreamController<CameraImage>();
      _imageStream = _imageStreamController!.stream.asBroadcastStream();

      _controller!.startImageStream((image) {
        if (_imageStreamController?.isClosed == false) {
          _imageStreamController?.add(image);
        }
      });

      notifyListeners();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _stopImageStream();
    _controller?.dispose();
    _imageStreamController?.close();
    super.dispose();
  }

  void _stopImageStream() {
    if (_controller != null && _controller!.value.isStreamingImages) {
      _controller!.stopImageStream();
    }
  }
}