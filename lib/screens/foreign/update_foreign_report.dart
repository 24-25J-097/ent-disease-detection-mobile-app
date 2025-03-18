import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../models/foreign_body_prediction.dart';
import '../../services/foreign_body_service.dart';
import '../../widgets/foreign/image_with_bounding_boxes.dart';

class UpdateForeignReport extends StatefulWidget {
  final Map<String, dynamic> report;
  final List<ForeignBodyPrediction> predictions;

  const UpdateForeignReport({
    Key? key,
    required this.report,
    required this.predictions,
  }) : super(key: key);

  @override
  State<UpdateForeignReport> createState() => _UpdateForeignReportState();
}

class _UpdateForeignReportState extends State<UpdateForeignReport> {
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = false;
  File? _newImageFile;
  List<ForeignBodyPrediction> _newPredictions = [];
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _patientIdController.text = widget.report['patientId'];
    _noteController.text = widget.report['note'];
    _imageUrl = widget.report['imageUrl'];
    _newPredictions = widget.predictions;
  }
  Future<Size> _getImageDimensions() async {
    final ImageProvider imageProvider = _newImageFile != null 
        ? FileImage(_newImageFile!) 
        : NetworkImage(_imageUrl) as ImageProvider;
    final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
    final Completer<Size> completer = Completer<Size>();
    
    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      },
      onError: (dynamic exception, StackTrace? stackTrace) {
        completer.completeError(exception);
      },
    );

    stream.addListener(listener);
    return completer.future;
  }

 Future<void> _pickAndAnalyzeImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _newImageFile = File(pickedFile.path);
      _isLoading = true;
    });

    try {
      // Add validation step
      bool isValid = await ForeignBodyService.validateImage(_newImageFile!);
      
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select a valid lateral X-ray image")),
        );
        setState(() {
          _newImageFile = null;
          _isLoading = false;
        });
        return;
      }

      // Proceed with analysis if validation passes
      final predictions = await ForeignBodyService.analyzeImage(_newImageFile!);
      setState(() {
        _newPredictions = predictions;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error analyzing image: $e')),
      );
      setState(() {
        _newImageFile = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  Future<void> _updateReport() async {
    setState(() => _isLoading = true);

    try {
      String updatedImageUrl = _imageUrl;
      
      // If new image was selected, upload it
      if (_newImageFile != null) {
        // Delete old image
        final oldRef = FirebaseStorage.instance.refFromURL(_imageUrl);
        await oldRef.delete();

        // Upload new image
        final String imagePath = 'lateral/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storageRef = FirebaseStorage.instance.ref().child(imagePath);
        await storageRef.putFile(_newImageFile!);
        updatedImageUrl = await storageRef.getDownloadURL();
      }

      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('foreign')
          .doc(widget.report['id'])
          .update({
        'patientId': _patientIdController.text,
        'note': _noteController.text,
        'imageUrl': updatedImageUrl,
        'predictions': _newPredictions.map((pred) => {
          'class': pred.className,
          'confidence': pred.confidence,
          'x': pred.x,
          'y': pred.y,
          'width': pred.width,
          'height': pred.height,
        }).toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report updated successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating report: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _isLoading ? null : _updateReport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _patientIdController,
              decoration: InputDecoration(
                labelText: 'Patient ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Clinical Notes',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _pickAndAnalyzeImage,
              child: Text('Change Image'),
            ),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_newImageFile != null || _imageUrl.isNotEmpty)
              FutureBuilder<Size>(
                future: _getImageDimensions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error loading image: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return Text('No image data available');
                  }

                  final Size imageSize = snapshot.data!;
                  final double screenWidth = MediaQuery.of(context).size.width - 32;
                  final double displayHeight = 
                      (screenWidth * imageSize.height) / imageSize.width;

                  return ImageWithBoundingBoxes(
                    imagePath: _newImageFile?.path ?? _imageUrl,
                    predictions: _newPredictions,
                    imageWidth: imageSize.width,
                    imageHeight: imageSize.height,
                    displayWidth: screenWidth,
                    displayHeight: displayHeight,
                    isNetworkImage: _newImageFile == null,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}