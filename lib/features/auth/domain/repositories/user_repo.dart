import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class UserRepository{
  Future<Either<Failure,Unit>> loginWithEmail({required String email,required String password});
  Future<Either<Failure,Unit>> logOut();
}