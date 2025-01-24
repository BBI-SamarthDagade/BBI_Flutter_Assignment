// import 'package:ecommerce/features/product/presentation/bloc/cart_bloc.dart';
// import 'package:ecommerce/features/product/presentation/bloc/cart_event.dart';
// import 'package:ecommerce/features/product/presentation/bloc/product_bloc.dart';
// import 'package:ecommerce/features/product/presentation/widget/payment_success_popup.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:ecommerce/features/product/domain/entity/product_model.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ProductDetailsPage extends StatefulWidget {
//   final ProductModel product;

//   const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

//   @override
//   State<ProductDetailsPage> createState() => _ProductDetailsPageState();
// }

// class _ProductDetailsPageState extends State<ProductDetailsPage> {
//   void addToWishlist(BuildContext context) {
//     context.read<ProductBloc>().add(
//           ToggleFavoriteEvent(widget.product.id),
//         );
//   }

//   void addToCart(BuildContext context) {
//     context.read<CartBloc>().add(
//           AddToCart(
//             userId: FirebaseAuth.instance.currentUser!.uid,
//             productId: widget.product.id.toString(),
//             quantity: 1,
//           ),
//         );

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//           content: Text(
//             '${widget.product.title} added to Cart',
//             style: TextStyle(color: Colors.black),
//           ),
//           backgroundColor: Colors.lightBlue[300]),
//     );
//   }

//   void buyNow(BuildContext context) {
//     showPaymentSuccessDialog(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.product.title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.favorite_outline_outlined),
//             color: Colors.red,
//             onPressed: () => addToWishlist(context),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product Image
//               Center(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Image.network(
//                       widget.product.image,
//                       height: 300,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Title
//               Text(
//                 widget.product.title,
//                 style: const TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               // Rating and Reviews
//               Row(
//                 children: [
//                   for (var i = 0; i < widget.product.rate.floor(); i++)
//                     const Icon(Icons.star, color: Colors.amber, size: 20),
//                   if (widget.product.rate - widget.product.rate.floor() >= 0.5)
//                     const Icon(Icons.star_half, color: Colors.amber, size: 20),
//                   for (var i = 0; i < (5 - widget.product.rate.ceil()); i++)
//                     const Icon(Icons.star_border,
//                         color: Colors.amber, size: 20),
//                   const SizedBox(width: 10),
//                   Text(
//                     '${widget.product.rate}/5',
//                     style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               // Price
//               Text(
//                 'Price: \$${widget.product.price.toStringAsFixed(2)}',
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Description
//               Text(
//                 widget.product.description,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey.shade700,
//                   height: 1.6,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               // Action Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => addToWishlist(context),
//                       child: Container(
//                         height: 50,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.pinkAccent.shade200,
//                               Colors.pinkAccent.shade100
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.favorite_border, color: Colors.white),
//                             SizedBox(width: 8),
//                             Text(
//                               'Add to Wishlist',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => addToCart(context),
//                       child: Container(
//                         height: 50,
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.blueAccent.shade200,
//                               Colors.blueAccent.shade100
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             Icon(Icons.shopping_cart, color: Colors.white),
//                             SizedBox(width: 8),
//                             Text(
//                               'Add to Cart',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // Buy Now Button
//               GestureDetector(
//                 onTap: () => buyNow(context),
//                 child: Container(
//                   height: 50,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.green.shade500, Colors.green.shade300],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Icon(Icons.shopping_bag, color: Colors.white),
//                       SizedBox(width: 8),
//                       Text(
//                         'Buy Now',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:ecommerce/features/product/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:ecommerce/features/product/presentation/widget/payment_success_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/features/product/domain/entity/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  void addToCart(BuildContext context) {
    context.read<CartBloc>().add(
          AddToCart(
            userId: FirebaseAuth.instance.currentUser!.uid,
            productId: widget.product.id.toString(),
            quantity: 1,
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            '${widget.product.title} added to Cart',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.lightBlue[300]),
    );
  }

  void buyNow(BuildContext context) {
    showPaymentSuccessDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline_outlined),
            color: Colors.red,
            onPressed: () {
              context.read<ProductBloc>().add(
                    ToggleFavoriteEvent(widget.product.id),
                  );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Image.network(
                      widget.product.image,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(
                widget.product.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Rating and Reviews
              Row(
                children: [
                  for (var i = 0; i < widget.product.rate.floor(); i++)
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                  if (widget.product.rate - widget.product.rate.floor() >= 0.5)
                    const Icon(Icons.star_half, color: Colors.amber, size: 20),
                  for (var i = 0; i < (5 - widget.product.rate.ceil()); i++)
                    const Icon(Icons.star_border,
                        color: Colors.amber, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    '${widget.product.rate}/5',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Price
              Text(
                'Price: \$${widget.product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              // Description
              Text(
                widget.product.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 30),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => addToCart(context),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blueAccent.shade200,
                              Colors.blueAccent.shade100
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.shopping_cart, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Add to Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Buy Now Button
              GestureDetector(
                onTap: () => buyNow(context),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade500, Colors.green.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.shopping_bag, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
