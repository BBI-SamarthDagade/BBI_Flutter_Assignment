import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class RemoveFromCartUseCase {
  ProductRepository productRepository;

  RemoveFromCartUseCase(this.productRepository);

  Future<Either<Failure, void>> call(String userId, String productId){
      return productRepository.removeFromCart(userId, productId);
  }
}