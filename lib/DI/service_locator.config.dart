// dart format width=80
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
import 'package:stackrs/DI/register_modules.dart' as _i806;
import 'package:stackrs/features/stackrs/state/stackrs_cubit.dart' as _i922;
import 'package:stackrs/routers/app_router.dart' as _i1052;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final injectionModule = _$InjectionModule();
    gh.factory<_i361.InterceptorsWrapper>(() => injectionModule.intercepter);
    gh.factory<_i361.Dio>(() => injectionModule.dio);
    gh.factory<_i922.StackrsCubit>(() => _i922.StackrsCubit());
    gh.lazySingleton<_i1052.AppRouter>(() => injectionModule.appRouter);
    return this;
  }
}

class _$InjectionModule extends _i806.InjectionModule {}
