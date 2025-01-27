import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/product/domain/usecases/fetch_prouct_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce/features/product/domain/usecases/add_to_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/get_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/remove_from_cart_use_case.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final FetchProuctUseCase fetchProuctUseCase;

  Map<String, Map<String, dynamic>> _productMap = {};
  
  List<Map<String, dynamic>> _cartItems = [];

  CartBloc({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.fetchProuctUseCase,
  }) : super(CartInitial()) {
    print("cart bloc instance created");
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<FetchProductForCart>(_onGetProductsForCart);
  }

  // Load cart items and populate product details
  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final cartResult = await getCartUseCase.call(userId);

      cartResult.fold(
        (failure) => Failure(message: failure.message),
        (cartItems) {
          _cartItems = cartItems.map((cartItem) {
            final productId = cartItem['productId']; // Ensure productId is int

            final productDetails = _productMap[productId];

            if (productDetails!.isEmpty) {
              print(
                  "Warning: Product details for productId $productId not found in _productMap");
            }

            return {
              ...cartItem,
              'productDetails': productDetails, // Attach the product details
            };
          }).toList();

          emit(CartLoaded(items: _cartItems));
        },
      );
    } catch (e) {
      emit(CartError(message: "Failed to load cart: $e"));
    }
  }

  // Add item to cart
  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final result = await addToCartUseCase.call(
          event.userId, event.productId, event.quantity);

      result.fold(
        (failure) => emit(CartError(
            message: "Failed to add item to cart: ${failure.message}")),
        (_) {
          // Refresh the cart after successful addition
          add(LoadCart(userId));
        },
      );
    } catch (e) {
      emit(CartError(message: "Unexpected error while adding to cart: $e"));
    }
  }

  // Remove item from cart
  Future<void> _onRemoveFromCart(
      RemoveFromCart event, Emitter<CartState> emit) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final result =
          await removeFromCartUseCase.call(event.userId, event.productId);

      result.fold(
        (failure) => emit(CartError(
            message: "Failed to remove item from cart: ${failure.message}")),
        (_) {
          // Refresh the cart after successful removal
          add(LoadCart(userId));
        },
      );
    } catch (e) {
      emit(CartError(message: "Unexpected error while removing from cart: $e"));
    }
  }

  // Fetch product details and cache them
  Future<void> _onGetProductsForCart(
      FetchProductForCart event, Emitter<CartState> emit) async {
    try {
      final response = await fetchProuctUseCase.call();

      response.fold(
        (failure) => Failure(message: failure.message),
        (products) {
          _productMap = {
            for (var product in products)
              product.id.toString(): {
                'id': product.id,
                'title': product.title,
                'price': product.price,
                'image': product.image,
              }
          };

          emit(CartLoaded(
              items: _cartItems)); // Emit the cart with updated product details
        },
      );
    } catch (e) {
      emit(CartError(message: "Failed to fetch products: $e"));
    }
  }
}
