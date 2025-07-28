// lib/utils/timer_controller.dart
import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerController {
  final Duration duration;
  final VoidCallback onComplete;
  
  Timer? _timer;
  late DateTime _endTime;
  
  int _remainingSeconds = 0;
  int get remainingSeconds => _remainingSeconds;
  
  bool _isActive = false;
  bool get isActive => _isActive;

  TimerController({
    required this.duration,
    required this.onComplete,
  });

  void start() {
    if (_isActive) return;
    
    _isActive = true;
    _endTime = DateTime.now().add(duration);
    _remainingSeconds = duration.inSeconds;
    
    // Update every 100ms for smoother countdown
    _timer = Timer.periodic(const Duration(milliseconds: 100), _onTick);
  }

  void _onTick(Timer timer) {
    final now = DateTime.now();
    
    if (now.isAfter(_endTime)) {
      _isActive = false;
      _remainingSeconds = 0;
      timer.cancel();
      onComplete();
    } else {
      final diff = _endTime.difference(now);
      _remainingSeconds = diff.inSeconds + 1; // +1 to avoid showing 0 too early
    }
  }

  void stop() {
    _timer?.cancel();
    _isActive = false;
  }

  void dispose() {
    _timer?.cancel();
    _isActive = false;
  }
}