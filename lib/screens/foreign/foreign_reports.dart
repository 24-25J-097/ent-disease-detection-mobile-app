import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/foreign_body_prediction.dart';
import 'foreign_report_detail.dart';

class ForeignReportsScreen extends StatefulWidget {
  const ForeignReportsScreen({Key? key}) : super(key: key);

  @override
  State<ForeignReportsScreen> createState() => _ForeignReportsScreenState();
}

class _ForeignReportsScreenState extends State<ForeignReportsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Foreign Body Reports'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Filter by Patient ID',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('foreign')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  // Filter the documents based on search query
                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final patientId = (data['patientId'] ?? '').toString().toLowerCase();
                    return _searchQuery.isEmpty ||
                        patientId.contains(_searchQuery.toLowerCase());
                  }).toList();

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Patient ID')),
                            DataColumn(label: Text('Clinical Notes')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: filteredDocs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            data['id'] = doc.id;
                            return DataRow(cells: [
                              DataCell(Text(data['patientId'] ?? 'N/A')),
                              DataCell(Text(data['note'] ?? 'N/A')),
                              DataCell(IconButton(
  icon: Icon(Icons.remove_red_eye),
  onPressed: () {
    // Convert Firestore data to ForeignBodyPrediction objects
    final predictions = (data['predictions'] as List).map((pred) {
      return ForeignBodyPrediction(
        className: pred['class'],           // Changed from 'label'
        confidence: pred['confidence'],
        x: pred['x'],                       // Changed from 'boundingBox'['x']
        y: pred['y'],                       // Changed from 'boundingBox'['y']
        width: pred['width'],               // Changed from 'boundingBox'['width']
        height: pred['height'],             // Changed from 'boundingBox'['height']
      );
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForeignReportDetail(
          report: data,
          predictions: predictions,
        ),
      ),
    );
  },
)),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}