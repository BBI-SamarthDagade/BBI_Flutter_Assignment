
class CartState {

}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Map<String, dynamic>> items;
  CartLoaded({required this.items});
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});
}