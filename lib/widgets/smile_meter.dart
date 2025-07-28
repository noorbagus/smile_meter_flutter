// lib/widgets/smile_meter.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class SmileMeter extends StatefulWidget {
  final double value; // 0.0 to 1.0
  final bool isActive;

  const SmileMeter({
    Key? key,
    required this.value,
    required this.isActive,
  }) : super(key: key);

  @override
  State<SmileMeter> createState() => _SmileMeterState();
}

class _SmileMeterState extends State<SmileMeter> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(SmileMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.value,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: 150,
          child: Column(
            children: [
              SizedBox(
                height: 100,
                width: 200,
                child: CustomPaint(
                  painter: MeterPainter(
                    value: _animation.value,
                    isActive: widget.isActive,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${(_animation.value * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.isActive ? Colors.blue : Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MeterPainter extends CustomPainter {
  final double value; // 0.0 to 1.0
  final bool isActive;

  MeterPainter({required this.value, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    // Draw gauge background
    final bgPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Draw filled gauge
    final fillPaint = Paint()
      ..color = _getColorForValue(value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      math.pi,
      math.pi * value,
      false,
      fillPaint,
    );

    // Draw needle
    final needlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final needleLength = radius - 15;
    final angle = math.pi + (math.pi * value);
    final needleEnd = Offset(
      center.dx + needleLength * math.cos(angle),
      center.dy + needleLength * math.sin(angle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw needle pivot
    final pivotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 5, pivotPaint);
  }

  Color _getColorForValue(double value) {
    if (value <= 0.6) {
      return Colors.red;
    } else if (value <= 0.8) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  bool shouldRepaint(MeterPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.isActive != isActive;
  }
}