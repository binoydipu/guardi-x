import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'dart:async';

class ShakeDetector {
  final Function onShake;
  final double shakeThresholdGravity;
  final int shakeSlopTimeMS;
  final int shakeCountResetTime;

  DateTime _lastShakeTimestamp = DateTime.now();
  int _shakeCount = 0;
  StreamSubscription<AccelerometerEvent>? _subscription;
  Timer? _resetTimer;

  ShakeDetector({
    required this.onShake,
    this.shakeThresholdGravity = 2.7,
    this.shakeSlopTimeMS = 500,
    this.shakeCountResetTime = 3000,
  });

  void startListening() {
    _subscription?.cancel(); // Ensure previous stream is cancelled
    _subscription = SensorsPlatform.instance
        .accelerometerEventStream()
        .listen((AccelerometerEvent event) {
      _handleShakeEvent(event);
    });

    _resetTimer?.cancel();
    _resetTimer =
        Timer.periodic(Duration(milliseconds: shakeCountResetTime), (_) {
      _shakeCount = 0;
    });
  }

  void _handleShakeEvent(AccelerometerEvent event) {
    final double x = event.x;
    final double y = event.y;
    final double z = event.z;

    final double gX = x / 9.80665;
    final double gY = y / 9.80665;
    final double gZ = z / 9.80665;

    final double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);
    final DateTime now = DateTime.now();

    if (gForce > shakeThresholdGravity) {
      if (_lastShakeTimestamp
          .add(Duration(milliseconds: shakeSlopTimeMS))
          .isBefore(now)) {
        _shakeCount++;
        _lastShakeTimestamp = now;
        //print("Shake detected! Count: $_shakeCount");

        if (_shakeCount >= 2) {
          onShake();
          _shakeCount = 0; // Reset after shake event is triggered
        }
      }
    }
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _resetTimer?.cancel();
    _resetTimer = null;
  }
}
