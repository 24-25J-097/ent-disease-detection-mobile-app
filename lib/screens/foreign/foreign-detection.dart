import 'dart:convert';
import 'dart:io';
import 'package:ent_insight_app/configs/config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class CreateForeignBodiesReport extends StatefulWidget {
  const CreateForeignBodiesReport({super.key});

  @override
  CreateForeignBodiesReportState createState() =>
      CreateForeignBodiesReportState();
}

class CreateForeignBodiesReportState extends State<CreateForeignBodiesReport> {
  List<dynamic> _predictions = [];
  File? _imageFile;
  String _validationMessage = '';
  double imageWidth = 0;
  double imageHeight = 0;
  double displayWidth = 0;
  double displayHeight = 0;

  Future<void> _validateAndAnalyzeImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please pick an image to analyze.")));
      return;
    }

    try {
      String? mimeType = lookupMimeType(_imageFile!.path);
      mimeType = mimeType ?? 'image/jpeg';

      // Validation API request
      //'${GlobalData.baseUrl}/api/sinusitis/analyze'
      var validationUri = Uri.parse('${GlobalData.baseUrl}/api/foreign/run-inference/');
      var validationRequest = http.MultipartRequest('POST', validationUri);
      validationRequest.headers.addAll({
        "Content-Type": "multipart/form-data",
      });

      validationRequest.files.add(await http.MultipartFile.fromPath(
        'file',
        _imageFile!.path,
        contentType: MediaType.parse(mimeType),
      ));

      var validationResponse = await validationRequest.send();

      if (validationResponse.statusCode == 200) {
        final validationData =
        json.decode(await validationResponse.stream.bytesToString());
        final int? imageClass =
        validationData['images']?[0]?['results']?[0]?['class'];

        if (imageClass != 1) {
          setState(() {
            _validationMessage =
            "Invalid image. Please upload a valid X-ray image.";
          });
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Image validation failed.")));
        return;
      }

      // If validation passes, proceed to analysis
      //Uri.parse('${GlobalData.baseUrl}/api/foreign/run-inference/');
      var analysisUri = Uri.parse('${GlobalData.baseUrl}/api/foreign/foreign/detect');

      var analysisRequest = http.MultipartRequest('POST', analysisUri);
      analysisRequest.headers.addAll({
        "Content-Type": "multipart/form-data",
      });

      analysisRequest.files.add(await http.MultipartFile.fromPath(
        'image',
        _imageFile!.path,
        contentType: MediaType.parse(mimeType),
      ));

      var analysisResponse = await analysisRequest.send();

      if (analysisResponse.statusCode == 200) {
        final responseData =
        json.decode(await analysisResponse.stream.bytesToString());

        setState(() {
          _predictions = responseData['predictions'] ?? [];
          _validationMessage = ''; // Clear validation message if successful
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Image analysis failed.")));
      }
    } catch (error) {
      print("Error validating or analyzing image: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to validate or analyze the image. Please try again.")));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        // Clear the previous predictions before picking a new image
        _predictions = [];
        _imageFile = File(pickedFile.path);
      });

      // Get image dimensions for scaling bounding boxes
      final decodedImage = await decodeImageFromList(_imageFile!.readAsBytesSync());
      imageWidth = decodedImage.width.toDouble();
      imageHeight = decodedImage.height.toDouble();

      displayWidth = MediaQuery.of(context).size.width;
      displayHeight = MediaQuery.of(context).size.height;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Foreign Body Detection")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _validateAndAnalyzeImage,
                child: Text("Upload Image for Detection"),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Pick an Image"),
              ),
              if (_validationMessage.isNotEmpty)
                Text(
                  _validationMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              if (_imageFile != null)
                ImageWithBoundingBoxes(
                  imagePath: _imageFile!.path,
                  predictions: _predictions,
                  imageWidth: imageWidth,
                  imageHeight: imageHeight,
                  displayWidth: displayWidth,
                  displayHeight: displayHeight,
                ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<dynamic> predictions;
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
      final x1 = prediction['x'] - prediction['width'] / 2;
      final y1 = prediction['y'] - prediction['height'] / 2;
      final x2 = prediction['x'] + prediction['width'] / 2;
      final y2 = prediction['y'] + prediction['height'] / 2;

      // Scale the bounding box relative to the display size
      final scaleX1 = (x1 / imageWidth) * displayWidth;
      final scaleY1 = (y1 / imageHeight) * displayHeight;
      final scaleX2 = (x2 / imageWidth) * displayWidth;
      final scaleY2 = (y2 / imageHeight) * displayHeight;

      // Log the scaled bounding box coordinates
      print('Bounding Box: ($scaleX1, $scaleY1), ($scaleX2, $scaleY2)');

      paint.color = _getClassColor(prediction['class']);
      canvas.drawRect(
        Rect.fromLTWH(scaleX1, scaleY1, scaleX2 - scaleX1, scaleY2 - scaleY1),
        paint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${prediction['class']} ${(prediction['confidence'] * 100).toStringAsFixed(2)}%',
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

  // Helper method to get class color (you can modify colors based on your needs)
  Color _getClassColor(String className) {
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

class ImageWithBoundingBoxes extends StatelessWidget {
  final String imagePath;
  final List<dynamic> predictions;
  final double imageWidth;
  final double imageHeight;
  final double displayWidth;
  final double displayHeight;

  ImageWithBoundingBoxes({
    required this.imagePath,
    required this.predictions,
    required this.imageWidth,
    required this.imageHeight,
    required this.displayWidth,
    required this.displayHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.file(
          File(imagePath),
          width: displayWidth,
          height: displayHeight,
          fit: BoxFit.cover,
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
        // Display the coordinates of the bounding boxes on top of the image
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
                  'Class B Predictions: ${predictions.where((p) => p['class'] == 'B').length}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Class D Predictions: ${predictions.where((p) => p['class'] == 'D').length}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}