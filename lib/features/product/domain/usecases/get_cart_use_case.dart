import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCartUseCase {
  ProductRepository productRepository;

  GetCartUseCase(this.productRepository);

    Future<Either<Failure, List<Map<String, dynamic>>>>  call(String userId){
      return productRepository.getCart(userId);
  }
}