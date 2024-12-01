part of 'models.dart';

@JsonSerializable(explicitToJson: true)
class PharyngitisResult {
  final PharyngitisResultEnum prediction;

  @JsonKey(name: 'confidence_score')
  final num confidenceScore;

  PharyngitisResult({required this.prediction, required this.confidenceScore});

  /// Connect the generated [_$CityFromJson] function to the `fromJson` factory.
  factory PharyngitisResult.fromJson(Map<String, dynamic> json) => _$PharyngitisResultFromJson(json);

  /// Connect the generated [_$PharyngitisResultToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PharyngitisResultToJson(this);

  MaterialColor getStatusColor() {
    return PharyngitisStatusColors.getColor(prediction);
  }
}

enum PharyngitisResultEnum {
  valid,
  invalid,
  normal,
  moderate,
  tonsillitis,
}

class PharyngitisStatusColors {
  static const Map<PharyngitisResultEnum, MaterialColor> _colors = {
    PharyngitisResultEnum.valid: Colors.amber, // Light gray
    PharyngitisResultEnum.invalid: Colors.grey, // Yellow
    PharyngitisResultEnum.normal: Colors.blue, // Blue
    PharyngitisResultEnum.moderate: Colors.amber, // Green
    PharyngitisResultEnum.tonsillitis: Colors.red, // Red
  };

  static MaterialColor getColor(PharyngitisResultEnum status) {
    return _colors[status] ?? Colors.orange; // Default color is white
  }
}
