// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   final String userId;

//   const HomeScreen({super.key, required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Welcome, $userId"),
//       ),
//       body: Center(
//         child: Text("You are logged in to TaskScreen with $userId"),
//       ),
//     );
//   }
// }

//previous updated code
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:taskapp/features/auth/presentation/pages/auth_page.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $userId'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context
                  .read<AuthBloc>()
                  .add(LogoutEvent(AuthEntity(userId: userId)));
                  
              // Navigator.pushReplacementNamed(context, '/');

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Hello, $userId!'),
      ),
    );
  }
}
