// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sinusitis _$SinusitisFromJson(Map<String, dynamic> json) => Sinusitis(
      id: json['_id'] as String?,
      diagnosticianId: json['diagnosticianId'] as String?,
      patientId: json['patientId'] as String,
      additionalInformation: json['additionalInformation'] as String?,
      watersViewXrayImage: json['watersViewXrayImage'] as String,
      diagnosisResult: json['diagnosisResult'] == null
          ? null
          : SinusitisResult.fromJson(
              json['diagnosisResult'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$SinusitisStatusEnumMap, json['status']),
      accepted: json['accepted'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SinusitisToJson(Sinusitis instance) => <String, dynamic>{
      '_id': instance.id,
      'diagnosticianId': instance.diagnosticianId,
      'patientId': instance.patientId,
      'additionalInformation': instance.additionalInformation,
      'watersViewXrayImage': instance.watersViewXrayImage,
      'diagnosisResult': instance.diagnosisResult?.toJson(),
      'status': _$SinusitisStatusEnumMap[instance.status],
      'accepted': instance.accepted,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$SinusitisStatusEnumMap = {
  SinusitisStatus.pending: 'pending',
  SinusitisStatus.diagnosed: 'diagnosed',
  SinusitisStatus.failed: 'failed',
};

SinusitisResult _$SinusitisResultFromJson(Map<String, dynamic> json) =>
    SinusitisResult(
      severity: json['severity'] as String?,
      isSinusitis: json['isSinusitis'] as bool?,
      suggestions: json['suggestions'] as String?,
      prediction: json['prediction'] as String?,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SinusitisResultToJson(SinusitisResult instance) =>
    <String, dynamic>{
      'isSinusitis': instance.isSinusitis,
      'severity': instance.severity,
      'suggestions': instance.suggestions,
      'confidenceScore': instance.confidenceScore,
      'prediction': instance.prediction,
    };

Pharyngitis _$PharyngitisFromJson(Map<String, dynamic> json) => Pharyngitis(
      id: json['_id'] as String?,
      diagnosticianId: json['diagnosticianId'] as String?,
      patientId: json['patientId'] as String,
      additionalInformation: json['additionalInformation'] as String?,
      throatImage: json['throatImage'] as String,
      diagnosisResult: json['diagnosisResult'] == null
          ? null
          : PharyngitisDiagnosisResult.fromJson(
              json['diagnosisResult'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$PharyngitisStatusEnumMap, json['status']),
      accepted: json['accepted'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PharyngitisToJson(Pharyngitis instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'diagnosticianId': instance.diagnosticianId,
      'patientId': instance.patientId,
      'additionalInformation': instance.additionalInformation,
      'throatImage': instance.throatImage,
      'diagnosisResult': instance.diagnosisResult?.toJson(),
      'status': _$PharyngitisStatusEnumMap[instance.status],
      'accepted': instance.accepted,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$PharyngitisStatusEnumMap = {
  PharyngitisStatus.pending: 'pending',
  PharyngitisStatus.diagnosed: 'diagnosed',
  PharyngitisStatus.failed: 'failed',
};

PharyngitisDiagnosisResult _$PharyngitisDiagnosisResultFromJson(
        Map<String, dynamic> json) =>
    PharyngitisDiagnosisResult(
      isPharyngitis: json['isPharyngitis'] as bool?,
      stage: json['stage'] as String?,
      suggestions: json['suggestions'] as String?,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      prediction: json['prediction'] as String?,
    );

Map<String, dynamic> _$PharyngitisDiagnosisResultToJson(
        PharyngitisDiagnosisResult instance) =>
    <String, dynamic>{
      'isPharyngitis': instance.isPharyngitis,
      'stage': instance.stage,
      'suggestions': instance.suggestions,
      'confidenceScore': instance.confidenceScore,
      'prediction': instance.prediction,
    };

Cholesteatoma _$CholesteatomaFromJson(Map<String, dynamic> json) =>
    Cholesteatoma(
      id: json['_id'] as String?,
      diagnosticianId: json['diagnosticianId'] as String?,
      patientId: json['patientId'] as String,
      additionalInformation: json['additionalInformation'] as String?,
      endoscopyImage: json['endoscopyImage'] as String,
      diagnosisResult: json['diagnosisResult'] == null
          ? null
          : DiagnosisResult.fromJson(
              json['diagnosisResult'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$CholesteatomaStatusEnumMap, json['status']),
      accepted: json['accepted'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CholesteatomaToJson(Cholesteatoma instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'diagnosticianId': instance.diagnosticianId,
      'patientId': instance.patientId,
      'additionalInformation': instance.additionalInformation,
      'endoscopyImage': instance.endoscopyImage,
      'diagnosisResult': instance.diagnosisResult?.toJson(),
      'status': _$CholesteatomaStatusEnumMap[instance.status],
      'accepted': instance.accepted,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$CholesteatomaStatusEnumMap = {
  CholesteatomaStatus.pending: 'pending',
  CholesteatomaStatus.diagnosed: 'diagnosed',
  CholesteatomaStatus.failed: 'failed',
};

DiagnosisResult _$DiagnosisResultFromJson(Map<String, dynamic> json) =>
    DiagnosisResult(
      isCholesteatoma: json['isCholesteatoma'] as bool?,
      stage: json['stage'] as String?,
      suggestions: json['suggestions'] as String?,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      prediction: json['prediction'] as String?,
    );

Map<String, dynamic> _$DiagnosisResultToJson(DiagnosisResult instance) =>
    <String, dynamic>{
      'isCholesteatoma': instance.isCholesteatoma,
      'stage': instance.stage,
      'suggestions': instance.suggestions,
      'confidenceScore': instance.confidenceScore,
      'prediction': instance.prediction,
    };
