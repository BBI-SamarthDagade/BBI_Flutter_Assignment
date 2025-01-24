import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/entity/product_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, void >> addToCart(String userId, String productId, int quantity);
  Future<Either<Failure, void >> removeFromCart(String userId, String productId);
  Future<Either<Failure, List<Map<String, dynamic>>>> getCart(String userId);
  Future<Either<Failure,void>> toggleFavorite(String userId, int productId, bool isFavorite);
  Future<Either<Failure,List<int>>> getFavouriteProductsId(String userId);
}
