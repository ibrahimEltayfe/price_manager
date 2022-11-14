import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:price_manager/features/shared/entities/product_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../shared/models/product_model.dart';

abstract class DashboardRepository{
  Future<Either<Failure,List<ProductEntity>>> getAdminProducts({required bool isGetCreatedProducts,required bool isFirstFetch});
  Future<Either<Failure,void>> addProduct(ProductModel productModel,File imageFile);
  Future<Either<Failure,void>> updateProduct(ProductModel productModel,String newImage);
  Future<Either<Failure,void>> removeProduct(String productId,String image);
  Future<Either<Failure,String?>> getUserName(String uid);

  String? get userUID;
}