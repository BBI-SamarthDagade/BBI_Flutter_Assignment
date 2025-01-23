class CartEvent{

}

class LoadCart extends CartEvent {
  final String userId;

  LoadCart(this.userId);


}

class AddToCart extends CartEvent {
  final String userId;
  final String productId;
  final int quantity;

  AddToCart({
    required this.userId,
    required this.productId,
     this.quantity = 1,
  });

}

class RemoveFromCart extends CartEvent {
  final String userId;
  final String productId;


  RemoveFromCart({
    required this.userId,
    required this.productId,
  });

}

class FetchProductForCart extends CartEvent{
  
}