part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, failure }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    String? errors,
  }) = _HomeState;
}
