import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:pv_analizer/models/user.dart';

import 'package:pv_analizer/repositories/user_repo.dart';

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
