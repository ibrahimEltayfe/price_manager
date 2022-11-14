import 'package:dartz/dartz.dart';
import 'package:price_manager/core/error/failures.dart';
import 'package:price_manager/features/profile/domain/entities/user_entity.dart';

abstract class ProfileRepository{
  Future<Either<Failure,UserEntity>> getUserInfo();
  Future<Either<Failure,void>> changePassword(String newPassword);
  Future<Either<Failure,void>> signOut();
}