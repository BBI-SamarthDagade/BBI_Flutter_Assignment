import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/product/presentation/pages/product_details_page.dart';
import 'package:ecommerce/features/product/presentation/widget/payment_success_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        title: Row(
          children: [
            Icon(Icons.shopping_bag, color: Colors.orange, size: 28),
            SizedBox(width: 8), // Add spacing
            Text(
              'Products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white, // Change the background color
        elevation: 4, // Add subtle shadow
        centerTitle: true, // Center the title
        actions: [
          // Add a custom-styled logout button
          GestureDetector(
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
              Navigator.pushReplacementNamed(context, '/auth');
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color:
                    Colors.redAccent.withOpacity(0.1), // Light red background
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red, size: 20),
                  SizedBox(width: 4), // Add spacing
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CarouselSlider(
                    items: products.take(5).map((product) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsPage(product: product),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                20.0), // More rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                    0.2), // Darker shadow for depth
                                blurRadius: 12.0,
                                offset: Offset(0, 6),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(product.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Gradient Overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(
                                            0.7), // Slightly darker gradient
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              // Product Title
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: Text(
                                  product.title,
                                  style: TextStyle(
                                    fontSize:
                                        20, // Increased font size for better readability
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 6.0,
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Price Tag
                              Positioned(
                                top: 15,
                                right: 15,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.orange
                                        .withOpacity(0.9), // Price tag color
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 250.0, // Slightly taller for better visuals
                      autoPlay: true,
                      autoPlayInterval:
                          Duration(seconds: 3), // Slightly faster transitions
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      viewportFraction:
                          0.9, // Slightly larger focus on the center item
                      scrollPhysics:
                          BouncingScrollPhysics(), // Smooth scrolling effect
                      autoPlayCurve: Curves.easeInOut, // Smooth animation curve
                      aspectRatio: 16 / 9, // Modern aspect ratio
                    ),
                  ),
                ),

                // GridView for All Products
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
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
                              builder: (context) =>
                                  ProductDetailsPage(product: product),
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
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(8)),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                                    icon: (product.isFavorite)
                                        ? Icon(Icons.favorite,
                                            color: Colors.red)
                                        : Icon(Icons.favorite_outline,
                                            color: Colors.red),
                                    onPressed: () {
                                      context
                                          .read<ProductBloc>()
                                          .add(ToggleFavoriteEvent(product.id));
                                    },
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      showPaymentSuccessDialog(context);
                                    }
                                  , icon: Icon(Icons.shopping_bag, color: Colors.lightGreen),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.shopping_cart,
                                        color: Colors.blue),
                                    onPressed: () {
                                      context.read<CartBloc>().add(
                                            AddToCart(
                                              userId: FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid, // Replace with dynamic user ID
                                              productId: product.id.toString(),
                                              quantity: 1,
                                            ),
                                          );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${product.title} added to Cart',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          backgroundColor:
                                              Colors.lightBlue[300],
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
