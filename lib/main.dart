// import 'package:ecommerce/features/auth/domain/usecases/continue_with_google_use_case.dart';
// import 'package:ecommerce/features/auth/domain/usecases/get_user_id_from_local.dart';
// import 'package:ecommerce/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
// import 'package:ecommerce/features/auth/domain/usecases/sign_out_use_case.dart';
// import 'package:ecommerce/features/auth/domain/usecases/sign_up_with_email_use_case.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
// import 'package:ecommerce/features/auth/presentation/pages/auth_screen.dart';
// import 'package:ecommerce/features/auth/presentation/pages/home_screen.dart';
// import 'package:ecommerce/features/auth/presentation/pages/profile_setup_screen.dart';
// import 'package:ecommerce/firebase_options.dart';
// import 'package:ecommerce/service_locator.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   setUpServiceLocator();
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
//             continueWithGoogleUseCase:
//                 ContinueWithGoogleUseCase(serviceLocator()),
//             signInWithEmailUseCase: SignInWithEmailUseCase(serviceLocator()),
//             signOutUseCase: SignOutUseCase(serviceLocator()),
//             signUpWithEmailUseCase: SignUpWithEmailUseCase(serviceLocator()),
//             getUserIdFromLocal: GetUserIdFromLocal(serviceLocator()),
//           )
//         ),
//       ],
//       child: MaterialApp(
//         title: 'E-Commerce App',
//         initialRoute: '/',
//         routes: {
//           '/': (context) => AuthScreen(),
//           '/profileSetup': (context) => ProfileSetupScreen(),
//           '/auth': (context) => AuthScreen(),
//           '/home': (context) => HomeScreen(),
//         },
//       ),
//     );
//   }
// }

import 'package:ecommerce/features/auth/domain/usecases/continue_with_google_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/get_user_id_from_local.dart';
import 'package:ecommerce/features/auth/domain/usecases/password_reset_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_up_with_email_use_case.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecommerce/features/auth/presentation/pages/auth_screen.dart';
import 'package:ecommerce/features/product/domain/usecases/add_to_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/fetch_prouct_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/get_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/get_favourite_products_id_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/remove_from_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/toggle_favourite_use_case.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:ecommerce/features/product/presentation/pages/bottom_navigation.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:ecommerce/features/profile/presentation/pages/profile_setup_screen.dart';
import 'package:ecommerce/firebase_options.dart';
import 'package:ecommerce/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpServiceLocator();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(  //bloc provide of Auth Feture
            continueWithGoogleUseCase:
                ContinueWithGoogleUseCase(serviceLocator()),
            signInWithEmailUseCase: SignInWithEmailUseCase(serviceLocator()),
            signOutUseCase: SignOutUseCase(serviceLocator()),
            signUpWithEmailUseCase: SignUpWithEmailUseCase(serviceLocator()),
            getUserIdFromLocal: GetUserIdFromLocal(serviceLocator()), 
            passwordResetUseCase: PasswordResetUseCase(serviceLocator()),
          )..add(CheckUserLoggedIn()),
        ),
        BlocProvider(   //bloc provider of Profile Feature
            create: (context) => ProfileBloc(
                checkProfileStatusUseCase: serviceLocator(),
                getProfileUseCase: serviceLocator(),
                saveProfileUseCase: serviceLocator(),
                updateProfileUseCase: serviceLocator()
            )
        ),
        BlocProvider(   //bloc provider of Product Feature
            create: (context) => ProductBloc(
               FetchProuctUseCase(serviceLocator()),
               GetFavouriteProductsIdUsecase(serviceLocator()),
               ToggleFavouriteUsecase(serviceLocator()),
            )
        ),
        //  BlocProvider(   //bloc provider of Cart Feature
        //     create: (context) => CartBloc(
        //        GetCartUseCase(serviceLocator()),
        //        AddToCartUseCase(serviceLocator()),
        //        RemoveFromCartUseCase(serviceLocator()),
        //     ),
        // ),
             BlocProvider(   //bloc provider of Cart Feature
            create: (context) => CartBloc(
               getCartUseCase: serviceLocator(),
               addToCartUseCase: serviceLocator(),
               removeFromCartUseCase: serviceLocator(),
               fetchProuctUseCase: serviceLocator(),
            )..add(FetchProductForCart()),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        //initialRoute: '/',
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return BottomNavigation();
            }  
          
            return AuthScreen();
           
          },
        ),
        routes: {
          '/profileSetup': (context) => ProfileSetupScreen(),
          '/auth': (context) => AuthScreen(),
          '/home': (context) => BottomNavigation(),
        },
      ),
    );
  }
}
 