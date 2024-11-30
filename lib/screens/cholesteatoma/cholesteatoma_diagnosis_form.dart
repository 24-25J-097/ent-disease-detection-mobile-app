import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ent_insight_app/models/models.dart';
import 'package:ent_insight_app/widgets/widgets.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';

class CholesteatomaDiagnosisForm extends StatefulWidget {
  const CholesteatomaDiagnosisForm({super.key});

  @override
  State<CholesteatomaDiagnosisForm> createState() => _CholesteatomaDiagnosisFormState();
}

class _CholesteatomaDiagnosisFormState extends State<CholesteatomaDiagnosisForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();
  late XFile _imageController = XFile('');
  String? fileError;
  String? patientIdError;
  String? patientIdErrMsg;
  bool isDisable = false;
  bool isLoading = false;

  Cholesteatoma? diagnosisResult;

  void pickFiles(ImageSource source) async {
    try {
      final XFile? result = await ImagePicker().pickImage(
        imageQuality: 80,
        maxWidth: 1440,
        source: source,
      );
      if (result != null) {
        _imageController = result;
        setState(() {
          fileError = null;
          diagnosisResult = null;
        });
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

  Future<void> _diagnose() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    if (_imageController.name.isEmpty || _imageController.name == '') {
      setState(() {
        fileError = "Please choose the image file";
        isLoading = false;
      });
    }

    if (_formKey.currentState!.validate() && _imageController.name.isNotEmpty) {
      _formKey.currentState?.save();
      EasyLoading.show(status: "Analyzing...");
      FormData formData = FormData.fromMap({
        "patientId": _patientIdController.text,
        "additionalInfo": _additionalInfoController.text,
        "endoscopyImage": await MultipartFile.fromFile(_imageController.path),
      });

      try {
        // var response = await CholesteatomaDiagnosisService.cholesteatomaDiagnosis(formData);
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
        //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DiagnosisReports()));
        // }
      }
    }
  }

  Future<void> _handleDone(bool accept) async {
    // try {
    //   setState(() {
    //     isDisable = true;
    //   });
    //
    //   final data = DiagnosisAcceptance(
    //     diagnosisId: diagnosisResult?['diagnosisId'] ?? '',
    //     accept: accept,
    //   );
    //
    //   final response = await DiagnosisService.cholesteatomaDiagnosisAccept(data);
    //
    //   if (response['success']) {
    //     notifySuccess(response['message']);
    //   }
    // } catch (error) {
    //   if (error.toString().contains('Failed to accept diagnosis')) {
    //     setState(() {
    //       error = 'An unexpected error occurred. Please try again.';
    //     });
    //   } else {
    //     setState(() {
    //       error = error.toString();
    //     });
    //     notifyError(error.toString());
    //   }
    // } finally {
    //   setState(() {
    //     isDisable = false;
    //     diagnosisResult = null;
    //     patientId = '';
    //     additionalInfo = '';
    //     file = null;
    //     imagePreview = '';
    //     formKey.currentState?.reset();
    //   });
    //
    //   // Assuming you're using a method to refresh or reload the page
    //   // For example:
    //   // Navigator.pushReplacement(
    //   //   context,
    //   //   MaterialPageRoute(builder: (context) => DiagnosisScreen()),
    //   // );
    // }
  }

  @override
  void dispose() {
    super.dispose();
    _imageController = XFile('');
    _patientIdController.dispose();
    _additionalInfoController.dispose();
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
                    title: "Identify Cholesteatoma",
                  ),
                  const SizedBox(height: 20),
                  _imageController.name.isNotEmpty
                      ? ClipRRect(
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
                        )
                      : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/cholesteatoma-2.png",
                              ),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  // File Picker Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Upload Middle Ear Endoscopy",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blueAccent,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _patientIdController,
                              validator: (patientId) {
                                if ((patientId == null || patientId.isEmpty)) {
                                  return "Please enter the Patient ID";
                                }
                                if (patientId.length < 5) {
                                  return "Patient ID must be at least 5 characters long";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Patient Id *",
                                hintText: "Enter your Patient Id",
                                suffixIcon: SizedBox(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _additionalInfoController,
                              decoration: const InputDecoration(
                                labelText: "Additional Information",
                                hintText: "Enter any additional details (optional)",
                                suffixIcon: SizedBox(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => chooseImagePickerSource(context, pickFiles),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0x1492dbff),
                                  border: Border.all(
                                    color: fileError == null ? Colors.lightBlue : Colors.red[900]!,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Choose Endoscopy",
                                      style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                                    ),
                                    Icon(Icons.upload_file, color: Colors.blueAccent),
                                  ],
                                ),
                              ),
                            ),
                            if (fileError != null)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, top: 3),
                                  child: Text(fileError!,
                                      style: TextStyle(
                                        color: Colors.red[900],
                                        fontSize: 12,
                                      )),
                                ),
                              ),
                            if (_imageController.name.isNotEmpty)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, top: 3),
                                  child: Text(
                                    _imageController.name,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            MaterialButton(
                              onPressed: _diagnose,
                              minWidth: double.infinity,
                              height: 48,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: const Color(0xFF1C2A3A),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 16, // Adjust size as needed
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Diagnose',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.inter(
                                        color: const Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: 16,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.normal,
                                        height: 1.5,
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                        diagnosisResult != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDiagnosisRow('Cholesteatoma Identified:', 'Yes', Colors.red),
                                  _buildDiagnosisRow('Current Stage:', 'Stage 1', Colors.black),
                                  _buildDiagnosisRow('Suggestions:', 'None', Colors.black),
                                  // _buildDiagnosisRow(
                                  //   'Cholesteatoma Identified:',
                                  //   diagnosisResult['isCholesteatoma'] ? 'Yes' : 'No',
                                  //   diagnosisResult['isCholesteatoma'] != null ? (diagnosisResult['isCholesteatoma'] ? Colors.red : Colors.green) : Colors.black,
                                  // ),
                                  // _buildDiagnosisRow('Current Stage:', diagnosisResult['stage'], Colors.black),
                                  // _buildDiagnosisRow('Suggestions:', diagnosisResult['suggestions'], Colors.black),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _buildActionButton(
                                        'Reject',
                                        Colors.red,
                                        () => _handleDone(false),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildActionButton(
                                        'Accept',
                                        Colors.green,
                                        () => _handleDone(true),
                                      ),
                                    ],
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
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiagnosisRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label  ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
