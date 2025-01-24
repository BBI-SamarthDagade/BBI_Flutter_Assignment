part of 'product_bloc.dart';


abstract class ProductState {

}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;

  ProductLoaded(this.products);


}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);

}

class FavoriteProductsLoaded extends ProductState {
  final List<int> favoriteProductIds;

  FavoriteProductsLoaded(this.favoriteProductIds);
}
