part of 'models.dart';

@JsonSerializable(explicitToJson: true)
class Pharyngitis {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'diagnosticianId')
  final String? diagnosticianId;

  @JsonKey(name: 'patientId')
  final String patientId;

  @JsonKey(name: 'additionalInformation')
  final String? additionalInformation;

  @JsonKey(name: 'throatImage')
  final String throatImage;

  @JsonKey(name: 'diagnosisResult')
  final PharyngitisDiagnosisResult? diagnosisResult;

  @JsonKey(name: 'status')
  final PharyngitisStatus? status;

  final bool? accepted;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  Pharyngitis({
    this.id,
    this.diagnosticianId,
    required this.patientId,
    this.additionalInformation,
    required this.throatImage,
    this.diagnosisResult,
    this.status,
    this.accepted,
    this.createdAt,
    this.updatedAt,
  });

  factory Pharyngitis.fromJson(Map<String, dynamic> json) => _$PharyngitisFromJson(json);

  Map<String, dynamic> toJson() => _$PharyngitisToJson(this);
}

@JsonSerializable()
class PharyngitisDiagnosisResult {
  @JsonKey(name: 'isPharyngitis')
  final bool? isPharyngitis;

  final String? stage;

  final String? suggestions;

  @JsonKey(name: 'confidenceScore')
  final double? confidenceScore;

  final String? prediction; // Can be "valid", "invalid", or "N/A"

  PharyngitisDiagnosisResult({
    this.isPharyngitis,
    this.stage,
    this.suggestions,
    this.confidenceScore,
    this.prediction,
  });

  factory PharyngitisDiagnosisResult.fromJson(Map<String, dynamic> json) => _$PharyngitisDiagnosisResultFromJson(json);

  Map<String, dynamic> toJson() => _$PharyngitisDiagnosisResultToJson(this);
}

enum PharyngitisStatus {
  pending,
  diagnosed,
  failed,
}

extension PharyngitisStatusExtension on PharyngitisStatus {
  MaterialColor getStatusColor() {
    switch (this) {
      case PharyngitisStatus.pending:
        return Colors.amber;
      case PharyngitisStatus.diagnosed:
        return Colors.green;
      case PharyngitisStatus.failed:
        return Colors.red;
      }
  }
}
