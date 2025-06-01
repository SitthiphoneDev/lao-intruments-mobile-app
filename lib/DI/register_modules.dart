
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lao_instruments/constants/api_path.dart';
import 'package:lao_instruments/routers/app_router.dart';
import 'package:lao_instruments/services/interceptor_service.dart';

@module
abstract class InjectionModule{
  @lazySingleton
  AppRouter get appRouter => AppRouter();
  InterceptorsWrapper get intercepter => IntercepterService.instance.initialInterceptors();
  Dio get dio => Dio(BaseOptions(baseUrl: ApiPath.baseUrl))..interceptors.add(intercepter);
}
