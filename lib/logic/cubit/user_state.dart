part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoadedState extends UserState {
  final List<User> users;
  UserLoadedState(this.users);
}

class UserLoadingState extends UserState {}

class UserErrorState extends UserState {
  final String error;
  UserErrorState(this.error);
}
