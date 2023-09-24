import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:pv_analizer/logic/models/course_stage_list.dart';
import 'package:pv_analizer/logic/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:pv_analizer/logic/repositories/course_stage_repo.dart';
import 'package:pv_analizer/logic/repositories/user_repo.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepo _repo1;

  UserCubit(this._repo1) : super(UserInitial());

  Future<void> fetchUser() async {
    emit(UserLoadingState());

    try {
      final response = await _repo1.getUser();

      emit(UserLoadedState(response));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> registerUser(User user) async {
    final response = await _repo1.registerUser(user);
  }
}
