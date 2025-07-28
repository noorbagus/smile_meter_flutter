// lib/widgets/camera_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';

class CameraView extends StatelessWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraService = Provider.of<CameraService>(context);

    if (cameraService.controller == null || !cameraService.controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: cameraService.controller!.value.previewSize!.height,
          height: cameraService.controller!.value.previewSize!.width,
          child: CameraPreview(cameraService.controller!),
        ),
      ),
    );
  }
}