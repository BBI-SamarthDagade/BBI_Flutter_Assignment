

import 'package:ecommerce/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecommerce/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce/features/auth/domain/usecases/continue_with_google_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_up_with_email_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> setUpServiceLocator() async {

   //shared preferance
   final sharedPreferences = await SharedPreferences.getInstance();
   serviceLocator.registerLazySingleton(()=> sharedPreferences);

   //Firebase Auth
   serviceLocator.registerLazySingleton<FirebaseAuth>(()=> FirebaseAuth.instance);
    
   //Google Auth Provider
   serviceLocator.registerLazySingleton<GoogleAuthProvider>(() => GoogleAuthProvider());
    
   //data source of Auth
   serviceLocator.registerLazySingleton<AuthLocalDataSource>(()=> AuthLocalDataSourceImplementation(serviceLocator()));
   serviceLocator.registerLazySingleton<AuthRemoteDataSource>(()=>AuthRemoteDataSourceImpl(serviceLocator(),serviceLocator(),serviceLocator()));
   
  //Auth Repository
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(serviceLocator()));

  //use cases of Auth
  serviceLocator.registerLazySingleton(() => SignInWithEmailUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignUpWithEmailUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => ContinueWithGoogleUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignOutUseCase(serviceLocator()));
}  