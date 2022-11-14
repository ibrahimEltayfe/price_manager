part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileFetchDataEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class ProfileChangePasswordEvent extends ProfileEvent {
  final String newPassword;
  const ProfileChangePasswordEvent(this.newPassword);

  @override
  List<Object?> get props => [newPassword];
}

class ProfileSignOutEvent extends ProfileEvent {
  @override
  List<Object?> get props => [];
}