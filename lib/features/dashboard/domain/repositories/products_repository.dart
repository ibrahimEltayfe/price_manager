import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:price_manager/features/home/domain/entities/product_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../home/data/models/product_model.dart';

abstract class DashboardRepository{
  Future<Either<Failure,List<ProductEntity>>> getAdminProducts({required bool isGetCreatedProducts});
  Future<Either<Failure,void>> addProduct(ProductModel productModel,File imageFile);
  Future<Either<Failure,void>> updateProduct(ProductModel productModel,String newImage);
  Future<Either<Failure,void>> removeProduct(String productId);
  String? get userUID;
}