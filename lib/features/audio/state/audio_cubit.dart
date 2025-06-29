import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lao_instruments/features/audio/data/audio_repositiory.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

import '../models/audio_models.dart';

part 'audio_state.dart';
part 'audio_cubit.freezed.dart';

@injectable
class AudioCubit extends Cubit<AudioState> {
  final AudioRepository _repository;
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioCubit(this._repository) : super(const AudioState());

  // ບັນທຶກສຽງ
  Future<void> startRecording() async {
    try {
      emit(state.copyWith(status: AudioStatus.recording, errors: null));

      // ກວດສອບການອະນຸຍາດ
      final permission = await Permission.microphone.request();
      if (!permission.isGranted) {
        emit(state.copyWith(
          status: AudioStatus.failure,
          errors: 'ຕ້ອງການການອະນຸຍາດໃຊ້ໄມໂຄຣໂຟນ',
        ));
        return;
      }

      // ສ້າງ path ສຳລັບບັນທຶກ
      final directory = await getTemporaryDirectory();
      final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.wav';
      final filePath = '${directory.path}/$fileName';

      // ເລີ່ມບັນທຶກ
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 44100,
          bitRate: 128000,
        ),
        path: filePath,
      );

      emit(state.copyWith(
        status: AudioStatus.recording,
        recordingPath: filePath,
      ));

      // ຢຸດອັດຕະໂນມັດຫຼັງ 8 ວິນາທີ
      await Future.delayed(const Duration(seconds: 8));
      await stopRecording();

    } catch (e) {
      emit(state.copyWith(
        status: AudioStatus.failure,
        errors: 'ເກີດຂໍ້ຜິດພາດໃນການບັນທຶກ: ${e.toString()}',
      ));
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _recorder.stop();
      if (path != null) {
        emit(state.copyWith(
          status: AudioStatus.recorded,
          recordingPath: path,
        ));
        
        // ວິເຄາະອັດຕະໂນມັດ
        await _predictFromFiles(File(path));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AudioStatus.failure,
        errors: 'ເກີດຂໍ້ຜິດພາດໃນການຢຸດບັນທຶກ: ${e.toString()}',
      ));
    }
  }

  // ເລືອກໄຟລ໌ຈາກໂທລະສັບ
  Future<void> pickAudioFile() async {
    try {
      emit(state.copyWith(status: AudioStatus.loading, errors: null));

      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowedExtensions: ['wav', 'mp3', 'ogg', 'm4a', 'flac'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final fileSize = result.files.single.size;

        emit(state.copyWith(
          status: AudioStatus.fileSelected,
          selectedFile: file,
          fileName: fileName,
          fileSize: fileSize,
        ));

        // ວິເຄາະໄຟລ໌
        await _predictFromFiles(file);
      } else {
        emit(state.copyWith(status: AudioStatus.initial));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AudioStatus.failure,
        errors: 'ເກີດຂໍ້ຜິດພາດໃນການເລືອກໄຟລ໌: ${e.toString()}',
      ));
    }
  }

  // ວິເຄາະໄຟລ໌ສຽງ
  // Future<void> _predictFromFiles(File file) async {
  //   try {
  //     emit(state.copyWith(status: AudioStatus.analyzing));

  //     final result = await _repository.predictInstrument(file);

  //     emit(state.copyWith(
  //       status: AudioStatus.success,
  //       predictionResult: result,
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(
  //       status: AudioStatus.failure,
  //       errors: 'ການວິເຄາະລົ້ມເຫຼວ: ${e.toString()}',
  //     ));
  //   }
  // }

  // ວິເຄາະໄຟລ໌ທີ່ເລືອກແລ້ວ
  Future<void> analyzeSelectedFile() async {
    if (state.selectedFile != null) {
      await _predictFromFiles(state.selectedFile!);
    }
  }

  // ຣີເຊັດ state
  void reset() {
    emit(const AudioState());
  }

  // ກວດສອບການອະນຸຍາດ
  Future<bool> checkPermissions() async {
    final permission = await Permission.microphone.status;
    return permission.isGranted;
  }

  @override
  Future<void> close() {
    _recorder.dispose();
    return super.close();
  }
    Future<void> pickAudioFileWithValidation(File file, String fileName, int fileSize) async {
    try {
      emit(state.copyWith(status: AudioStatus.loading, errors: null));

      // Check audio duration using just_audio
      await _audioPlayer.setFilePath(file.path);
      final duration = _audioPlayer.duration;
      final durationSeconds = duration?.inMilliseconds != null 
          ? duration!.inMilliseconds / 1000.0 
          : 0.0;

      emit(state.copyWith(
        status: AudioStatus.fileSelected,
        selectedFile: file,
        fileName: fileName,
        fileSize: fileSize,
        audioDuration: durationSeconds, // You'll need to add this to your state
      ));

      // Auto-analyze the file
      await _predictFromFiles(file);

    } catch (e) {
      emit(state.copyWith(
        status: AudioStatus.failure,
        errors: 'ເກີດຂໍ້ຜິດພາດໃນການວິເຄາະໄຟລ໌: ${e.toString()}',
      ));
    }
  }

  // Enhanced file picker for WAV/MP3 only
  Future<void> pickAudioFileEnhanced() async {
    try {
      emit(state.copyWith(status: AudioStatus.loading, errors: null));

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['wav', 'mp3'], // Only WAV and MP3
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final fileSize = result.files.single.size;

        // Check file size (10MB max)
        if (fileSize > 10 * 1024 * 1024) {
          emit(state.copyWith(
            status: AudioStatus.failure,
            errors: 'ໄຟລ໌ໃຫຍ່ເກີນໄປ (ສູງສຸດ 10MB)',
          ));
          return;
        }

        await pickAudioFileWithValidation(file, fileName, fileSize);
      } else {
        emit(state.copyWith(status: AudioStatus.initial));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AudioStatus.failure,
        errors: 'ເກີດຂໍ້ຜິດພາດໃນການເລືອກໄຟລ໌: ${e.toString()}',
      ));
    }
  }

  // Enhanced prediction with better errors handling
  Future<void> _predictFromFiles(File file) async {
    try {
      emit(state.copyWith(status: AudioStatus.analyzing));

      final result = await _repository.predictInstrument(file);

      emit(state.copyWith(
        status: AudioStatus.success,
        predictionResult: result,
      ));
    } catch (e) {
      String errorsMessage = 'ການວິເຄາະລົ້ມເຫຼວ';
      
      // More specific errors messages
      if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorsMessage = 'ບໍ່ສາມາດເຊື່ອມຕໍ່ກັບເຊີເວີໄດ້. ກະລຸນາກວດສອບການເຊື່ອມຕໍ່ອິນເຕີເນັດ';
      } else if (e.toString().contains('timeout')) {
        errorsMessage = 'ການວິເຄາະໃຊ້ເວລານານເກີນໄປ. ກະລຸນາລອງໃໝ່';
      } else if (e.toString().contains('file')) {
        errorsMessage = 'ໄຟລ໌ສຽງມີບັນຫາ. ກະລຸນາລອງໄຟລ໌ອື່ນ';
      }

      emit(state.copyWith(
        status: AudioStatus.failure,
        errors: errorsMessage,
      ));
    }
  }
}
