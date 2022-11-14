import 'package:firebase_auth/firebase_auth.dart';
import 'package:price_manager/core/constants/app_errors.dart';
import 'package:price_manager/core/error/failures.dart';

class ExceptionHandler implements Exception{
  late final Failure failure;

  ExceptionHandler.handle(dynamic e){
    if(e is FirebaseAuthException){
      failure = AuthFailure(getLoginErrorMsg(e.code));
    }else if(e is FirebaseException){
      failure = UnExpectedFailure(e.message??AppErrors.unKnownError);
    }else if(e is UIDException){
      failure = NoUIDFailure(e.message);
    } else{
      failure = const UnExpectedFailure(AppErrors.unKnownError);
    }
  }
}

String getLoginErrorMsg(String code) {
  switch (code) {
    case 'user-disabled':
      return 'This user has been disabled. contact support for help.';
    case 'user-not-found':
      return 'Email is not found.';
    case 'wrong-password':
      return 'Incorrect password, please try again.';
    case 'invalid-email':
      return 'Email is not valid.';
    default:
      return 'Login Error.. please try again';
  }
}

class UIDException implements Exception{
  final String message;
  UIDException(this.message);
}