part of 'stackrs_cubit.dart';

enum StackrsStatus { initial, loading, success, failure }

@freezed
abstract class StackrsState with _$StackrsState {
  const factory StackrsState({
    @Default(StackrsStatus.initial) StackrsStatus status,
    String? errors,
  }) = _StackrsState;
}
