import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ent_insight_app/models/models.dart';
import 'package:ent_insight_app/services/sinusitis_analize_service.dart';
import 'package:ent_insight_app/utils/check_image_extension.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();
  late XFile _imageController = XFile('');
  String? _fileError;
  bool _isDisable = false;
  bool _isLoading = false;

  // final Map<String, dynamic>? analysisResult = {"class": "Mild"}; // Placeholder for the result
  SinusitisResult? _analysisResult;
  String? _diagnosisId;

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
          _fileError = null;
          _analysisResult = null;
        });
        // List<int>? fileBytes = result.files.first.bytes;
        // String fileName = result.files.first.name;
        //
        // // Upload file
        // if (fileBytes != null) {
        //   _imageController = result.files.first;
        //   setState(() {
        //     _fileError = null;
        //   });
        // } else {
        //   if (kDebugMode) {
        //     print("No file");
        //   }
        // }
      }
    } on PlatformException catch (e) {
      setState(() {
        _fileError = e.message;
      });
      if (kDebugMode) {
        print('Unsupported operation: $e');
      }
    } catch (e) {
      setState(() {
        _fileError = e.toString();
      });
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> analyze() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    if (_imageController.name.isEmpty || _imageController.name == '') {
      setState(() {
        _fileError = "Please choose the image file";
        _isLoading = false;
      });
    } else if (!isValidFileType(_imageController.name)) {
      setState(() {
        _fileError = "Unsupported file type! Please select a valid X-Ray image (JPEG, PNG, WebP).";
        _isLoading = false;
      });
      return; // Stop further execution
    } else {
      setState(() {
        _isLoading = false;
        _isDisable = false;
      });
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      EasyLoading.show(status: "Analyzing...");
      FormData formData = FormData.fromMap({
        "patientId": _patientIdController.text,
        "additionalInfo": _additionalInfoController.text,
        "watersViewXrayImage":
            await MultipartFile.fromFile(_imageController.path),
      });

      try {
        Sinusitis? analysisResult = await SinusitisAnalyzeService.analyzeXray(formData);
        // if (analysisResult?.prediction == SinusitisResultEnum.invalid) {
        //   setState(() {
        //     _fileError = "Please select a valid Water's view X Ray!";
        //   });
        // }
        setState(() {
          _analysisResult = SinusitisResult(
            isSinusitis: analysisResult?.diagnosisResult?.isSinusitis,
            severity: analysisResult?.diagnosisResult?.severity,
            suggestions: analysisResult?.diagnosisResult?.suggestions,
            confidenceScore: analysisResult?.diagnosisResult?.confidenceScore,
            prediction: analysisResult?.diagnosisResult?.prediction,
          );
          _diagnosisId = analysisResult?.id;
        });
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
        setState(() => _isLoading = false);
        // if (mounted) {
        //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyInquiryScreen()));
        // }
      }
    }
  }

  Future<void> _handleRest() async {
    await EasyLoading.dismiss();
    _formKey.currentState?.reset();
    _imageController = XFile('');
    _patientIdController.clear();
    _additionalInfoController.clear();
    setState(() {
      _isDisable = false;
      _isLoading = false;
      _fileError = null;
      _analysisResult = null;
      _diagnosisId = null;
    });
  }

  Future<void> _handleDone(bool accept) async {
    if (_isDisable || _isLoading) return;
    try {
      EasyLoading.show(status: "Submitting...");
      setState(() {
        _isDisable = true;
      });

      final data = {"diagnosisId": _diagnosisId, "accept": accept};

      final responseMsg =
          await SinusitisAnalyzeService.sinusitisDiagnosisAccept(data);
      if (responseMsg != null && mounted) {
        AppSnackBarWidget(
          context: context,
          bgColor: Colors.green,
        ).show(message: responseMsg);
      }
    } catch (error) {
      debugPrint(error.toString());
      if (mounted) {
        AppSnackBarWidget(
          context: context,
          bgColor: Colors.red,
        ).show(message: error.toString());
      }
    } finally {
      await EasyLoading.dismiss();
      _formKey.currentState?.reset();
      _imageController = XFile('');
      _patientIdController.clear();
      _additionalInfoController.clear();
      setState(() {
        _isDisable = false;
        _isLoading = false;
        _fileError = null;
        _analysisResult = null;
        _diagnosisId = null;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                    title: "Identify Sinusitis",
                  ),
                  const SizedBox(height: 20),
                  _imageController.name.isNotEmpty
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
                                print(
                                    ":::::::::::::::::::::::: FadeInImage imageErrorBuilder: ${error.toString()}");
                              }
                              return Image.asset(
                                  'assets/images/img-placeholder.jpg',
                                  fit: BoxFit.cover);
                            },
                          ),
                        )
                      : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage(
                                "assets/images/sinusitis.png",
                              ),
                              fit: BoxFit.fitWidth,
                            ),
                          )),
                  const SizedBox(height: 20),
                  // File Picker Section
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Water's View X-Ray:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueAccent,
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
                          onTap: () =>
                              chooseImagePickerSource(context, pickFiles),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0x1492dbff),
                              border: Border.all(
                                color: _fileError == null
                                    ? Colors.blueAccent
                                    : Colors.red,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Choose X-Ray",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blueAccent)),
                                Icon(Icons.upload_file,
                                    color: Colors.blueAccent),
                              ],
                            ),
                          ),
                        ),
                        if (_fileError != null)
                          Text(_fileError!,
                              style: const TextStyle(color: Colors.red)),
                        if (_imageController.name.isNotEmpty)
                          Text(_imageController.name,
                              overflow: TextOverflow.ellipsis, softWrap: true),
                        const SizedBox(height: 20),
                        MaterialButton(
                          onPressed: analyze,
                          minWidth: double.infinity,
                          height: 48,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: const Color(0xFF1C2A3A),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 16, // Adjust size as needed
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  'Analyze',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.inter(
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
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
                            'Analyzed Result',
                            style: TextStyle(
                              color: Colors.blue[500],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _analysisResult != null
                            ? _analysisResult?.prediction == 'invalid'
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDiagnosisRow(
                                        'Invalid:',
                                        'An irrelevant image has been submitted.',
                                        Colors.red,
                                      ),
                                      const Text(
                                        'Please upload valid waters view xray image.',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: _buildActionButton(
                                          'Reset',
                                          Colors.grey,
                                          () => _handleRest(),
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildDiagnosisRow(
                                        'Sinusitis Identified:',
                                        _analysisResult?.isSinusitis != null
                                            ? (_analysisResult?.isSinusitis ==
                                                    true
                                                ? 'Yes'
                                                : 'No')
                                            : 'Unknown', // Handle null case
                                        _analysisResult?.isSinusitis != null
                                            ? (_analysisResult?.isSinusitis ==
                                                    true
                                                ? Colors.red
                                                : Colors.green)
                                            : Colors.black, // Handle null case
                                      ),
                                      _buildDiagnosisRow(
                                        'Current Stage:',
                                        _analysisResult?.severity ?? 'N/A',
                                        Colors.black,
                                      ),
                                      _buildDiagnosisRow(
                                        'Suggestions:',
                                        _analysisResult?.suggestions ??
                                            'No suggestions available',
                                        Colors.black,
                                      ),
                                      _buildDiagnosisRow(
                                        'Confidence Score:',
                                        _analysisResult?.confidenceScore != null
                                            ? ((_analysisResult!.confidenceScore! *
                                                            100)
                                                        .floor() /
                                                    100)
                                                .toStringAsFixed(2)
                                            : 'N/A',
                                        Colors.black,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 14),
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
}

Widget _buildDiagnosisRow(String label, String value, Color valueColor) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
            ),
            textAlign: TextAlign.left,
            softWrap: true,
          ),
        ),
      ],
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
