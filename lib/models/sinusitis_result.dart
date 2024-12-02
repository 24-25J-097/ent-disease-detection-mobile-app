part of 'models.dart';

@JsonSerializable(explicitToJson: true)
class SinusitisResult {
  final bool isSinusitis;

  final SinusitisResultEnum prediction;

  @JsonKey(name: 'confidence_score')
  final num confidenceScore;

  final String label;

  final String suggestions;

  SinusitisResult({required this.isSinusitis, required this.label, required this.suggestions, required this.prediction, required this.confidenceScore});

  /// Connect the generated [_$CityFromJson] function to the `fromJson` factory.
  factory SinusitisResult.fromJson(Map<String, dynamic> json) => _$SinusitisResultFromJson(json);

  /// Connect the generated [_$SinusitisResultToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SinusitisResultToJson(this);

  MaterialColor getStatusColor() {
    return StatusColors.getColor(prediction);
  }
}

enum SinusitisResultEnum {
  valid,
  invalid,
  mild,
  moderate,
  severe,
}

class StatusColors {
  static const Map<SinusitisResultEnum, MaterialColor> _colors = {
    SinusitisResultEnum.valid: Colors.amber, // Light gray
    SinusitisResultEnum.invalid: Colors.grey, // Yellow
    SinusitisResultEnum.mild: Colors.blue, // Blue
    SinusitisResultEnum.moderate: Colors.amber, // Green
    SinusitisResultEnum.severe: Colors.red, // Red
  };

  static MaterialColor getColor(SinusitisResultEnum status) {
    return _colors[status] ?? Colors.orange; // Default color is white
  }
}
