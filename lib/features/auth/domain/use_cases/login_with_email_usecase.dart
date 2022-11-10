import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/user_repo.dart';

class LoginWithEmailUseCase{
  final UserRepository _userRepository;
  LoginWithEmailUseCase(this._userRepository);

  Future<Either<Failure,Unit>> call(String email,String password) async{
    return _userRepository.loginWithEmail(email: email, password: password);
  }

}