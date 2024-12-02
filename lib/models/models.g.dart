// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SinusitisResult _$SinusitisResultFromJson(Map<String, dynamic> json) =>
    SinusitisResult(
      prediction: $enumDecode(_$SinusitisResultEnumEnumMap, json['prediction']),
      confidenceScore: json['confidence_score'] as num,
    );

Map<String, dynamic> _$SinusitisResultToJson(SinusitisResult instance) =>
    <String, dynamic>{
      'prediction': _$SinusitisResultEnumEnumMap[instance.prediction]!,
      'confidence_score': instance.confidenceScore,
    };

const _$SinusitisResultEnumEnumMap = {
  SinusitisResultEnum.valid: 'valid',
  SinusitisResultEnum.invalid: 'invalid',
  SinusitisResultEnum.mild: 'mild',
  SinusitisResultEnum.moderate: 'moderate',
  SinusitisResultEnum.severe: 'severe',
};

PharyngitisResult _$PharyngitisResultFromJson(Map<String, dynamic> json) =>
    PharyngitisResult(
      prediction:
          $enumDecode(_$PharyngitisResultEnumEnumMap, json['prediction']),
      confidenceScore: json['confidence_score'] as num,
    );

Map<String, dynamic> _$PharyngitisResultToJson(PharyngitisResult instance) =>
    <String, dynamic>{
      'prediction': _$PharyngitisResultEnumEnumMap[instance.prediction]!,
      'confidence_score': instance.confidenceScore,
    };

const _$PharyngitisResultEnumEnumMap = {
  PharyngitisResultEnum.valid: 'valid',
  PharyngitisResultEnum.invalid: 'invalid',
  PharyngitisResultEnum.normal: 'normal',
  PharyngitisResultEnum.moderate: 'moderate',
  PharyngitisResultEnum.tonsillitis: 'tonsillitis',
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
