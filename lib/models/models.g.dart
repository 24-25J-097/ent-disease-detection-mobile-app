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
