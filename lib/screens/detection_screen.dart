// lib/screens/detection_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/camera_view.dart';
import '../widgets/smile_meter.dart';
import '../widgets/result_overlay.dart';
import '../services/camera_service.dart';
import '../services/face_detector_service.dart';
import '../utils/timer_controller.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({Key? key}) : super(key: key);

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  late TimerController _timerController;
  double _smileValue = 0.0;
  bool _isDetectionActive = true;
  bool _isDetectionComplete = false;

  @override
  void initState() {
    super.initState();
    _timerController = TimerController(
      duration: const Duration(seconds: 10),
      onComplete: _handleDetectionComplete,
    );
    _timerController.start();
    _initializeServices();
  }

  void _initializeServices() async {
    final cameraService = Provider.of<CameraService>(context, listen: false);
    final faceDetectorService = Provider.of<FaceDetectorService>(context, listen: false);
    
    await cameraService.initialize();
    await faceDetectorService.initialize();
    
    cameraService.imageStream.listen((image) {
      if (_isDetectionActive) {
        faceDetectorService.processImage(image).then((result) {
          if (result != null && mounted) {
            setState(() {
              _smileValue = result;
            });
          }
        });
      }
    });
  }

  String? _videoDownloadUrl;

  void _handleDetectionComplete() {
    setState(() {
      _isDetectionActive = false;
      _isDetectionComplete = true;
      _videoDownloadUrl = "https://example.com/videos/smile_${DateTime.now().millisecondsSinceEpoch}";
    });
    String rewardCategory = _getRewardCategory(_smileValue);
    print('Detection complete! Smile value: $_smileValue, Category: $rewardCategory');
  }

  String _getRewardCategory(double smileValue) {
    if (smileValue <= 0.60) return 'small_prize';
    if (smileValue <= 0.80) return 'medium_prize';
    return 'top_prize';
  }

  @override
  void dispose() {
    _timerController.dispose();
    final cameraService = Provider.of<CameraService>(context, listen: false);
    final faceDetectorService = Provider.of<FaceDetectorService>(context, listen: false);
    cameraService.dispose();
    faceDetectorService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smile Detection'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const CameraView(),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmileMeter(
                  value: _smileValue,
                  isActive: _isDetectionActive,
                ),
                const SizedBox(height: 20),
                if (!_isDetectionActive)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Back to Home'),
                  ),
              ],
            ),
          ),
          if (_isDetectionActive)
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Time: ${_timerController.remainingSeconds}s',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (_isDetectionComplete)
            Center(
              child: ResultOverlay(
                smileScore: _smileValue,
                rewardCategory: _getRewardCategory(_smileValue),
                qrData: _videoDownloadUrl,
              ),
            ),
        ],
      ),
    );
  }
}