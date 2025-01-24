// import 'package:ecommerce/features/product/presentation/bloc/cart_bloc.dart';
// import 'package:ecommerce/features/product/presentation/bloc/cart_event.dart';
// import 'package:ecommerce/features/product/presentation/bloc/cart_state.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CartScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Trigger LoadCart event
//     context.read<CartBloc>().add(LoadCart(FirebaseAuth.instance.currentUser!.uid));

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Shopping Cart"),
//         centerTitle: true,
//       ),
//       body: BlocBuilder<CartBloc, CartState>(
//         builder: (context, state) {
//           if (state is CartLoading) {
//             return Center(child: CircularProgressIndicator());
//           }
//           else if (state is CartError) {
//             return Center(
//               child: Text(
//                 state.message,
//                 style: TextStyle(color: Colors.red, fontSize: 18),
//               ),
//             );
//           }
//           else if (state is CartLoaded) {
//             final cartItems = state.items;

//             // Handle empty cart scenario
//             if (cartItems.isEmpty) {
//               return Center(
//                 child: Text(
//                   "Your cart is empty",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//               );
//             }

//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: cartItems.length,
//                     itemBuilder: (context, index) {
//                       // Safely access the cart item
//                       final item = cartItems[index];
//                       final userId = FirebaseAuth.instance.currentUser!.uid;

//                       // Safely access cart item fields with fallback values
//                       final productId = item['productId'] ?? 'Unknown';
//                       final productDetails = item['productDetails'] ?? {};
//                       final productTitle =
//                           productDetails['title'] ?? 'Unknown Title';
//                       final imageUrl =
//                           productDetails['image'] ?? 'https://via.placeholder.com/80';
//                       final quantity = (item['quantity'] ?? 0) as int;
//                       final price = (productDetails['price'] ?? 0.0) as num;

//                       return Card(
//                         margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         elevation: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Row(
//                             children: [
//                               // Product Image
//                               Container(
//                                 width: 80,
//                                 height: 80,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8),
//                                   image: DecorationImage(
//                                     image: NetworkImage(imageUrl),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 10),

//                               // Product Details
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       productTitle,
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       '\$${price.toStringAsFixed(2)}',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.green,
//                                       ),
//                                     ),
//                                     SizedBox(height: 10),
//                                     Row(
//                                       children: [
//                                         // Decrement or delete button
//                                         IconButton(
//                                           icon: Icon(
//                                             quantity > 1 ? Icons.remove : Icons.delete,
//                                             color: quantity > 1 ? Colors.blue : Colors.red,
//                                           ),
//                                           onPressed: () {
//                                             if (quantity > 1) {
//                                               // Decrement quantity
//                                               context.read<CartBloc>().add(
//                                                     AddToCart(
//                                                       userId: userId,
//                                                       productId: productId,
//                                                       quantity: -1,
//                                                     ),
//                                                   );
//                                             } else {
//                                               // Remove item from cart
//                                               context.read<CartBloc>().add(
//                                                     RemoveFromCart(
//                                                       userId: userId,
//                                                       productId: productId,
//                                                     ),
//                                                   );
//                                             }
//                                           },
//                                         ),
//                                         Text(
//                                           '$quantity',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         // Increment button
//                                         IconButton(
//                                           icon: Icon(Icons.add, color: Colors.blue),
//                                           onPressed: () {
//                                             context.read<CartBloc>().add(
//                                                   AddToCart(
//                                                     userId: userId,
//                                                     productId: productId,
//                                                     quantity: 1,
//                                                   ),
//                                                 );
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // Delete Button
//                               IconButton(
//                                 icon: Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () {
//                                   // Remove item from cart
//                                   context.read<CartBloc>().add(
//                                         RemoveFromCart(
//                                           userId: userId,
//                                           productId: productId,
//                                         ),
//                                       );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),

//                 // Order Summary and Checkout Button
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 10,
//                         offset: Offset(0, -2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Order Summary",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Subtotal",
//                               style: TextStyle(
//                                 fontSize: 16,
//                               )),
//                           Text(
//                             '\$${cartItems.fold<double>(
//                               0.0,
//                               (total, item) =>
//                                   total +
//                                   ((item['quantity'] ?? 0) as int) *
//                                       ((item['productDetails']?['price'] ?? 0.0) as num),
//                             ).toStringAsFixed(2)}', // Format to 2 decimal places
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 12),
//                       ElevatedButton(
//                         onPressed: () {

