// lib/models/detection_result.dart
class DetectionResult {
  final double smileValue;
  final String rewardCategory;
  final String? videoPath;
  final String? qrData;

  DetectionResult({
    required this.smileValue,
    required this.rewardCategory,
    this.videoPath,
    this.qrData,
  });

  factory DetectionResult.fromSmileValue(double smileValue) {
    String category;
    if (smileValue <= 0.60) {
      category = 'small_prize';
    } else if (smileValue <= 0.80) {
      category = 'medium_prize';
    } else {
      category = 'top_prize';
    }

    return DetectionResult(
      smileValue: smileValue,
      rewardCategory: category,
    );
  }
}