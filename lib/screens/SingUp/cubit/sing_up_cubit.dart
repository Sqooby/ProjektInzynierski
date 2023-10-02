import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'sing_up_state.dart';

class SingUpCubit extends Cubit<SingUpState> {
  SingUpCubit() : super(SingUpInitial());
}
