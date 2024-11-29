part of 'objects.dart';

@JsonSerializable(explicitToJson: true)
class ResponseList {
  ResponseList({
    this.success,
    this.message,
    this.data,
    this.pagination,
  });

  final bool? success;
  final String? message;
  final List<dynamic>? data;
  final Map<String, dynamic>? pagination;

  factory ResponseList.fromJson(Map<String, dynamic> json) => _$ResponseListFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseListToJson(this);
}
