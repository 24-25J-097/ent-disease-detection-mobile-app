import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/foreign_body_prediction.dart';
import '../../widgets/foreign/image_with_bounding_boxes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './update_foreign_report.dart';
import 'package:pdf/pdf.dart';

import '../../services/pdf_service.dart';

class ForeignReportDetail extends StatefulWidget {
  final Map<String, dynamic> report;
  final List<ForeignBodyPrediction> predictions;

  const ForeignReportDetail({
    Key? key,
    required this.report,
    required this.predictions,
  }) : super(key: key);

  @override
  State<ForeignReportDetail> createState() => _ForeignReportDetailState();
}

class _ForeignReportDetailState extends State<ForeignReportDetail> {
  Future<Size> _getImageDimensions() async {
    final ImageProvider imageProvider = NetworkImage(widget.report['imageUrl']);
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
  void _showDeleteConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this report?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              await _deleteReport();
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to list
            },
          ),
        ],
      );
    },
  );
}



Future<void> _deleteReport() async {
  try {
    // Delete image from storage
    final storage = FirebaseStorage.instance;
    final ref = storage.refFromURL(widget.report['imageUrl']);
    await ref.delete();

    // Delete document from Firestore
    await FirebaseFirestore.instance
        .collection('foreign')
        .doc(widget.report['id'])
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report deleted successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting report: $e')),
    );
  }
}

void _navigateToUpdate(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UpdateForeignReport(
        report: widget.report,
        predictions: widget.predictions,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details'),
        actions: [
          IconButton(
  icon: Icon(Icons.picture_as_pdf),
  onPressed: () async {
    final imageSize = await _getImageDimensions();
    await PDFService.generateForeignBodyReport(
      report: widget.report,
      predictions: widget.predictions,
      imageSize: imageSize,
    );
  },
),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _navigateToUpdate(context),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _showDeleteConfirmation(context),
        ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patient ID: ${widget.report['patientId']}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Date: ${(widget.report['timestamp'] as Timestamp).toDate().toString().split('.')[0]}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Clinical Notes:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.report['note'] ?? 'No notes provided',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Detected Objects:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
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
                    imagePath: widget.report['imageUrl'],
                    predictions: widget.predictions,
                    imageWidth: imageSize.width,
                    imageHeight: imageSize.height,
                    displayWidth: screenWidth,
                    displayHeight: displayHeight,
                    isNetworkImage: true,
                  );
                },
              ),
              // SizedBox(height: 16),
              // Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           'Predictions:',
              //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //         ),
              //         SizedBox(height: 8),
              //         ...widget.predictions.map((pred) => Padding(
              //           padding: const EdgeInsets.only(bottom: 8.0),
              //           child: Text(
              //             '${pred.className}: ${(pred.confidence * 100).toStringAsFixed(1)}%',
              //             style: TextStyle(fontSize: 16),
              //           ),
              //         )).toList(),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}