import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:lao_instruments/features/audio/constants/Audio_api_path.dart';
import 'package:lao_instruments/features/audio/models/audio_models.dart';

part 'audio_api_client.g.dart';

@injectable
@RestApi()
abstract class AudioApiClient {
  @factoryMethod
  factory AudioApiClient(Dio dio) = _AudioApiClient;

    @POST(AudioApiPath.predict)
    Future<PredictionResult> predictInstrument(
      @Body() FormData file,
    );
}
