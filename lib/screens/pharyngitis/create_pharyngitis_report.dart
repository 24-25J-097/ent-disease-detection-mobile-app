import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ent_insight_app/models/models.dart';
import 'package:ent_insight_app/services/Pharyngitis_analize_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../widgets/widgets.g.dart';

class CreatePharyngitisReport extends StatefulWidget {
  const CreatePharyngitisReport({super.key});

  @override
  State<CreatePharyngitisReport> createState() => _CreatePharyngitisReportState();
}

class _CreatePharyngitisReportState extends State<CreatePharyngitisReport> {
  late XFile _imageController = XFile('');
  String? fileError;
  bool isLoading = false;

  // final Map<String, dynamic>? analysisResult = {"class": "Mild"}; // Placeholder for the result
  PharyngitisResult? analysisResult;

  void pickFiles(ImageSource source) async {
    try {
      // FilePickerResult? result = await FilePicker.platform.pickFiles(
      //   type: FileType.custom,
      //   allowMultiple: false,
      //   allowCompression: true,
      //   onFileLoading: (FilePickerStatus status) => print(status),
      //   allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
      //   withData: true,
      // );
      final XFile? result = await ImagePicker().pickImage(
        imageQuality: 80,
        maxWidth: 1440,
        source: source,
      );
      if (result != null) {
        _imageController = result;
        setState(() {
          fileError = null;
          analysisResult = null;
        });
        // List<int>? fileBytes = result.files.first.bytes;
        // String fileName = result.files.first.name;
        //
        // // Upload file
        // if (fileBytes != null) {
        //   _imageController = result.files.first;
        //   setState(() {
        //     fileError = null;
        //   });
        // } else {
        //   if (kDebugMode) {
        //     print("No file");
        //   }
        // }
      }
    } on PlatformException catch (e) {
      setState(() {
        fileError = e.message;
      });
      if (kDebugMode) {
        print('Unsupported operation: $e');
      }
    } catch (e) {
      setState(() {
        fileError = e.toString();
      });
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> analyze() async {
    if (isLoading) return;

    setState(() => isLoading = true);
    if (_imageController.name.isEmpty || _imageController.name == '') {
      setState(() {
        fileError = "Please select a throat image!";
      });
    } else {
      EasyLoading.show(status: "Analyzing...");
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(_imageController.path),
      });

      try {
        analysisResult = await PharyngitisAnalyzeService.analyzeImage(formData);
        if (analysisResult?.prediction == PharyngitisResultEnum.invalid) {
          setState(() {
            fileError = "Please select a valid Throat Image!";
          });
        }
      } catch (e) {
        debugPrint(e.toString());
        if (mounted) {
          MotionToast.error(
            title: const Text("Error"),
            description: Text(e.toString()),
            position: MotionToastPosition.center,
            dismissable: true,
            toastDuration: const Duration(seconds: 30),
            width: MediaQuery.of(context).size.width - 100,
            animationType: AnimationType.fromLeft,
          ).show(context);
        }
      } finally {
        await EasyLoading.dismiss();
        setState(() => isLoading = false);
        // if (mounted) {
        //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyInquiryScreen()));
        // }
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageController = XFile('');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  const TopAppBar(
                    title: "Identify Pharyngitis",
                  ),
                  const SizedBox(height: 20),
                  analysisResult != null && _imageController.name.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            File(_imageController.path),
                            // width: MediaQuery.of(context).size.width - 40,
                            // height: 200,
                            width: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              if (kDebugMode) {
                                print(":::::::::::::::::::::::: FadeInImage imageErrorBuilder: ${error.toString()}");
                              }
                              return Image.asset('assets/images/img-placeholder.jpg', fit: BoxFit.cover);
                            },
                          ),
                        )
                      : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                                image: AssetImage(
                                  "assets/images/features/pharyngitis.jpg",
                                ),
                                fit: BoxFit.fitWidth),
                          )),
                  const SizedBox(height: 20),
                  // File Picker Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Acute sore throat:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => chooseImagePickerSource(context, pickFiles),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0x1492dbff),
                            border: Border.all(
                              color: fileError == null ? Colors.blueAccent : Colors.red,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Choose throat image", style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
                              Icon(Icons.upload_file, color: Colors.blueAccent),
                            ],
                          ),
                        ),
                      ),
                      if (fileError != null) Text(fileError!, style: const TextStyle(color: Colors.red)),
                      if (_imageController.name.isNotEmpty) Text(_imageController.name, overflow: TextOverflow.ellipsis, softWrap: true),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Result Button
                  Container(
                    margin: const EdgeInsets.only(left: 5, right: 5, bottom: 20),
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        // Placeholder logic to analyze the uploaded file and show result
                        if (_imageController.name.isNotEmpty) {
                          analyze();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please upload a valid throat image first!")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C2A3A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          isLoading
                              ? const SizedBox(
                                  width: 16, // Adjust size as needed
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Analyze',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.inter(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16, letterSpacing: 0, fontWeight: FontWeight.normal, height: 1.5),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 600, // Equivalent to max-w-lg
                      minHeight: 200, // Equivalent to min-h-[200px]
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Diagnosis Result',
                            style: TextStyle(
                              color: Colors.blue[500],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        analysisResult != null
                            ?/* analysisResult?.prediction == PharyngitisResultEnum.invalid
                                ? InformationRow(
                                    label: 'Invalid:',
                                    value: analysisResult!.suggestions,
                                    valueColor: Colors.black,
                                  )
                                : */Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InformationRow(
                                        label: 'Pharyngitis Identified:',
                                        value: analysisResult?.isDiseased != null ? (analysisResult?.isDiseased == true ? 'Yes' : 'No') : 'Unknown', // Handle null case
                                        valueColor: (analysisResult?.isDiseased == true ? Colors.red : Colors.green), // Handle null case
                                      ),
                                      InformationRow(
                                        label: 'Current Stage:',
                                        value: analysisResult?.label ?? 'N/A',
                                        valueColor: analysisResult!.getStatusColor(),
                                      ),
                                      InformationRow(
                                        label: 'Suggestions:',
                                        value: analysisResult?.suggestions ?? 'No suggestions available',
                                        valueColor: Colors.black,
                                      ),
                                      InformationRow(
                                        label: 'Confidence Score:',
                                        value: ((analysisResult!.confidenceScore * 100).floor() / 100).toStringAsFixed(2),
                                        valueColor: Colors.black,
                                      ),
                                    ],
                                  )
                            : Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'No diagnosis available',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
