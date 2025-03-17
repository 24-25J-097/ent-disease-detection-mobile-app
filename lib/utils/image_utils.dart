import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class ImageUtils {
  static Future<Size> getImageDimensions(File imageFile) async {
    final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    return Size(
      decodedImage.width.toDouble(),
      decodedImage.height.toDouble(),
    );
  }

  static Size calculateDisplaySize(Size imageSize, double maxWidth) {
    double displayWidth = maxWidth;
    double displayHeight = (displayWidth * imageSize.height) / imageSize.width;
    return Size(displayWidth, displayHeight);
  }
}

// 4. widgets/bounding_box_painter.dart
