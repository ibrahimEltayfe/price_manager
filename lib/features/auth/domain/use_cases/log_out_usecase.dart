import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/user_repo.dart';

class LogOutUseCase{
  final UserRepository _userRepository;
  LogOutUseCase(this._userRepository);

  Future<Either<Failure,Unit>> call() async{
    return _userRepository.logOut();
  }

}