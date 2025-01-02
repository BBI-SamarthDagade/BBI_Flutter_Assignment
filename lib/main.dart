import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/pages/auth_page.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/pages/task_list_screen.dart';
import 'package:taskapp/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Setup service locator
  setupServiceLocator();

  // Check if user is already logged in
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');

  runApp(MyApp(userId: userId));
}

class MyApp extends StatelessWidget {
  final String? userId;

  const MyApp({this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(sl(), sl(), sl(), sl()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(addTaskUseCase: sl(), updateTaskUseCase: sl(), deleteTaskUseCase: sl(), getAllTasksUseCase: sl()),
        ),
      ],
      child: MaterialApp(
        home:userId == null ? const AuthScreen() : TaskListScreen(userId ?? " "),
      ),

    );
  }
}
