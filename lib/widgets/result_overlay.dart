// lib/widgets/result_overlay.dart
import 'package:flutter/material.dart';
import '../utils/qr_generator.dart';

class ResultOverlay extends StatelessWidget {
  final double smileScore;
  final String rewardCategory;
  final String? qrData;

  const ResultOverlay({
    Key? key,
    required this.smileScore,
    required this.rewardCategory,
    this.qrData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Your Result',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Smile Score: ${(smileScore * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  'Reward: ${_formatCategory(rewardCategory)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _getCategoryColor(rewardCategory),
                  ),
                ),
                const SizedBox(height: 20),
                if (qrData != null) ...[
                  const Text(
                    'Scan to Download Video:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: QrGenerator.generateQrCode(qrData!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatCategory(String category) {
    switch (category) {
      case 'small_prize':
        return 'Small Prize';
      case 'medium_prize':
        return 'Medium Prize';
      case 'top_prize':
        return 'Top Prize';
      default:
        return category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'small_prize':
        return Colors.red;
      case 'medium_prize':
        return Colors.orange;
      case 'top_prize':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}