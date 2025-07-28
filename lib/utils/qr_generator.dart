// lib/utils/qr_generator.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerator {
  static Widget generateQrCode(String data, {double size = 200}) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      backgroundColor: Colors.white,
    );
  }

  static String generateDownloadUrl(String videoId) {
    // This would be replaced with your actual API URL in production
    return 'https://example.com/videos/$videoId';
  }
}