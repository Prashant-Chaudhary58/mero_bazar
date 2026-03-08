import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SensorService {
  static void listenToShake(VoidCallback onShake) {
    double lastX = 0, lastY = 0, lastZ = 0;
    const double shakeThreshold = 15.0;

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      double deltaX = (event.x - lastX).abs();
      double deltaY = (event.y - lastY).abs();
      double deltaZ = (event.z - lastZ).abs();

      if ((deltaX > shakeThreshold && deltaY > shakeThreshold) ||
          (deltaX > shakeThreshold && deltaZ > shakeThreshold) ||
          (deltaY > shakeThreshold && deltaZ > shakeThreshold)) {
        onShake();
      }

      lastX = event.x;
      lastY = event.y;
      lastZ = event.z;
    });
  }
}
