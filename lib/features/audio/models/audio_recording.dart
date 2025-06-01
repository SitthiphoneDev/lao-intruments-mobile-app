import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_recording.freezed.dart';
part 'audio_recording.g.dart';

@freezed
class AudioRecording with _$AudioRecording {
  const factory AudioRecording({
    required String path,
    required Duration duration,
    required DateTime createdAt,
    String? fileName,
    int? fileSize,
  }) = _AudioRecording;

  factory AudioRecording.fromJson(Map<String, dynamic> json) =>
      _$AudioRecordingFromJson(json);
}
