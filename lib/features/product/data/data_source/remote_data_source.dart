// import 'dart:convert';
// import 'package:ecommerce/features/product/domain/entity/product_model.dart';
// import 'package:http/http.dart' as http;

// abstract class RemoteDataSource {
//   Future<List<ProductModel>> fetchProducts();
// }

// class RemoteDataSourceImpl implements RemoteDataSource {
//   final http.Client client;

//   RemoteDataSourceImpl(this.client);

//   @override
//   Future<List<ProductModel>> fetchProducts() async {

//     const String apiUrl = "https://fakestoreapi.com/products";

//     final response = await client.get(Uri.parse(apiUrl));
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((json) => ProductModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to fetch products. Status Code: ${response.statusCode}');
//     }
//   }
// }
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/features/product/domain/entity/product_model.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<List<ProductModel>> fetchProducts();

  Future<void> addToCart(String userId, String productId, int quantity);
  Future<void> removeFromCart(String userId, String productId);
  Future<List<Map<String, dynamic>>> getCart(String userId);
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

  //add to cart method
  @override
  Future<void> addToCart(String userId, String productId, int quantity) async {
    print("addToCart called with: userId=$userId, productId=$productId, quantity=$quantity");

    final cartRef = firestore.collection('cart').doc(userId);
    
    final cartDoc = await cartRef.get();
    
    if (cartDoc.exists) {
      List<dynamic> items = cartDoc['items'] ?? [];
      print(items);
      bool productExists = false;

      items = items.map((item) {
        if (item['productId'] == productId) {
          productExists = true;
          item['quantity'] += quantity;
        }
        return item;
      }).toList();

      if (!productExists) {
        items.add({'productId': productId, 'quantity': quantity});
      }

      await cartRef.update({'items': items});
    } else {
      await cartRef.set({
        'items': [{'productId': productId, 'quantity': quantity}]
      });
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
}