//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.orange,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Proceed to Checkout",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }
//           return Center(
//             child: Text(
//               "No items in cart",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:ecommerce/features/product/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_state.dart';
import 'package:ecommerce/features/product/presentation/widget/payment_success_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Trigger LoadCart event
    context
        .read<CartBloc>()
        .add(LoadCart(FirebaseAuth.instance.currentUser!.uid));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.shopping_cart,
              color: Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 15),
            const Text(
              "Shopping Cart",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (state is CartLoaded) {
            final cartItems = state.items;

            // Handle empty cart scenario
            if (cartItems.isEmpty) {
              return Center(
                child: Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      // Safely access the cart item
                      final item = cartItems[index];
                      final userId = FirebaseAuth.instance.currentUser!.uid;

                      // Safely access cart item fields with fallback values
                      final productId = item['productId'] ?? 'Unknown';
                      final productDetails = item['productDetails'] ?? {};
                      final productTitle =
                          productDetails['title'] ?? 'Unknown Title';
                      final imageUrl = productDetails['image'] ??
                          'https://via.placeholder.com/80';
                      final quantity = (item['quantity'] ?? 0) as int;
                      final price = (productDetails['price'] ?? 0.0) as num;

                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              // Product Image
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),

                              // Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productTitle,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '₹${price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        // Decrement or delete button
                                        IconButton(
                                          icon: Icon(
                                            quantity > 1
                                                ? Icons.remove
                                                : Icons.delete,
                                            color: quantity > 1
                                                ? Colors.blue
                                                : Colors.red,
                                          ),
                                          onPressed: () {
                                            if (quantity > 1) {
                                              // Decrement quantity
                                              context.read<CartBloc>().add(
                                                    AddToCart(
                                                      userId: userId,
                                                      productId: productId,
                                                      quantity: -1,
                                                    ),
                                                  );
                                            } else {
                                              // Remove item from cart
                                              context.read<CartBloc>().add(
                                                    RemoveFromCart(
                                                      userId: userId,
                                                      productId: productId,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                        Text(
                                          '$quantity',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Increment button
                                        IconButton(
                                          icon: Icon(Icons.add,
                                              color: Colors.blue),
                                          onPressed: () {
                                            context.read<CartBloc>().add(
                                                  AddToCart(
                                                    userId: userId,
                                                    productId: productId,
                                                    quantity: 1,
                                                  ),
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Delete Button
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Remove item from cart
                                  context.read<CartBloc>().add(
                                        RemoveFromCart(
                                          userId: userId,
                                          productId: productId,
                                        ),
                                      );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Order Summary and Checkout Button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '₹${cartItems.fold<double>(
                                  0.0,
                                  (total, item) =>
                                      total +
                                      ((item['quantity'] ?? 0) as int) *
                                          ((item['productDetails']?['price'] ??
                                              0.0) as num),
                                ).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Shipping",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            cartItems.fold<double>(
                                      0.0,
                                      (total, item) =>
                                          total +
                                          ((item['quantity'] ?? 0) as int) *
                                              ((item['productDetails']
                                                      ?['price'] ??
                                                  0.0) as num),
                                    ) <
                                    500
                                ? "₹40.00"
                                : "₹0.00",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${(cartItems.fold<double>(
                                  0.0,
                                  (total, item) =>
                                      total +
                                      ((item['quantity'] ?? 0) as int) *
                                          ((item['productDetails']?['price'] ??
                                              0.0) as num),
                                ) + (cartItems.fold<double>(
                                      0.0,
                                      (total, item) =>
                                          total +
                                          ((item['quantity'] ?? 0) as int) *
                                              ((item['productDetails']
                                                      ?['price'] ??
                                                  0.0) as num),
                                    ) < 500 ? 40 : 0)).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          showPaymentSuccessDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Center(
                          child: Text(
                            "Proceed to Checkout",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(
            child: Text(
              "No items in cart",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        },
      ),
    );
  }
}
