import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:price_manager/features/profile/domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  UserEntity? userEntity;

  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {

    on<ProfileFetchDataEvent>((event, emit) async{
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
    );

    on<ProfileChangePasswordEvent>((event, emit) async{
      emit(ProfileLoading());

      final results = await _profileRepository.changePassword(event.newPassword);
      results.fold(
        (failure) => emit(ProfileError(failure.message)),
        (results){
          emit(ProfileDateFetched());
        }
      );
    }
    );

    on<ProfileSignOutEvent>((event, emit) async{
      emit(ProfileLoading());

      final results = await _profileRepository.signOut();
      results.fold(
           (failure)=> emit(ProfileError(failure.message)),
           (results)=> emit(ProfileSignOut())
      );
    }
    );

  }
}
