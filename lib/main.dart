import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/pages/auth_page.dart';
import 'package:taskapp/features/auth/presentation/pages/home_screen.dart';
import 'package:taskapp/features/auth/presentation/pages/login_screen.dart';
import 'package:taskapp/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   setupServiceLocator();
  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(sl(), sl()),
      child: MaterialApp(
        title: 'Task App',
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}