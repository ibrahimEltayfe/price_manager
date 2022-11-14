import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dartz/dartz.dart';

import 'package:price_manager/core/error/failures.dart';
import 'package:price_manager/features/home/data/data_sources/products_remote.dart';

import 'package:price_manager/features/home/domain/entities/product_entity.dart';

import '../../../../core/constants/app_errors.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network_info/network_checker.dart';
import '../../domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository{
  final ProductsRemote _productsRemote;
  final NetworkInfo _connectionChecker;
  ProductsRepositoryImpl(this._productsRemote, this._connectionChecker);


  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts(bool isFirstFetch) async{
    return await _handleFailures<List<ProductEntity>>(
      ()=> _productsRemote.getAllProducts(isFirstFetch),
    );
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchForProducts(String searchText) async{
    return await _handleFailures<List<ProductEntity>>(
       ()=> _productsRemote.searchForProducts(searchText)
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