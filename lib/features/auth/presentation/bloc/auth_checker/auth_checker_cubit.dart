import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utils/shared_pref.dart';
part 'auth_checker_state.dart';

class AuthCheckerCubit extends Cubit<AuthCheckerState> {
  AuthCheckerCubit() : super(AuthCheckerInitial());


}
