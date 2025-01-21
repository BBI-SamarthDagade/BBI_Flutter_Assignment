import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/entity/product_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts();
}
