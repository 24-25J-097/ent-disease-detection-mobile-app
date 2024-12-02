part of 'models.dart';

@JsonSerializable(explicitToJson: true)
class Cholesteatoma {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'diagnosticianId')
  final String? diagnosticianId;

  @JsonKey(name: 'patientId')
  final String patientId;

  @JsonKey(name: 'additionalInformation')
  final String? additionalInformation;

  @JsonKey(name: 'endoscopyImage')
  final String endoscopyImage;

  @JsonKey(name: 'diagnosisResult')
  final DiagnosisResult? diagnosisResult;

  @JsonKey(name: 'status')
  final CholesteatomaStatus? status;

  final bool? accepted;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  Cholesteatoma({
    this.id,
    this.diagnosticianId,
    required this.patientId,
    this.additionalInformation,
    required this.endoscopyImage,
    this.diagnosisResult,
    this.status,
    this.accepted,
    this.createdAt,
    this.updatedAt,
  });

  factory Cholesteatoma.fromJson(Map<String, dynamic> json) => _$CholesteatomaFromJson(json);

  Map<String, dynamic> toJson() => _$CholesteatomaToJson(this);
}

@JsonSerializable()
class DiagnosisResult {
  @JsonKey(name: 'isCholesteatoma')
  final bool? isCholesteatoma;

  final String? stage;

  final String? suggestions;

  @JsonKey(name: 'confidenceScore')
  final double? confidenceScore;

  final String? prediction; // Can be "valid", "invalid", or "N/A"

  DiagnosisResult({
    this.isCholesteatoma,
    this.stage,
    this.suggestions,
    this.confidenceScore,
    this.prediction,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) => _$DiagnosisResultFromJson(json);

  Map<String, dynamic> toJson() => _$DiagnosisResultToJson(this);
}

enum CholesteatomaStatus {
  pending,
  diagnosed,
  failed,
}

extension CholesteatomaStatusExtension on CholesteatomaStatus {
  MaterialColor getStatusColor() {
    switch (this) {
      case CholesteatomaStatus.pending:
        return Colors.amber;
      case CholesteatomaStatus.diagnosed:
        return Colors.green;
      case CholesteatomaStatus.failed:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
