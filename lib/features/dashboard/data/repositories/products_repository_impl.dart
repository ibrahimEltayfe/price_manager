import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ntp/ntp.dart';
import 'package:price_manager/core/error/failures.dart';
import 'package:price_manager/features/home/data/data_sources/products_remote.dart';
import 'package:price_manager/features/home/data/models/product_model.dart';
import 'package:price_manager/features/home/domain/entities/product_entity.dart';
import '../../../../core/constants/app_errors.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network_info/network_checker.dart';
import '../../domain/repositories/products_repository.dart';
import '../data_sources/products_remote.dart';

class DashboardRepositoryImpl implements DashboardRepository{
  final DashboardRemote _dashboardRemote;
  final NetworkInfo _connectionChecker;
  DashboardRepositoryImpl(this._dashboardRemote, this._connectionChecker);

  @override
  String? get userUID => _dashboardRemote.userUID;

  @override
  Future<Either<Failure, void>> addProduct(ProductModel productModel,File imageFile) async{
    return await _handleFailures(
      () async{
        productModel.createdAt = await _getCurrentDate();
        return _dashboardRemote.addProduct(productModel,imageFile);
      }
    );
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAdminProducts({required bool isGetCreatedProducts}) async{
    return await _handleFailures(
        () => _dashboardRemote.getAdminProducts(getCreatedProducts:isGetCreatedProducts)
    );
  }

  @override
  Future<Either<Failure, void>> removeProduct(String productId) async{
    return await _handleFailures(
       () => _dashboardRemote.removeProduct(productId)
    );
  }

  @override
  Future<Either<Failure, void>> updateProduct(ProductModel productModel,String newImage) async{
    return await _handleFailures(
      () async{
        productModel.modifiedAt = await _getCurrentDate();
        _dashboardRemote.updateProduct(productModel,newImage);
      }
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

Future<Timestamp?> _getCurrentDate() async{
    DateTime currentDate = await NTP.now().catchError((e,s){
      log("from ntp error: ${e.toString()}");
      return DateTime.now();
    });

    Timestamp currentTimestamp = Timestamp.fromDate(currentDate);
    return currentTimestamp;

}