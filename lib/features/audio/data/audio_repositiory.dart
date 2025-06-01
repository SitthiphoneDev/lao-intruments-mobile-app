import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lao_instruments/features/audio/data/audio_api_client.dart';
import '../models/audio_models.dart';

abstract class AudioRepository {
  Future<PredictionResult> predictInstrument(File audioFile);
}

@LazySingleton(as: AudioRepository)
class AudioRepositoryImpl implements AudioRepository {
  final AudioApiClient _apiClient;

  AudioRepositoryImpl(this._apiClient);

  @override
  Future<PredictionResult> predictInstrument(File audioFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split('/').last,
        ),
      });

      return await _apiClient.predictInstrument(formData);
    } on DioException catch (e) {
      throw ("Prediction failed: ${e.error}");
    }
  }
}
