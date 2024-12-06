import 'package:flutter/material.dart';
//fimport 'package:fintness/widgets/todo_item.dart';

class Home extends StatelessWidget {
  AppBar _buildAppbar() {
    return AppBar(
     
    );
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),

        body: Center(
          child: Text(
            "Welcome To Home",
          ),
        ),
    );
  }
}
