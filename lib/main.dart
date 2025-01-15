import 'package:ecommerce/features/auth/domain/usecases/continue_with_google_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_up_with_email_use_case.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/presentation/pages/auth_screen.dart';
import 'package:ecommerce/features/auth/presentation/pages/home_screen.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServiceLocator();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            continueWithGoogleUseCase:
                ContinueWithGoogleUseCase(serviceLocator()),
            signInWithEmailUseCase: SignInWithEmailUseCase(serviceLocator()),
            signOutUseCase: SignOutUseCase(serviceLocator()),
            signUpWithEmailUseCase: SignUpWithEmailUseCase(serviceLocator()),
          )
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        initialRoute: '/',
        routes: {
          '/': (context) => AuthScreen(),
          '/home': (context) => HomeScreen(),
          '/auth': (context) => AuthScreen(),
        },
      ),
    );
  }
}







// import 'package:ecommerce/firebase_options.dart';
// import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
// import 'package:flutter/material.dart';

// void main() async {
//     WidgetsFlutterBinding.ensureInitialized();
//    // setUpServiceLocator();
//   // Initialize Firebase
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(MyApp());
// }



// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => AuthBloc(
//             continueWithGoogleUseCase: ContinueWithGoogleUseCase(serviceLocator()),
//             signInWithEmailUseCase: SignInWithEmailUseCase(serviceLocator()),
//             signOutUseCase: SignOutUseCase(serviceLocator()),
//             signUpWithEmailUseCase: SignUpWithEmailUseCase(serviceLocator()),
//           ),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'E-Commerce App',
//         initialRoute: '/',
//         routes: {
//           '/': (context) => AuthScreen(),
//           '/home': (context) => HomeScreen(),
//         },
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Home')),
//       body: Center(child: Text('Welcome to the Home Screen!')),
//     );
//   }
// }
