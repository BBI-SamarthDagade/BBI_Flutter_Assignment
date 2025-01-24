// import 'package:flutter/material.dart';

// class WishlistScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Wishlist"),
//       ),

//       body:  Center(
//         child:  Text(
//         'Wish List Screen',
//         style: TextStyle(fontSize: 24),
//       ),
//       ),
//     );
//   }
// }

import 'package:ecommerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:ecommerce/features/product/presentation/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.favorite,
              color: Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 15),
            const Text(
              "Wish List",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              final favoriteProducts = state.products
                  .where((product) => product.isFavorite)
                  .toList();

              return favoriteProducts.isEmpty
                  ? const Center(child: Text("No items in wishlist"))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: favoriteProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: favoriteProducts[index],
                          bgColor: Colors
                              .primaries[index % favoriteProducts.length]
                              .withOpacity(0.1),
                        );
                      },
                    );
            } else if (state is ProductError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
