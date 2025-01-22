import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddToCartUseCase {
  ProductRepository productRepository;

  AddToCartUseCase(this.productRepository);

  Future<Either<Failure, void>> call(String userId, String productId, int quantity){
      return productRepository.addToCart(userId, productId, quantity);
  }
}