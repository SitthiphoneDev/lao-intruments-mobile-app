
part of 'audio_cubit.dart';

enum AudioStatus {
  initial,
  recording,
  recorded,
  fileSelected, // ADD if not present
  loading,
  analyzing,
  success,
  failure,
}

@freezed
class AudioState with _$AudioState {
  const factory AudioState({
    @Default(AudioStatus.initial) AudioStatus status,
    String? errors, // or 'error' if you're using 'error'
    String? recordingPath,
    File? selectedFile,
    String? fileName,
    int? fileSize, 
    double? audioDuration, 
    PredictionResult? predictionResult,
    // ... keep all your existing fields
  }) = _AudioState;
}