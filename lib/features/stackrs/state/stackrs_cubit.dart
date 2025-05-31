import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'stackrs_state.dart';
part 'stackrs_cubit.freezed.dart';  

@injectable
class StackrsCubit extends Cubit<StackrsState> {
  StackrsCubit() : super(const StackrsState());
}
