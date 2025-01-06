// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
// import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
// import 'package:taskapp/features/auth/presentation/bloc/auth_state.dart';
// import 'package:taskapp/features/task/presentation/pages/task_list_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _userIdController = TextEditingController();

//   @override
//   void dispose() {
//     _userIdController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login"),
//       ),
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthSuccess) {
//             // ScaffoldMessenger.of(context).showSnackBar(
//             //   SnackBar(content: Text("Successfully Logged In")),
//             // );
//           } else if (state is AuthFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.error)),
//             );
//           } 
//           else if (state is AuthLoaded) {
     
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 // builder: (context) => HomeScreen(userId: state.auth.userId),
//                  builder: (context) => TaskListScreen(state.auth.userId),
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is AuthLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextField(
//                   controller: _userIdController,
//                   decoration: const InputDecoration(
                    
//                     labelText: "Enter User ID",
//                     icon: Icon(Icons.person),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     final userId = _userIdController.text.trim();
//                     if (userId.isNotEmpty) {
//                       final auth = AuthEntity(userId: userId);
//                       context.read<AuthBloc>().add(LoginUserEvent(auth));
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Please enter a valid User ID")),
//                       );
//                     }
//                   },
//                   child: const Text("Submit"),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

//named route
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:taskapp/features/task/presentation/pages/task_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text("Successfully Logged In")),
            // );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } 
          else if (state is AuthLoaded) {
     
            
            Navigator.pushReplacementNamed(context, '/taskList',
            arguments: {
              "userId":state.auth.userId
            }
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _userIdController,
                  decoration: const InputDecoration(
                    
                    labelText: "Enter User ID",
                    icon: Icon(Icons.person, size: 40),
                    iconColor: Colors.lightBlue,
                    
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final userId = _userIdController.text.trim();
                    print("in login view");
                    print(userId);
                    if (userId.isNotEmpty) {
                      final auth = AuthEntity(userId: userId);
                      context.read<AuthBloc>().add(LoginUserEvent(auth));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter a valid User ID")),
                      );
                    }
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}