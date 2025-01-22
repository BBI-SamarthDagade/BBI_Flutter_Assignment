import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),

      body:  Center(
        child:  Text(
        'Cart Screen',
        style: TextStyle(fontSize: 24),
      ),
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ecommerce/features/product/presentation/bloc/product_bloc.dart';

// class CartScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     context.read<ProductBloc>().add(LoadCart(FirebaseAuth.instance.currentUser!.uid));

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Cart"),
//       ),
//       body: BlocBuilder<ProductBloc, ProductState>(
//         builder: (context, state) {
//           if (state is CartLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is CartError) {
//             return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
//           } else if (state is CartLoaded) {
//             final cartItems = state.items;

//             if (cartItems.isEmpty) {
//               return Center(child: Text("Your cart is empty"));
//             }

//             return ListView.builder(
//               itemCount: cartItems.length,
//               itemBuilder: (context, index) {
//                 final item = cartItems[index];
//                 return ListTile(
//                   title: Text('Product ID: ${item['productId']}'),
//                   subtitle: Text('Quantity: ${item['quantity']}'),
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       context.read<ProductBloc>().add(
//                             RemoveFromCart(
//                               userId: FirebaseAuth.instance.currentUser!.uid,
//                               productId: item['productId'],
//                             ),
//                           );
//                     },
//                   ),
//                 );
//               },
//             );
//           }
//           return Center(child: Text("No items in cart"));
//         },
//       ),
//     );
//   }
// }
