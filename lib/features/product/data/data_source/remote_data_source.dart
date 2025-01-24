import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/features/product/domain/entity/product_model.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<List<ProductModel>> fetchProducts();

  Future<void> addToCart(String userId, String productId, int quantity);
  Future<void> removeFromCart(String userId, String productId);
  Future<List<Map<String, dynamic>>> getCart(String userId);
  
   Future<void> toggleFavorite(String userId, int productId, bool isFavorite);
   Future<List<int>> getFavouriteProductsId(String userId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final FirebaseFirestore firestore;

  RemoteDataSourceImpl(this.client, this.firestore);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    const String apiUrl = "https://dummyjson.com/products";

    final response = await client.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> response_map = json.decode(response.body);
      final List<dynamic> data = response_map["products"];
      print("object");
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to fetch products. Status Code: ${response.statusCode}');
    }
  }

  Future<void> addToCart(String userId, String productId, int quantity) async {
    // Reference to the user's cart in Firestore
    final cartRef = firestore.collection('cart').doc(userId);

    try {
      final cartDoc = await cartRef.get();

      if (cartDoc.exists) {
       List<dynamic> items = cartDoc['items'] ?? [];

        bool productExists = false;

        // Update quantity or mark product as existing
        items = items
            .map((item) {
              if (item['productId'] == productId) {
                productExists = true;
                if (quantity > 0) {
                  // Increment quantity
                  item['quantity'] += quantity;
                } else {
                  // Decrement quantity
                  item['quantity'] +=
                      quantity; // quantity is negative for decrement
                  if (item['quantity'] <= 0) {
                    return null; // Mark item for removal
                  }
                }
              }
              return item;
            })
            .where((item) => item != null)
            .toList(); // Remove items marked as null

        // Add new product if not already in cart
        if (!productExists && quantity > 0) {
          items.add({'productId': productId, 'quantity': quantity});
        }

        if (items.isEmpty) {
          // If the cart becomes empty, delete the document
          await cartRef.delete();
        } else {
          // Update Firestore with the modified cart items
          await cartRef.update({'items': items});
        }
      } else {
        if (quantity > 0) {
          // If cart doesn't exist and quantity > 0, create a new cart
          await cartRef.set({
            'items': [
              {'productId': productId, 'quantity': quantity}
            ]
          });
        } else {
          print("Cannot decrement a product from an empty cart");
        }
      }
    } catch (e) {
      print("Error in addToCart: $e");
      throw Exception("Failed to update the cart: $e");
    }
  }

//remove from cart
  @override
  Future<void> removeFromCart(String userId, String productId) async {
    final cartRef = firestore.collection('cart').doc(userId);
    final cartDoc = await cartRef.get();

    if (cartDoc.exists) {
      List<dynamic> items = cartDoc['items'];
      items.removeWhere((item) => item['productId'] == productId);

      await cartRef.update({'items': items});
    }
  }

//get cart
  @override
  Future<List<Map<String, dynamic>>> getCart(String userId) async {
    final cartRef = firestore.collection('cart').doc(userId);
    final cartDoc = await cartRef.get();

    if (cartDoc.exists) {
      return List<Map<String, dynamic>>.from(cartDoc['items'] ?? []);
    }
    return [];
  }

  //toggle favorite
  Future<void> toggleFavorite(String userId, int productId, bool isFavorite) async {
  try {
    final userRef = firestore.collection('wishlist').doc(userId);
    
    final docSnapshot = await userRef.get();

    if (!docSnapshot.exists) {

      await userRef.set({
        'favourite': [],
      });
    }

    if (isFavorite) {
      await userRef.update({
        'favourite': FieldValue.arrayUnion([productId]),
      });
    } else {
      await userRef.update({
        'favourite': FieldValue.arrayRemove([productId]),
      });
    }
  } catch (e) {
    throw Exception('Failed to toggle favorite: $e');
  }
}

  @override
  Future<List<int>> getFavouriteProductsId(String userId) async {
    try {
      final userRef = firestore.collection('wishlist').doc(userId);
      final docSnapshot = await userRef.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('favourite')) {
          return List<int>.from(data['favourite']);
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch favorites: $e');
    }
  }
}
