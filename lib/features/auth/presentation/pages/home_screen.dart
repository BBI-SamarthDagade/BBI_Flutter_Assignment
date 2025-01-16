import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
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
      body: Center(
        child: Text('Welcome to the Product Home Screen!'),
      ),
    );
  }
}
