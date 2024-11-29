// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'objects.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseObject _$ResponseObjectFromJson(Map<String, dynamic> json) =>
    ResponseObject(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$ResponseObjectToJson(ResponseObject instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

ResponseList _$ResponseListFromJson(Map<String, dynamic> json) => ResponseList(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] as List<dynamic>?,
      pagination: json['pagination'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ResponseListToJson(ResponseList instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'pagination': instance.pagination,
    };
