import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ent_insight_app/models/models.dart';
import 'package:ent_insight_app/services/sinusitis_analize_service.dart';
import 'package:ent_insight_app/widgets/widgets.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';

class SinusitisAnaliseForm extends StatefulWidget {
  const SinusitisAnaliseForm({super.key});

  @override
  State<SinusitisAnaliseForm> createState() => _SinusitisAnaliseFormState();
}

class _SinusitisAnaliseFormState extends State<SinusitisAnaliseForm> {
  late XFile _imageController = XFile('');
  String? fileError;
  bool isLoading = false;

  // final Map<String, dynamic>? analysisResult = {"class": "Mild"}; // Placeholder for the result
  SinusitisResult? analysisResult;

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
        fileError = "Please select a X Ray!";
      });
    } else {
      EasyLoading.show(status: "Analyzing...");
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(_imageController.path),
      });

      try {
        analysisResult = await SinusitisAnalyzeService.analyzeXray(formData);
        if (analysisResult?.prediction == SinusitisResultEnum.invalid) {
          setState(() {
            fileError = "Please select a valid Water's view X Ray!";
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
                    title: "Identify Sinusitis",
                  ),
                  const SizedBox(height: 20),
                  Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                            image: AssetImage(
                              "assets/images/sinusitis.png",
                            ),
                            fit: BoxFit.fitWidth),
                      )),
                  const SizedBox(height: 20),
                  // File Picker Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Water's View X-Ray:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: fileError == null ? Colors.black : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => chooseImagePickerSource(context, pickFiles),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0x1492dbff),
                            border: Border.all(
                              color: fileError == null ? Colors.blueAccent : Colors.red,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Choose X-Ray", style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
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
                            const SnackBar(content: Text("Please upload a valid X-Ray first!")),
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
                  if (analysisResult != null)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_imageController.name.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              File(_imageController.path),
                              width: 220,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                if (kDebugMode) {
                                  print(":::::::::::::::::::::::: FadeInImage imageErrorBuilder: ${error.toString()}");
                                }
                                return Image.asset('assets/images/img-placeholder.jpg', fit: BoxFit.cover);
                              },
                            ),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          analysisResult?.prediction == SinusitisResultEnum.invalid ? "Invalid Image" : "Sinusitis Severity: ${analysisResult?.prediction.name}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: analysisResult?.getStatusColor(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          analysisResult?.prediction == SinusitisResultEnum.invalid ? "The uploaded file is not a valid X-Ray." : "Analysis successfully completed.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
