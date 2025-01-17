import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),

      body:  Center(
        child:  Text(
        'Profile Screen',
        style: TextStyle(fontSize: 24),
      ),
      ),
    );
  }
}