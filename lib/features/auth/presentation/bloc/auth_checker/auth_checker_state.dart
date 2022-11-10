part of 'auth_checker_cubit.dart';

abstract class AuthCheckerState extends Equatable {
  const AuthCheckerState();
}

class AuthCheckerInitial extends AuthCheckerState {
  @override
  List<Object> get props => [];
}

class AuthCheckerAuthenticated  extends AuthCheckerState {
  @override
  List<Object> get props => [];
}

class AuthCheckerUnAuthenticated extends AuthCheckerState {
  @override
  List<Object> get props => [];
}

class AuthCheckerLoading extends AuthCheckerState {
  @override
  List<Object> get props => [];
}

class AuthCheckerLoggedOut extends AuthCheckerState {
  @override
  List<Object> get props => [];
}

class AuthCheckerError extends AuthCheckerState {
  final String message;
  const AuthCheckerError(this.message);
  @override
  List<Object> get props => [message];
}

class PhoneNumberNotVerified extends AuthCheckerState {
  final String userPhoneNumber;
  const PhoneNumberNotVerified(this.userPhoneNumber);
  @override
  List<Object> get props => [userPhoneNumber];
}