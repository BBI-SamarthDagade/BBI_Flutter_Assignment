// class ProductModel {
//   final int id;
//   final String title;
//   final double price;
//   final String description;
//   final String image;
//   final double rate;

//   const ProductModel({
//     required this.id,
//     required this.title,
//     required this.price,
//     required this.description,
//     required this.image,
//     required this.rate,
//   });

//   // Factory method to create a model from JSON
//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['id'],
//       title: json['title'],
//       price: (json['price'] as num).toDouble(),
//       description: json['description'],
//       image: json['image'],
//       rate: (json['rating']['rate'] as num).toDouble(),
//     );
//   }

//   // Method to convert the model to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'price': price,
//       'description': description,
//       'image': image,
//       'rating': {'rate': rate},
//     };
//   }
// }


class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;
  final double rate;
  bool isFavorite;

   ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.rate,
   this.isFavorite = false,
  });

  // Factory method to create a model from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      image: json['thumbnail'],
      rate: (json['rating'] as num).toDouble(),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Method to convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'rating': {'rate': rate},
    };
  }
}

