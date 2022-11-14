part of 'change_password_cubit.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class PasswordChanged extends ChangePasswordState {}

class ChangePasswordError extends ChangePasswordState {
  final String message;
  const ChangePasswordError(this.message);

  @override
  List<Object> get props => [message];
}
