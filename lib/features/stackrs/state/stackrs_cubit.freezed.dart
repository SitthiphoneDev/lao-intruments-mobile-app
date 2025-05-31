// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stackrs_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StackrsState {

 StackrsStatus get status; String? get errors;
/// Create a copy of StackrsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StackrsStateCopyWith<StackrsState> get copyWith => _$StackrsStateCopyWithImpl<StackrsState>(this as StackrsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StackrsState&&(identical(other.status, status) || other.status == status)&&(identical(other.errors, errors) || other.errors == errors));
}


@override
int get hashCode => Object.hash(runtimeType,status,errors);

@override
String toString() {
  return 'StackrsState(status: $status, errors: $errors)';
}


}

/// @nodoc
abstract mixin class $StackrsStateCopyWith<$Res>  {
  factory $StackrsStateCopyWith(StackrsState value, $Res Function(StackrsState) _then) = _$StackrsStateCopyWithImpl;
@useResult
$Res call({
 StackrsStatus status, String? errors
});




}
/// @nodoc
class _$StackrsStateCopyWithImpl<$Res>
    implements $StackrsStateCopyWith<$Res> {
  _$StackrsStateCopyWithImpl(this._self, this._then);

  final StackrsState _self;
  final $Res Function(StackrsState) _then;

/// Create a copy of StackrsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? errors = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StackrsStatus,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc


class _StackrsState implements StackrsState {
  const _StackrsState({this.status = StackrsStatus.initial, this.errors});
  

@override@JsonKey() final  StackrsStatus status;
@override final  String? errors;

/// Create a copy of StackrsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StackrsStateCopyWith<_StackrsState> get copyWith => __$StackrsStateCopyWithImpl<_StackrsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StackrsState&&(identical(other.status, status) || other.status == status)&&(identical(other.errors, errors) || other.errors == errors));
}


@override
int get hashCode => Object.hash(runtimeType,status,errors);

@override
String toString() {
  return 'StackrsState(status: $status, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$StackrsStateCopyWith<$Res> implements $StackrsStateCopyWith<$Res> {
  factory _$StackrsStateCopyWith(_StackrsState value, $Res Function(_StackrsState) _then) = __$StackrsStateCopyWithImpl;
@override @useResult
$Res call({
 StackrsStatus status, String? errors
});




}
/// @nodoc
class __$StackrsStateCopyWithImpl<$Res>
    implements _$StackrsStateCopyWith<$Res> {
  __$StackrsStateCopyWithImpl(this._self, this._then);

  final _StackrsState _self;
  final $Res Function(_StackrsState) _then;

/// Create a copy of StackrsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? errors = freezed,}) {
  return _then(_StackrsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StackrsStatus,errors: freezed == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
