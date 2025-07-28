// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/camera_service.dart';
import 'services/face_detector_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Pre-initialize services
  final cameraService = CameraService();
  final faceDetectorService = FaceDetectorService();
  
  await cameraService.initialize();
  await faceDetectorService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: cameraService),
        ChangeNotifierProvider.value(value: faceDetectorService),
      ],
      child: const SmileMeterApp(),
    ),
  );
}

class SmileMeterApp extends StatelessWidget {
  const SmileMeterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smile Meter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}