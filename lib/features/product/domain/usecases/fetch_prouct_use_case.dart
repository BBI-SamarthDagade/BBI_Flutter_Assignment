import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/entity/product_model.dart';
import 'package:ecommerce/features/product/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchProuctUseCase {
    final ProductRepository productRepository;
    
    FetchProuctUseCase(this.productRepository);
    
  Future<Either<Failure, List<ProductModel>>> call(){
      return productRepository.getProducts();
  }
}
