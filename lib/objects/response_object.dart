part of 'objects.dart';

@JsonSerializable(explicitToJson: true)
class ResponseObject {
  ResponseObject({this.success, this.message, this.data});

  final bool? success;
  final String? message;
  final dynamic data;

  factory ResponseObject.fromJson(Map<String, dynamic> json) => _$ResponseObjectFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseObjectToJson(this);
}
