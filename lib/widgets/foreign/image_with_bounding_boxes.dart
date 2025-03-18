import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/foreign_body_prediction.dart';
import 'bounding_box_painter.dart';


class ImageWithBoundingBoxes extends StatelessWidget {
  final String imagePath;
  final List<ForeignBodyPrediction> predictions;
  final double imageWidth;
  final double imageHeight;
  final double displayWidth;
  final double displayHeight;
  final bool isNetworkImage;

  const ImageWithBoundingBoxes({
    Key? key,
    required this.imagePath,
    required this.predictions,
    required this.imageWidth,
    required this.imageHeight,
    required this.displayWidth,
    required this.displayHeight,
    this.isNetworkImage = false,  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: displayWidth,
      height: displayHeight,
      child: Stack(
        children: [
          isNetworkImage
              ? Image.network(
                  imagePath,
                  width: displayWidth,
                  height: displayHeight,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                )
              : Image.file(
                  File(imagePath),
                  width: displayWidth,
                  height: displayHeight,
                  fit: BoxFit.contain,
                ),
          CustomPaint(
            size: Size(displayWidth, displayHeight),
            painter: BoundingBoxPainter(
              predictions: predictions,
              imageWidth: imageWidth,
              imageHeight: imageHeight,
              displayWidth: displayWidth,
              displayHeight: displayHeight,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              color: Colors.white.withOpacity(0.7),
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Class B: ${predictions.where((p) => p.className == 'B').length}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Class D: ${predictions.where((p) => p.className == 'D').length}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}