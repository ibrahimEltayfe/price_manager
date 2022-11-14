import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:price_manager/features/profile/data/data_sources/profile_remote.dart';
import 'package:price_manager/features/profile/data/models/user_model.dart';
import 'package:price_manager/features/profile/domain/entities/user_entity.dart';
import '../../../../core/constants/app_errors.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network_info/network_checker.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository{
  final ProfileRemote _profileRemote;
  final NetworkInfo _connectionChecker;

  ProfileRepositoryImpl(this._profileRemote, this._connectionChecker);

  @override
  Future<Either<Failure, void>> changePassword(String newPassword) async{
    return await _handleFailures<void>(
        ()=> _profileRemote.changePassword(newPassword)
    );
  }

  @override
  Future<Either<Failure, UserEntity>> getUserInfo() async{
    return await _handleFailures<UserEntity>(
      ()async{
        final DocumentSnapshot<Map<String, dynamic>> userData = await _profileRemote.getUserInfo();
        final UserEntity userEntity= UserModel.fromMap(userData.data()??{});

        return userEntity;
      }
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async{
    return await _handleFailures<void>(
      ()=> _profileRemote.signOut()
    );
  }

  Future<Either<Failure, resultType>> _handleFailures<resultType>(Future<resultType> Function() task) async{
    if(await _connectionChecker.isConnected) {
      try{
        final resultType result = await task();
        return Right(result);
      }catch(e){
        log(e.toString());
        return Left(ExceptionHandler.handle(e).failure);
      }
    }else{
      return const Left(NoInternetFailure(AppErrors.noInternet));
    }
  }
}
