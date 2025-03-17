import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/foreign_body_prediction.dart';
import '../../services/foreign_body_service.dart';
import '../../utils/image_utils.dart';
import '../../widgets/foreign/image_with_bounding_boxes.dart';

class CreateForeignBodiesReport extends StatefulWidget {
  const CreateForeignBodiesReport({Key? key}) : super(key: key);

  @override
  CreateForeignBodiesReportState createState() =>
      CreateForeignBodiesReportState();
}

class CreateForeignBodiesReportState extends State<CreateForeignBodiesReport> {
  List<ForeignBodyPrediction> _predictions = [];
  File? _imageFile;
  String _validationMessage = '';
  double imageWidth = 0;
  double imageHeight = 0;
  double displayWidth = 0;
  double displayHeight = 0;
  bool _isLoading = false;

  Future<void> _validateAndAnalyzeImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please pick an image to analyze.")));
      return;
    }

    setState(() {
      _isLoading = true;
      _validationMessage = '';
    });

    try {
      // Validate the image
      bool isValid = await ForeignBodyService.validateImage(_imageFile!);

      if (!isValid) {
        setState(() {
          _validationMessage =
              "Invalid image. Please upload a valid X-ray image.";
          _isLoading = false;
        });
        return;
      }

      // If validation passes, proceed to analysis
      List<ForeignBodyPrediction> predictions = 
          await ForeignBodyService.analyzeImage(_imageFile!);

      setState(() {
        _predictions = predictions;
        _isLoading = false;
      });
    } catch (error) {
      print("Error validating or analyzing image: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to validate or analyze the image. Please try again.")));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      
      setState(() {
        _predictions = [];
        _imageFile = imageFile;
      });

      // Get image dimensions for scaling bounding boxes
      final imageSize = await ImageUtils.getImageDimensions(imageFile);
      final displaySize = ImageUtils.calculateDisplaySize(
        imageSize, 
        MediaQuery.of(context).size.width
      );
      
      setState(() {
        imageWidth = imageSize.width;
        imageHeight = imageSize.height;
        displayWidth = displaySize.width;
        displayHeight = displaySize.height;
      });
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
                onPressed: _isLoading
                    ? null
                    : () async {
                        await _pickImage();
                        if (_imageFile != null) {
                          await _validateAndAnalyzeImage();
                        }
                      },
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text("Select and Analyze Image"),
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