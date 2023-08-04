import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:pv_analizer/logic/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:pv_analizer/logic/repositories/user_repo.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepo _repo;
  UserCubit(this._repo) : super(UserInitial());

  Future<void> fetchUser() async {
    emit(UserLoadingState());
    try {
      final response = await _repo.getUser();

      emit(UserLoadedState(response));
    } catch (e) {
      emit(UserErrorState(e.toString()));
    }
  }

  Future<void> registerUser(User user) async {
    final response = await _repo.registerUser(user);
  }
}
