// import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';


// class HomePage extends StatelessWidget {
//   final List<Map<String, dynamic>> products = [
//     {
//       'name': 'Smartphone',
//       'price': 699,
//     },
//     {
//       'name': 'Laptop',
//       'price': 1299,
//     },
//     {
//       'name': 'Headphones',
//       'price': 199,
//     },
//     {
//       'name': 'Smartwatch',
//       'price': 299,
//     },
//     {
//       'name': 'Tablet',
//       'price': 499,
//     },
//     {
//       'name': 'Camera',
//       'price': 899,
//     },
//     {
//       'name': 'Wireless Charger',
//       'price': 49,
//     },
//     {
//       'name': 'Bluetooth Speaker',
//       'price': 129,
//     },
//     {
//       'name': 'Gaming Console',
//       'price': 499,
//     },
//     {
//       'name': 'Monitor',
//       'price': 299,
//     },
//     {
//       'name': 'Keyboard',
//       'price': 89,
//     },
//     {
//       'name': 'Mouse',
//       'price': 39,
//     },
//     // Add more products as needed
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Products'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               // Trigger the logout event
//               BlocProvider.of<AuthBloc>(context).add(SignOutEvent());

//               // Navigate to the AuthScreen
//               Navigator.pushReplacementNamed(context, '/auth');
//             },
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: GridView.builder(
//         padding: const EdgeInsets.all(8.0),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Two tiles in one row
//           childAspectRatio: 0.75, // Adjust the aspect ratio as needed
//           crossAxisSpacing: 8.0,
//           mainAxisSpacing: 8.0,
//         ),
//         itemCount: products.length,
//         itemBuilder: (context, index) {
//           return Card(
//             elevation: 4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Container(
//                     color: Colors.grey.shade200, // Placeholder for product image
//                     child: Center(
//                       child: Text(
//                         products[index]['name'],
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Price: \$${products[index]['price']}',
//                     style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {'name': 'Smartphone', 'price': 699},
    {'name': 'Laptop', 'price': 1299},
    {'name': 'Headphones', 'price': 199},
    {'name': 'Smartwatch', 'price': 299},
    {'name': 'Tablet', 'price': 499},
    {'name': 'Camera', 'price': 899},
    {'name': 'Wireless Charger', 'price': 49},
    {'name': 'Bluetooth Speaker', 'price': 129},
    {'name': 'Gaming Console', 'price': 499},
    {'name': 'Monitor', 'price': 299},
    {'name': 'Keyboard', 'price': 89},
    {'name': 'Mouse', 'price': 39},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Trigger the logout event
              BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
              // Navigate to the AuthScreen
              Navigator.pushReplacementNamed(context, '/auth');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two tiles in one row
          childAspectRatio: 0.8, // Adjust the aspect ratio as needed
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey.shade200, // Placeholder for product image
                    child: Center(
                      child: Text(
                        products[index]['name'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Price: \$${products[index]['price']}',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: Colors.red),
                      onPressed: () {
                        // Handle Wishlist Logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${products[index]['name']} added to Wishlist'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.shopping_bag, color: Colors.green),
                      onPressed: () {
                        // Handle Buy Now Logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Proceeding to buy ${products[index]['name']}'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.shopping_cart, color: Colors.blue),
                      onPressed: () {
                        // Handle Cart Logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${products[index]['name']} added to Cart'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
