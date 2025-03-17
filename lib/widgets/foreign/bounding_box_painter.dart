import 'package:flutter/material.dart';
import '../../models/foreign_body_prediction.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<ForeignBodyPrediction> predictions;
  final double imageWidth;
  final double imageHeight;
  final double displayWidth;
  final double displayHeight;

  BoundingBoxPainter({
    required this.predictions,
    required this.imageWidth,
    required this.imageHeight,
    required this.displayWidth,
    required this.displayHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var prediction in predictions) {
      final x1 = prediction.x - prediction.width / 2;
      final y1 = prediction.y - prediction.height / 2;
      final x2 = prediction.x + prediction.width / 2;
      final y2 = prediction.y + prediction.height / 2;

      // Scale the bounding box relative to the display size
      final scaleX1 = (x1 / imageWidth) * displayWidth;
      final scaleY1 = (y1 / imageHeight) * displayHeight;
      final scaleX2 = (x2 / imageWidth) * displayWidth;
      final scaleY2 = (y2 / imageHeight) * displayHeight;

      paint.color = prediction.classColor;
      canvas.drawRect(
        Rect.fromLTWH(scaleX1, scaleY1, scaleX2 - scaleX1, scaleY2 - scaleY1),
        paint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${prediction.className} ${(prediction.confidence * 100).toStringAsFixed(2)}%',
          style: TextStyle(color: paint.color, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(scaleX1, scaleY1 - 20));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}