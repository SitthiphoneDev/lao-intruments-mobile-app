// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lao_instruments/DI/register_modules.dart' as _i186;
import 'package:lao_instruments/features/audio/data/audio_api_client.dart'
    as _i1000;
import 'package:lao_instruments/features/audio/data/audio_repositiory.dart'
    as _i962;
import 'package:lao_instruments/features/audio/state/audio_cubit.dart' as _i719;
import 'package:lao_instruments/routers/app_router.dart' as _i418;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectionModule = _$InjectionModule();
    gh.factory<_i361.InterceptorsWrapper>(() => injectionModule.intercepter);
    gh.factory<_i361.Dio>(() => injectionModule.dio);
    gh.lazySingleton<_i418.AppRouter>(() => injectionModule.appRouter);
    gh.factory<_i1000.AudioApiClient>(
        () => _i1000.AudioApiClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i962.AudioRepository>(
        () => _i962.AudioRepositoryImpl(gh<_i1000.AudioApiClient>()));
    gh.factory<_i719.AudioCubit>(
        () => _i719.AudioCubit(gh<_i962.AudioRepository>()));
    return this;
  }
}

class _$InjectionModule extends _i186.InjectionModule {}
