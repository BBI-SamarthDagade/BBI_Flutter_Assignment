import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/entity/product_model.dart';
import 'package:ecommerce/features/product/domain/usecases/fetch_prouct_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/get_favourite_products_id_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/toggle_favourite_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final FetchProuctUseCase getProducts;

  final GetFavouriteProductsIdUsecase getFavouriteProductsIdUsecase;
  final ToggleFavouriteUsecase toggleFavouriteUsecase;
 
   
  List<ProductModel> _productModel = [];
  
  ProductBloc(this.getProducts, this.getFavouriteProductsIdUsecase, this.toggleFavouriteUsecase) : super(ProductInitial()) {
    print("product bloc instance created");
    on<GetProductEvent>((event, emit) async {
      emit(ProductLoading());

    if(_productModel.isNotEmpty){
      emit(ProductLoaded(_productModel));
      return ;
    }


      final result = await getProducts();
      result.fold(
        (failure) => emit(ProductError("failed to fetch product")),
        (products) {
          _productModel = products;
          // emit(ProductLoaded(products));
          add(LoadFavoriteProductsIdEvent());
        } 
      );
    });
    
    on<LoadFavoriteProductsIdEvent>((event, emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final favouriteIdsResponse =
        await getFavouriteProductsIdUsecase.call(userId);

    favouriteIdsResponse.fold((failure) {
      emit(ProductLoaded(_productModel));
    }, (favoriteIds) {
      for (var product in _productModel) {
        product.isFavorite = favoriteIds.contains(product.id);
      }

      emit(ProductLoaded(_productModel));
    });
  });

  on<ToggleFavoriteEvent>((event, emit) async {
    print("inside product bloc");
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final product = _productModel.firstWhere((p) => p.id == event.productId);

    final newIsFavorite = !product.isFavorite;

    final result = await toggleFavouriteUsecase.call(
        userId, event.productId, newIsFavorite);

    result.fold(
      (failure) {
        emit(ProductError("${failure.message}"));
      },
      (_) {
        product.isFavorite = newIsFavorite;
        emit(ProductLoaded(_productModel));
      },
    );
  });

    
  }
}


