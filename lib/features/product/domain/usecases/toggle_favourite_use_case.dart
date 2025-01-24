import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class ToggleFavouriteUsecase {

  final ProductRepository productRepository;

  ToggleFavouriteUsecase(this.productRepository);

  Future<Either<Failure, void>> call(String userId,int productId,bool isFavorite) async {
    return await productRepository.toggleFavorite(userId, productId, isFavorite);
  }
}
