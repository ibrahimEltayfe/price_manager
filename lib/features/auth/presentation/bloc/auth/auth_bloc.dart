import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/use_cases/log_out_usecase.dart';
import '../../../domain/use_cases/login_with_email_usecase.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
    final LoginWithEmailUseCase loginWithEmailUseCase;
    final LogOutUseCase logOutUseCase;

    AuthBloc(this.loginWithEmailUseCase,this.logOutUseCase) : super(AuthInitialState()) {

    on<LogInEvent>((event, emit) async{
      emit(AuthLoadingState());

       final login =await loginWithEmailUseCase(event.email, event.password);
       login.fold(
       (failure){
         log(failure.message.toString());
         emit(AuthErrorState(failure.message));
        },
       (userCred) {
         emit(AuthLoginSuccessState());
       });

    });

    on<LogOutEvent>((event, emit) async{
      emit(AuthLoadingState());

      final logOut = await logOutUseCase();
       logOut.fold(
           (failure){
            emit(AuthErrorState(failure.message));
          },
           (unit) {
            emit(AuthLoggedOutState());
          });
    });
  }

}

