import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/button_active_state_changer.dart';
import '../../../domain/repositories/profile_repository.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ProfileRepository _profileRepository;
  ChangePasswordCubit(this._profileRepository) : super(ChangePasswordInitial());

  final ButtonStateChanger buttonStateChanger = ButtonStateChanger();

  Future<void> changePassword({required String oldPassword,required String newPassword}) async{
    emit(ChangePasswordLoading());

    final results = await _profileRepository.changePassword(
        oldPassword:oldPassword,
        newPassword:newPassword
    );

    results.fold(
       (failure) => emit(ChangePasswordError(failure.message)),
       (results) => emit(PasswordChanged())
    );
  }

  @override
  Future<void> close() {
    buttonStateChanger.dispose();
    return super.close();
  }
}
