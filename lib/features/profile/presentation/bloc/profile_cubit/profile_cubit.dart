import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utils/button_active_state_changer.dart';
import '../../../../shared/entities/user_entity.dart';
import '../../../domain/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  UserEntity? userEntity;

  Future<void> getProfileNameAndEmail() async{
    emit(ProfileLoading());

    final results = await _profileRepository.getUserInfo();
    results.fold(
            (failure) => emit(ProfileError(failure.message)),
            (results){
          userEntity = results;
          emit(ProfileDateFetched());
        }
    );
  }

  Future<void> signOut() async{
    emit(ProfileLoading());

    final results = await _profileRepository.signOut();
    results.fold(
       (failure)=> emit(ProfileError(failure.message)),
       (results)=> emit(ProfileSignOut())
    );
  }

}
