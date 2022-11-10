part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoginSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class AuthLoggedOutState extends AuthState {
  @override
  List<Object> get props => [];
}


