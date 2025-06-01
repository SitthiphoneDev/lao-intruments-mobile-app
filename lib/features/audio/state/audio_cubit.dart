import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:lao_instruments/constants/enums.dart';
import 'package:lao_instruments/features/audio/data/audio_repositiory.dart';
import 'package:lao_instruments/features/audio/models/audio_models.dart';
import 'package:lao_instruments/features/audio/models/audio_recording.dart';
import 'package:lao_instruments/features/audio/models/model_info.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'audio_state.dart';
part 'audio_cubit.freezed.dart';

@injectable
class AudioCubit extends Cubit<AudioState> {
  final AudioRepository _repository;
  final AudioRecorder _recorder = AudioRecorder();

  Timer? _recordingTimer;
  Timer? _waveformTimer;
  StreamSubscription<Amplitude>? _amplitudeSubscription;

  AudioCubit({required AudioRepository repository})
    : _repository = repository,
      super(const AudioState());

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true));

    try {
      await _checkMicrophonePermission();
      // await _loadModelInfo();
      // await _loadSupportedInstruments();
    } catch (e) {
      emit(state.copyWith(errors: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _checkMicrophonePermission() async {
    final status = await Permission.microphone.request();
    emit(state.copyWith(hasPermission: status.isGranted));
  }

  Future<void> startRecording() async {
    if (!state.canRecord) return;
    try {
      emit(
        state.copyWith(
          recordingState: RecordingState.recording,
          recordingDuration: Duration.zero,
          waveformData: [],
          errors: null,
          currentSource: AudioSource.recording,
        ),
      );

      final directory = await getTemporaryDirectory();
      final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
      final filePath = '${directory.path}/$fileName';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 44100,
          bitRate: 128000,
        ),
        path: filePath,
      );

      _startRecordingTimer();
      _startWaveformMonitoring();
    } catch (e) {
      emit(
        state.copyWith(
          recordingState: RecordingState.idle,
          errors: 'Failed to start recording: $e',
        ),
      );
    }
  }

  void _startRecordingTimer() {
    _recordingTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      final newDuration = Duration(milliseconds: timer.tick * 100);

      if (newDuration >= state.maxRecordingDuration) {
        stopRecording();
        return;
      }

      emit(state.copyWith(recordingDuration: newDuration));
    });
  }

  void _startWaveformMonitoring() {
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 50), (
      timer,
    ) async {
      try {
        final amplitude = await _recorder.getAmplitude();
        final waveformValue =
            (amplitude.current + 80) / 80; // Normalize -80dB to 0dB to 0-1
        final clampedValue = waveformValue.clamp(0.0, 1.0);

        final currentWaveform = List<double>.from(state.waveformData);
        currentWaveform.add(clampedValue);

        // Keep only last 100 values for performance
        if (currentWaveform.length > 100) {
          currentWaveform.removeAt(0);
        }

        emit(state.copyWith(waveformData: currentWaveform));
      } catch (e) {
        // Ignore amplitude errorss during recording
      }
    });
  }

  Future<void> stopRecording() async {
    if (!state.isRecording) return;

    try {
      _recordingTimer?.cancel();
      _waveformTimer?.cancel();
      _amplitudeSubscription?.cancel();

      final path = await _recorder.stop();

      if (path != null) {
        final file = File(path);
        final fileSize = await file.length();

        final recording = AudioRecording(
          path: path,
          duration: state.recordingDuration,
          createdAt: DateTime.now(),
          fileName: path.split('/').last,
          fileSize: fileSize,
        );

        emit(
          state.copyWith(
            recordingState: RecordingState.completed,
            currentRecording: recording,
          ),
        );
      } else {
        emit(
          state.copyWith(
            recordingState: RecordingState.idle,
            errors: 'Failed to save recording',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          recordingState: RecordingState.idle,
          errors: 'Failed to stop recording: $e',
        ),
      );
    }
  }

  Future<void> pauseRecording() async {
    if (!state.isRecording) return;

    try {
      await _recorder.pause();
      _recordingTimer?.cancel();
      _waveformTimer?.cancel();

      emit(state.copyWith(recordingState: RecordingState.paused));
    } catch (e) {
      emit(state.copyWith(errors: 'Failed to pause recording: $e'));
    }
  }

  Future<void> resumeRecording() async {
    if (state.recordingState != RecordingState.paused) return;

    try {
      await _recorder.resume();
      emit(state.copyWith(recordingState: RecordingState.recording));

      _startRecordingTimer();
      _startWaveformMonitoring();
    } catch (e) {
      emit(state.copyWith(errors: 'Failed to resume recording: $e'));
    }
  }

  Future<void> selectAudioFile() async {
    try {
      emit(state.copyWith(isLoading: true, errors: null));

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final filePath = file.path;

        if (filePath != null) {
          final audioFile = File(filePath);
          final fileSize = await audioFile.length();

          // Check file size (limit to 50MB)
          if (fileSize > 50 * 1024 * 1024) {
            emit(
              state.copyWith(
                errors:
                    'File too large. Please select a file smaller than 50MB.',
                isLoading: false,
              ),
            );
            return;
          }

          final selectedFile = AudioRecording(
            path: filePath,
            duration: Duration.zero, // Duration will be determined by backend
            createdAt: DateTime.now(),
            fileName: file.name,
            fileSize: fileSize,
          );

          emit(
            state.copyWith(
              selectedFile: selectedFile,
              currentSource: AudioSource.file,
              currentRecording: null,
              recordingState: RecordingState.idle,
              isLoading: false,
            ),
          );
        }
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(
        state.copyWith(errors: 'Failed to select file: $e', isLoading: false),
      );
    }
  }

  Future<void> predictInstrument() async {
    final audioFile = _getCurrentAudioFile();
    if (audioFile == null) {
      emit(state.copyWith(errors: 'No audio file available for prediction'));
      return;
    }

    try {
      emit(state.copyWith(isUploading: true, errors: null));

      final result = await _repository.predictInstrument(audioFile);

      emit(state.copyWith(predictionResult: result, isUploading: false));
    } catch (e) {
      emit(state.copyWith(errors: 'Prediction failed: $e', isUploading: false));
    }
  }

  File? _getCurrentAudioFile() {
    final path =
        state.currentSource == AudioSource.recording
            ? state.currentRecording?.path
            : state.selectedFile?.path;

    return path != null ? File(path) : null;
  }

  void clearRecording() {
    _recordingTimer?.cancel();
    _waveformTimer?.cancel();
    _amplitudeSubscription?.cancel();

    emit(
      state.copyWith(
        recordingState: RecordingState.idle,
        recordingDuration: Duration.zero,
        waveformData: [],
        currentRecording: null,
        currentSource: null,
        errors: null,
      ),
    );
  }

  void clearSelectedFile() {
    emit(state.copyWith(selectedFile: null, currentSource: null, errors: null));
  }

  void clearPrediction() {
    emit(state.copyWith(predictionResult: null));
  }

  void clearErrors() {
    emit(state.copyWith(errors: null));
  }

  @override
  Future<void> close() {
    _recordingTimer?.cancel();
    _waveformTimer?.cancel();
    _amplitudeSubscription?.cancel();
    _recorder.dispose();
    return super.close();
  }
}
