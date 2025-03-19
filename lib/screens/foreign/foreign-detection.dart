import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/foreign_body_prediction.dart';
import '../../services/foreign_body_service.dart';
import '../../utils/image_utils.dart';
import '../../widgets/foreign/image_with_bounding_boxes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart'; 
import './patient_id_field.dart';

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
  bool _isPatientIdValid = false;
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
Future<void> _uploadImageAndData() async {
  if (_imageFile == null) return;

  setState(() {
    _isLoading = true;
  });

  try {
    final String imagePath = 'lateral/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef = _storage.ref().child(imagePath);
    await storageRef.putFile(_imageFile!);
    final String imageUrl = await storageRef.getDownloadURL();

    // Modified to match web app schema exactly
    await _firestore.collection('foreign').add({
      'patientId': _patientIdController.text,
      'note': _noteController.text,
      'imageUrl': imageUrl,
      'predictions': _predictions.map((pred) => {
        'class': pred.className,
        'confidence': pred.confidence,
        'x': pred.x,
        'y': pred.y,
        'width': pred.width,
        'height': pred.height,
      }).toList(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report uploaded successfully')),
    );
  } catch (error) {
    print('Error uploading data: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to upload report. Please try again.')),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        title: Text('Foreign Body Detection'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PatientIdField(
              controller: _patientIdController,
              onValidityChanged: (isValid) {
                setState(() {
                  _isPatientIdValid = isValid;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Clinical Notes',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            SizedBox(height: 20),
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
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text("Select and Analyze Image"),
            ),
            if (_validationMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _validationMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
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
            if (_imageFile != null && _predictions.isNotEmpty)
              ElevatedButton(
                onPressed: (_isLoading || !_isPatientIdValid) 
                    ? null 
                    : _uploadImageAndData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Save Report",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
          ],
        ),
      ),
    ),
  );
}
}
