import 'package:dartz/dartz.dart';
import 'package:price_manager/features/home/domain/entities/product_entity.dart';

import '../../../../core/error/failures.dart';

abstract class ProductsRepository{
  Future<Either<Failure,List<ProductEntity>>> getAllProducts(bool isFirstFetch);
  Future<Either<Failure,List<ProductEntity>>> searchForProducts(String searchText);
}