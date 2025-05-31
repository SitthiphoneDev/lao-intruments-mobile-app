
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:stackrs/routers/app_router.dart';
import 'package:stackrs/services/interceptor_service.dart';


import '../constants/api_path.dart';

@module
abstract class InjectionModule{

  @lazySingleton
  AppRouter get appRouter => AppRouter();
  InterceptorsWrapper get intercepter => IntercepterService.instance.initialInterceptors();
  Dio get dio => Dio(BaseOptions(baseUrl: ApiPath.baseUrl))..interceptors.add(intercepter);
}
