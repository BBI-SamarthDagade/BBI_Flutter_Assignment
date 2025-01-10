import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/pages/auth_page.dart';
import 'package:taskapp/features/auth/presentation/pages/login_screen.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/pages/add_task_screen.dart';
import 'package:taskapp/features/task/presentation/pages/help_screen.dart';
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


  print("user id inside main $userId");

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
          create: (BuildContext context) => TaskBloc(
            addTaskUseCase: sl(),
            updateTaskUseCase: sl(),
            deleteTaskUseCase: sl(),
            getAllTasksUseCase: sl(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Task App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => userId == null ? const AuthScreen() : TaskListScreen(userId!),
          
          '/addTask': (context) {
            final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
            final userId = arguments['userId'] as String;
            final task = arguments['task'] as TaskEntity?;
            return AddTaskScreen(userId,task: task);
          },

          '/auth': (context) => AuthScreen(),
          '/taskList': (context){ 
            final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
            final userId = arguments['userId'] as String;
            return TaskListScreen(userId ?? " ");
            },
          '/login' : (context) => LoginScreen(),
          '/help' : (context) => HelpPage(),
        }, 
      ),
    );
  }
}
