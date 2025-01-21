import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/data/data_source/remote_data_source.dart';
import 'package:ecommerce/features/product/domain/entity/product_model.dart';
import 'package:ecommerce/features/product/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
  
    try {
      final products = await remoteDataSource.fetchProducts();
      return Right(products);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
