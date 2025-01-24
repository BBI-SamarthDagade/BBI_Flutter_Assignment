
import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetFavouriteProductsIdUsecase {
  final ProductRepository productRepository;

  GetFavouriteProductsIdUsecase(this.productRepository);

  Future<Either<Failure, List<int>>> call(String userId) async {
    return await productRepository.getFavouriteProductsId(userId);
  }
}
