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
import 'package:ecommerce/features/product/domain/entity/product_model.dart';
import 'package:http/http.dart' as http;

abstract class RemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl(this.client);

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
      throw Exception('Failed to fetch products. Status Code: ${response.statusCode}');
    }
  }
}
