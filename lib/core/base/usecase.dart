import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';

abstract class UseCase<input,output>{
  Future<Either<Failure,output>> call(input);
}

