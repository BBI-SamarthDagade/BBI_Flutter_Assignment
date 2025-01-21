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


// import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomePage extends StatelessWidget {
//   final List<Map<String, dynamic>> products = [
//     {'name': 'Smartphone', 'price': 699},
//     {'name': 'Laptop', 'price': 1299},
//     {'name': 'Headphones', 'price': 199},
//     {'name': 'Smartwatch', 'price': 299},
//     {'name': 'Tablet', 'price': 499},
//     {'name': 'Camera', 'price': 899},
//     {'name': 'Wireless Charger', 'price': 49},
//     {'name': 'Bluetooth Speaker', 'price': 129},
//     {'name': 'Gaming Console', 'price': 499},
//     {'name': 'Monitor', 'price': 299},
//     {'name': 'Keyboard', 'price': 89},
//     {'name': 'Mouse', 'price': 39},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Products'),
//         automaticallyImplyLeading: false,
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
//           childAspectRatio: 0.8, // Adjust the aspect ratio as needed
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
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.favorite_border, color: Colors.red),
//                       onPressed: () {
//                         // Handle Wishlist Logic
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('${products[index]['name']} added to Wishlist'),
//                             duration: Duration(seconds: 2),
//                           ),
//                         );
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.shopping_bag, color: Colors.green),
//                       onPressed: () {
//                         // Handle Buy Now Logic
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Proceeding to buy ${products[index]['name']}'),
//                             duration: Duration(seconds: 2),
//                           ),
//                         );
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.shopping_cart, color: Colors.blue),
//                       onPressed: () {
//                         // Handle Cart Logic
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('${products[index]['name']} added to Cart'),
//                             duration: Duration(seconds: 2),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ecommerce/features/product/presentation/bloc/product_bloc.dart';

// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//     void initState() {
//     super.initState();
//     // Dispatch GetProductEvent when the widget is initialized
//     context.read<ProductBloc>().add(GetProductEvent());
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       appBar: AppBar(
//         title: Text('Products'),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
//               Navigator.pushReplacementNamed(context, '/auth');
//             },
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: BlocBuilder<ProductBloc, ProductState>(
      
//         builder: (context, state) {
//           if (state is ProductLoading) {
//             return Center(child: CircularProgressIndicator());
//           } else if (state is ProductError) {
//             return Center(
//               child: Text(state.message, style: TextStyle(color: Colors.red)),
//             );
//           } else if (state is ProductLoaded) {
//             final products = state.products;
             
//             return Column(
//               children: [
//                 // Carousel Slider for Featured Products
//                 CarouselSlider(
//                   items: products.take(5).map((product) {
//                     return Container(
//                       margin: EdgeInsets.symmetric(horizontal: 5.0),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(10.0),
//                         image: DecorationImage(
//                           image: NetworkImage(product.image),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       child: Container(
//                         alignment: Alignment.bottomCenter,
//                         padding: EdgeInsets.all(8.0),
//                         color: Colors.black.withOpacity(0.6),
//                         child: Text(
//                           product.title,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   options: CarouselOptions(
//                     height: 200.0,
//                     autoPlay: true,
//                     enlargeCenterPage: true,
//                   ),
//                 ),

//                 // GridView for All Products
//                 Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.all(8.0),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 0.8,
//                       crossAxisSpacing: 8.0,
//                       mainAxisSpacing: 8.0,
//                     ),
//                     itemCount: products.length,
//                     itemBuilder: (context, index) {
//                       return Card(
//                         elevation: 4,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   image: DecorationImage(
//                                     image: NetworkImage(products[index].image),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 products[index].title,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                               child: Text(
//                                 'Price: \$${products[index].price.toStringAsFixed(2)}',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey.shade600,
//                                 ),
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.favorite_border, color: Colors.red),
//                                   onPressed: () {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('${products[index].title} added to Wishlist'),
//                                         duration: Duration(seconds: 2),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.shopping_bag, color: Colors.green),
//                                   onPressed: () {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('Proceeding to buy ${products[index].title}'),
//                                         duration: Duration(seconds: 2),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.shopping_cart, color: Colors.blue),
//                                   onPressed: () {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('${products[index].title} added to Cart'),
//                                         duration: Duration(seconds: 2),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return Center(
//               child: Text('No products available'),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce/features/product/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/features/product/presentation/bloc/product_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Dispatch GetProductEvent when the widget is initialized
    context.read<ProductBloc>().add(GetProductEvent());
  }

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
              BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
              Navigator.pushReplacementNamed(context, '/auth');
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProductError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: Colors.red)),
            );
          } else if (state is ProductLoaded) {
            final products = state.products;

            return Column(
              children: [
                // Carousel Slider for Featured Products
                CarouselSlider(
                  items: products.take(5).map((product) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(product: product),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage(product.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.all(8.0),
                          color: Colors.black.withOpacity(0.6),
                          child: Text(
                            product.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                ),

                // GridView for All Products
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns
                      childAspectRatio: 0.75, // Adjust for product card proportions
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(product: product),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.favorite_border, color: Colors.red),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${product.title} added to Wishlist', style: TextStyle(color: Colors.black),),
                                          backgroundColor: Colors.red[300],
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.shopping_cart, color: Colors.blue),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${product.title} added to Cart',  style: TextStyle(color: Colors.black),),
                                          backgroundColor: Colors.lightBlue[300],
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.shopping_bag, color: Colors.green),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Proceeding to buy ${product.title}', style: TextStyle(color: Colors.black),),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text('No products available'),
            );
          }
        },
      ),
    );
  }
}
