import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_info.freezed.dart';
part 'model_info.g.dart';

@freezed
class ModelInfo with _$ModelInfo {
  const factory ModelInfo({
    required String name,
    required String description,
    @JsonKey(name: 'supported_instruments')
    required List<String> supportedInstruments,
    required String status,
    @Default("1.0.0") String version,
    @JsonKey(name: 'feature_type') String? featureType,
    @JsonKey(name: 'segment_duration') int? segmentDuration,
    @JsonKey(name: 'sample_rate') int? sampleRate,
  }) = _ModelInfo;

  factory ModelInfo.fromJson(Map<String, dynamic> json) =>
      _$ModelInfoFromJson(json);
}
