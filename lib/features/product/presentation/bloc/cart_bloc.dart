import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/usecases/add_to_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/get_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/remove_from_cart_use_case.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CartBloc extends Bloc<CartEvent, CartState> {
   final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCart;
  
  List<Map<String,dynamic>> _cachedCart= [];

  CartBloc(this.getCartUseCase, this.addToCartUseCase, this.removeFromCart) : super(CartInitial()) {

    on<LoadCart>((event, emit) async {
      emit(CartLoading());

      // Return cached cart if available
      if (_cachedCart.isNotEmpty) {
        print(_cachedCart);
        emit(CartLoaded(items: _cachedCart));
        return;
      }
      
      // Fetch cart from the use case
      final result = await getCartUseCase.call(event.userId);
      result.fold(
        (failure) => emit(CartError(message: "Failed to load cart")),
        (cartItems) {
          
          _cachedCart.addAll(cartItems); // Cache the fetched cart
          emit(CartLoaded(items: cartItems));
        },
      );
    });

  on<AddToCart>((event, emit) async {
  try {
    emit(CartLoading());

    // Call the use case and handle the Either result
    final result = await addToCartUseCase.call(event.userId, event.productId, event.quantity);

    result.fold(
      (failure) => Failure(message: "Failed to add item to cart: ${failure.message}"),
      (_) {
        // Update local cache directly
        final existingIndex = _cachedCart.indexWhere((item) => item['productId'] == event.productId);

        if (existingIndex != -1) {
          // Product already exists, update its quantity
          _cachedCart[existingIndex]['quantity'] += event.quantity;
        } else {
          // Add new product to the cache
         
          _cachedCart.add({
            'productId': event.productId,
            'quantity': event.quantity,
          });
        }

        // Emit the updated cart from cache
        emit(CartLoaded(items : List.from(_cachedCart))); // Emit a copy to avoid unintended mutations
      },
    );
  } catch (e) {
   Failure(message: "Unexpected error while adding to cart: $e");
  }
});


    on<RemoveFromCart>((event, emit) async {
      try {
        emit(CartLoading());

        // Call the use case and handle the Either result
        final result = await removeFromCart.call(event.userId, event.productId);

        result.fold(
          (failure) => Failure(message: "Failed to remove item from cart: ${failure.message}"),
          (_) {
            // Remove item from local cache
            _cachedCart.removeWhere((item) => item['productId'] == event.productId);

            // Emit updated cart from cache
            emit(CartLoaded(items : List.from(_cachedCart)));
          },
        );
      } catch (e) {
        Failure(message: "Unexpected error while removing from cart: $e");
      }
    });
  }
}


