part of 'audio_cubit.dart';

enum AudioStatus { initial, loading, success, failure }

@freezed
abstract class AudioState with _$AudioState {
  const factory AudioState({
    @Default(AudioStatus.initial) AudioStatus status,
    String? errors,
    @Default(RecordingState.idle) RecordingState recordingState,
    @Default(Duration.zero) Duration recordingDuration,
    @Default(Duration(seconds: 7)) Duration maxRecordingDuration,
    @Default([]) List<double> waveformData,
    AudioRecording? currentRecording,
    AudioRecording? selectedFile,
    AudioSource? currentSource,
    PredictionResult? predictionResult,
    ModelInfo? modelInfo,
    @Default([]) List<String> supportedInstruments,
    @Default(false) bool isLoading,
    @Default(false) bool isUploading,
    @Default(false) bool hasPermission,
  }) = _AudioState;
  
  const AudioState._();
  bool get isRecording => recordingState == RecordingState.recording;
  bool get canRecord => hasPermission && !isRecording && !isLoading;
  bool get hasAudioData => currentRecording != null || selectedFile != null;
  double get recordingProgress =>
      recordingDuration.inMilliseconds / maxRecordingDuration.inMilliseconds;
}
