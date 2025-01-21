import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
      ),

      body:  Center(
        child:  Text(
        'Wish List Screen',
        style: TextStyle(fontSize: 24),
      ),
      ),
    );
  }
}