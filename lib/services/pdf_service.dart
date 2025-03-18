import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/foreign_body_prediction.dart';

class PDFService {
  static Future<void> generateForeignBodyReport({
    required Map<String, dynamic> report,
    required List<ForeignBodyPrediction> predictions,
    required Size imageSize,
  }) async {
    final pdf = pw.Document();

    // Load the network image
    final imageBytes = await NetworkAssetBundle(Uri.parse(report['imageUrl']))
        .load(report['imageUrl']);
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

    // Define page format (e.g., A4)
    final pageFormat = PdfPageFormat.a4;

    // Single page with the image
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat, // Set the page format
        margin: pw.EdgeInsets.all(1 * PdfPageFormat.cm),
        build: (context) {
          // Calculate the available space on the page
          final pageWidth = pageFormat.availableWidth;
          final pageHeight = pageFormat.availableHeight;

          // Define header and footer heights
          final headerHeight = 30.0;
          final footerHeight = 30.0;

          // Calculate image dimensions when scaled to fit the page
          final double imageRatio = imageSize.width / imageSize.height;
          final double pageRatio = pageWidth / (pageHeight - headerHeight - footerHeight);

          double imageWidth, imageHeight;
          double imageOffsetX = 0, imageOffsetY = headerHeight;

          if (imageRatio > pageRatio) {
            // Image is wider than page, constrain by width
            imageWidth = pageWidth;
            imageHeight = pageWidth / imageRatio;
          } else {
            // Image is taller than page, constrain by height
            imageHeight = pageHeight - headerHeight - footerHeight;
            imageWidth = imageHeight * imageRatio;
            imageOffsetX = (pageWidth - imageWidth) / 2; // Center horizontally
          }

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                height: headerHeight,
                padding: pw.EdgeInsets.only(bottom: 10),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Patient ID: ${report['patientId']}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Date: ${DateFormat('yyyy-MM-dd').format((report['timestamp'] as Timestamp).toDate())}'),
                  ],
                ),
              ),

              // Image
              pw.Container(
                width: pageWidth,
                height: pageHeight - headerHeight - footerHeight,
                child: pw.Center(
                  child: pw.Image(
                    image,
                    width: imageWidth,
                    height: imageHeight,
                  ),
                ),
              ),

              // Legend at bottom (optional, if you still want to show predictions)
              pw.Container(
                height: footerHeight,
                padding: const pw.EdgeInsets.only(top: 10),
                child: pw.Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: predictions.map((pred) => pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Container(
                        width: 10,
                        height: 10,
                        color: PdfColor.fromHex('#000000'), // Default color
                      ),
                      pw.SizedBox(width: 2),
                      pw.Text('${pred.className}: ${(pred.confidence * 100).toStringAsFixed(1)}%',
                          style: const pw.TextStyle(fontSize: 8)),
                    ],
                  )).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'foreign_body_report_${report['patientId']}.pdf',
    );
  }
}