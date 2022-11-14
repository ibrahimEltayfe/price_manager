import 'package:firebase_auth/firebase_auth.dart';
import 'package:price_manager/core/constants/app_errors.dart';
import 'package:price_manager/core/error/failures.dart';

class ExceptionHandler implements Exception{
  late final Failure failure;

  ExceptionHandler.handle(dynamic e){
    if(e is FirebaseAuthException){
      failure = AuthFailure(getAuthErrorMsg(e.code));
    }else if(e is FirebaseException){
      failure = UnExpectedFailure(e.message??AppErrors.unKnownError);
    }else if(e is UIDException){
      failure = NoUIDFailure(e.message);
    } else{
      failure = const UnExpectedFailure(AppErrors.unKnownError);
    }
  }
}

String getAuthErrorMsg(String code) {
  switch (code) {
    case 'user-disabled':
      return 'هذا البريد الإلكترونى متوقف. تواصل معنا';
    case 'user-not-found':
      return 'البريد الإلكترونى غير موجود';
    case 'wrong-password':
      return 'كلمة السر غير صحيحة';
    case 'invalid-email':
      return 'البريد الإلكترونى غير صالح';
    default:
      return 'حدث خطأ.. برجاء المحاولة مرة اخرى';
  }
}

class UIDException implements Exception{
  final String message;
  UIDException(this.message);
}