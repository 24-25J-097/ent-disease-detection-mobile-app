part of 'models.dart';

@JsonSerializable(explicitToJson: true)
class Sinusitis {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'diagnosticianId')
  final String? diagnosticianId;

  @JsonKey(name: 'patientId')
  final String patientId;

  @JsonKey(name: 'additionalInformation')
  final String? additionalInformation;

  @JsonKey(name: 'watersViewXrayImage')
  final String watersViewXrayImage;

  @JsonKey(name: 'diagnosisResult')
  final SinusitisResult? diagnosisResult;

  @JsonKey(name: 'status')
  final SinusitisStatus? status;

  final bool? accepted;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  Sinusitis({
    this.id,
    this.diagnosticianId,
    required this.patientId,
    this.additionalInformation,
    required this.watersViewXrayImage,
    this.diagnosisResult,
    this.status,
    this.accepted,
    this.createdAt,
    this.updatedAt,
  });

  factory Sinusitis.fromJson(Map<String, dynamic> json) => _$SinusitisFromJson(json);

  Map<String, dynamic> toJson() => _$SinusitisToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SinusitisResult {

  final bool? isSinusitis;

  final String? severity;

  final String? suggestions;

  @JsonKey(name: 'confidenceScore')
  final double? confidenceScore;

  final String? prediction; // Can be "valid", "invalid", or "N/A"

  SinusitisResult({
    required this.severity,
    required this.isSinusitis,
    required this.suggestions,
    required this.prediction,
    required this.confidenceScore
  });

  /// Connect the generated [_$CityFromJson] function to the `fromJson` factory.
  factory SinusitisResult.fromJson(Map<String, dynamic> json) => _$SinusitisResultFromJson(json);

  /// Connect the generated [_$SinusitisResultToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SinusitisResultToJson(this);

}


enum SinusitisStatus {
  pending,
  diagnosed,
  failed,
}

extension SinusitisStatusExtension on SinusitisStatus {
  MaterialColor getStatusColor() {
    switch (this) {
      case SinusitisStatus.pending:
        return Colors.amber;
      case SinusitisStatus.diagnosed:
        return Colors.green;
      case SinusitisStatus.failed:
        return Colors.red;
      }
  }
}

