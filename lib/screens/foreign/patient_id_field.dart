import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientIdField extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool) onValidityChanged;

  const PatientIdField({
    Key? key,
    required this.controller,
    required this.onValidityChanged,
  }) : super(key: key);

  @override
  State<PatientIdField> createState() => _PatientIdFieldState();
}

class _PatientIdFieldState extends State<PatientIdField> {
  String? _errorText;
  bool _isChecking = false;

  Future<bool> _checkIdUniqueness(String id) async {
    if (id.isEmpty) return false;

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('foreign')
        .where('patientId', isEqualTo: id)
        .get();

    return result.docs.isEmpty;
  }

  Future<void> _validateId(String value) async {
    if (value.isEmpty) {
      setState(() {
        _errorText = 'Patient ID is required';
        widget.onValidityChanged(false);
      });
      return;
    }

    setState(() {
      _isChecking = true;
      _errorText = null;
    });

    try {
      bool isUnique = await _checkIdUniqueness(value);
      setState(() {
        _isChecking = false;
        _errorText = isUnique ? null : 'This Patient ID already exists';
        widget.onValidityChanged(isUnique);
      });
    } catch (e) {
      setState(() {
        _isChecking = false;
        _errorText = 'Error checking Patient ID';
        widget.onValidityChanged(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: 'Patient ID',
        border: OutlineInputBorder(),
        filled: true,
        errorText: _errorText,
        suffixIcon: _isChecking
            ? SizedBox(
                width: 20,
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : null,
      ),
      onChanged: (value) => _validateId(value),
    );
  }
}