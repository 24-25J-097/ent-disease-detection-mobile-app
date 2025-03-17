import 'package:flutter/material.dart';

class ForeignBodyPrediction {
  final String className;
  final double confidence;
  final double x;
  final double y;
  final double width;
  final double height;

  ForeignBodyPrediction({
    required this.className,
    required this.confidence,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory ForeignBodyPrediction.fromJson(Map<String, dynamic> json) {
    return ForeignBodyPrediction(
      className: json['class'] ?? '',
      confidence: json['confidence'] ?? 0.0,
      x: json['x'] ?? 0.0,
      y: json['y'] ?? 0.0,
      width: json['width'] ?? 0.0,
      height: json['height'] ?? 0.0,
    );
  }

  Color get classColor {
    switch (className) {
      case 'C3':
        return Colors.red;
      case 'C4':
        return Colors.yellow;
      case 'C5':
        return Colors.green;
      case 'C6':
        return Colors.purple;
      case 'C7':
        return Colors.pink;
      case 'B':
        return Colors.blue;
      case 'D':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }
}