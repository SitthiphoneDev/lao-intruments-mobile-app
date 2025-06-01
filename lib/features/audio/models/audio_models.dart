import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_models.freezed.dart';
part 'audio_models.g.dart';

@freezed
class PredictionResult with _$PredictionResult {
  const factory PredictionResult({
    required String instrument,
    required double confidence,
    @JsonKey(name: 'all_probabilities') required Map<String, double> allProbabilities,
  }) = _PredictionResult;

  factory PredictionResult.fromJson(Map<String, dynamic> json) =>
      _$PredictionResultFromJson(json);
}
