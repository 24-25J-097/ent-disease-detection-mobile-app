import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ent_insight_app/models/models.dart';
import 'package:ent_insight_app/services/cholesteatoma_diagnosis_service.dart';
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
  String? _fileError;
  bool _isDisable = false;
  bool _isLoading = false;

  DiagnosisResult? _cholesteatomaResult;
  String? _diagnosisId;

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
          _fileError = null;
          _cholesteatomaResult = null;
        });
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

  Future<void> _diagnose() async {
    if (_isLoading || _isDisable) return;
    setState(() => _isLoading = true);

    if (_imageController.name.isEmpty || _imageController.name == '') {
      setState(() {
        _fileError = "Please choose the image file";
        _isLoading = false;
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
        Cholesteatoma? cholesteatomaData = await CholesteatomaDiagnosisService.cholesteatomaDiagnosis(formData);
        setState(() {
          _cholesteatomaResult = DiagnosisResult(
            isCholesteatoma: cholesteatomaData?.diagnosisResult?.isCholesteatoma,
            stage: cholesteatomaData?.diagnosisResult?.stage,
            suggestions: cholesteatomaData?.diagnosisResult?.suggestions,
            confidenceScore: cholesteatomaData?.diagnosisResult?.confidenceScore,
            prediction: cholesteatomaData?.diagnosisResult?.prediction,
          );
          _diagnosisId = cholesteatomaData?.id;
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
        //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DiagnosisReports()));
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
      _cholesteatomaResult = null;
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

      final responseMsg = await CholesteatomaDiagnosisService.cholesteatomaDiagnosisAccept(data);
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
        _cholesteatomaResult = null;
        _diagnosisId = null;
      });
    }
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
                      IgnorePointer(
                        ignoring: _cholesteatomaResult != null,
                        child: Form(
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
                                      color: _fileError == null ? Colors.lightBlue : Colors.red[900]!,
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
                              if (_fileError != null)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10, top: 3),
                                    child: Text(_fileError!,
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
                                child: _isLoading
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
                        _cholesteatomaResult != null
                            ? _cholesteatomaResult?.prediction == 'invalid'
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDiagnosisRow(
                                        'Invalid:',
                                        'An irrelevant image has been submitted.',
                                        Colors.red,
                                      ),
                                      const Text(
                                        'Please upload valid endoscopy image.',
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildDiagnosisRow(
                                        'Cholesteatoma Identified:',
                                        _cholesteatomaResult?.isCholesteatoma != null
                                            ? (_cholesteatomaResult?.isCholesteatoma == true ? 'Yes' : 'No')
                                            : 'Unknown', // Handle null case
                                        _cholesteatomaResult?.isCholesteatoma != null
                                            ? (_cholesteatomaResult?.isCholesteatoma == true ? Colors.red : Colors.green)
                                            : Colors.black, // Handle null case
                                      ),
                                      _buildDiagnosisRow(
                                        'Current Stage:',
                                        _cholesteatomaResult?.stage ?? 'N/A',
                                        Colors.black,
                                      ),
                                      _buildDiagnosisRow(
                                        'Suggestions:',
                                        _cholesteatomaResult?.suggestions ?? 'No suggestions available',
                                        Colors.black,
                                      ),
                                      _buildDiagnosisRow(
                                        'Confidence Score:',
                                        _cholesteatomaResult?.confidenceScore != null
                                            ? ((_cholesteatomaResult!.confidenceScore! * 100).floor() / 100).toStringAsFixed(2)
                                            : 'N/A',
                                        Colors.black,
                                      ),
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
}
