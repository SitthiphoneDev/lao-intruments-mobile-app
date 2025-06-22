import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_models.freezed.dart';
part 'audio_models.g.dart';

@freezed
class PredictionResult with _$PredictionResult {
  const factory PredictionResult({
    required String instrument,
    required double confidence,
    required Map<String, double> probabilities,
    @JsonKey(name: 'confidence_category') required String confidenceCategory,
    @JsonKey(name: 'is_uncertain') required bool isUncertain,
    required double entropy,
    @JsonKey(name: 'prediction_std') required double predictionStd,
    @JsonKey(name: 'segments_used') required int segmentsUsed,
    @JsonKey(name: 'processing_time_ms') required double processingTimeMs,
  }) = _PredictionResult;

  factory PredictionResult.fromJson(Map<String, dynamic> json) =>
      _$PredictionResultFromJson(json);
}