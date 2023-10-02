part of 'sing_up_cubit.dart';

@immutable
abstract class SingUpState {}

class SingUpInitial extends SingUpState {}

class SingUpLoading extends SingUpState {}

class SingUpLoaded extends SingUpState {}

class SingUpError extends SingUpState {}
