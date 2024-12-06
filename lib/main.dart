import 'package:flutter/material.dart';
import 'package:simple_counter_app/home_page.dart';  //importing home_page.dart

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      
      home:  HomePage(),

    );

  }
}