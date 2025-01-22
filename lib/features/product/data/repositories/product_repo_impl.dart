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
  
  @override
  Future<Either<Failure, void>> addToCart(String userId, String productId, int quantity) async {
    try {
      final products = await remoteDataSource.addToCart( userId,  productId,  quantity);
      return Right(products);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCart(String userId) async {
   try {
      final products = await remoteDataSource.getCart(userId);
      return Right(products);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> removeFromCart(String userId, String productId) async {
    try {
      final products = await remoteDataSource.removeFromCart(userId, productId);
      return Right(products);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

}
