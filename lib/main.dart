import 'package:flutter/material.dart';
import 'package:to_do_list/to_do_list_screen.dart';

void main() => runApp(const ToDoApp());

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ToDoListScreen(),
    );
  }
}