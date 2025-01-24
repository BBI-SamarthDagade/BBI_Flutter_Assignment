

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecommerce/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce/features/auth/domain/usecases/continue_with_google_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/password_reset_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_up_with_email_use_case.dart';
import 'package:ecommerce/features/product/data/data_source/remote_data_source.dart';
import 'package:ecommerce/features/product/data/repositories/product_repo_impl.dart';
import 'package:ecommerce/features/product/domain/repositories/product_repository.dart';
import 'package:ecommerce/features/product/domain/usecases/add_to_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/fetch_prouct_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/get_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/get_favourite_products_id_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/remove_from_cart_use_case.dart';
import 'package:ecommerce/features/product/domain/usecases/toggle_favourite_use_case.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce/features/product/presentation/bloc/cart_event.dart';
import 'package:ecommerce/features/product/presentation/bloc/product_bloc.dart';
import 'package:ecommerce/features/profile/data/datasouce/profile_remote_data_source.dart';
import 'package:ecommerce/features/profile/data/repositories/profile_repo_impl.dart';
import 'package:ecommerce/features/profile/domain/repository/profile_repository.dart';
import 'package:ecommerce/features/profile/domain/usecase/check_profile_status_use_case.dart';
import 'package:ecommerce/features/profile/domain/usecase/get_profile_use_case.dart';
import 'package:ecommerce/features/profile/domain/usecase/save_profile_use_case.dart';
import 'package:ecommerce/features/profile/domain/usecase/update_profile_use_case.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(serviceLocator(), serviceLocator()));

  //use cases of Auth
  serviceLocator.registerLazySingleton(() => SignInWithEmailUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignUpWithEmailUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => ContinueWithGoogleUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignOutUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => PasswordResetUseCase(serviceLocator()));


  //Profile Feature

  //profile remote data source
  serviceLocator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);  
  serviceLocator.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  serviceLocator.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      serviceLocator(), serviceLocator(),
    ),
  );
  
  //profile repository
  serviceLocator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepoImpl(
    serviceLocator(),
    ),
  );
  
  //profile use case
  serviceLocator.registerLazySingleton<CheckProfileStatusUseCase>(
    () => CheckProfileStatusUseCase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<SaveProfileUseCase>(
    () => SaveProfileUseCase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(
      serviceLocator(),
    ),
  );

  //profile bloc
  serviceLocator.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      saveProfileUseCase: serviceLocator(),
      updateProfileUseCase: serviceLocator(),
      getProfileUseCase: serviceLocator(),
      checkProfileStatusUseCase: serviceLocator(),
    ),
  );

  //product feature
  //data source  of product
  serviceLocator.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(http.Client(), serviceLocator()));
   
  //Repository of product
  serviceLocator.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(serviceLocator()));
  
  //use case of product
  serviceLocator.registerLazySingleton<FetchProuctUseCase>(() => FetchProuctUseCase(serviceLocator()));
  
  //use case of cart
  serviceLocator.registerLazySingleton<GetCartUseCase>(() => GetCartUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton<AddToCartUseCase>(() => AddToCartUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton<RemoveFromCartUseCase>(() => RemoveFromCartUseCase(serviceLocator()));
  
  //use case of wishlist
  serviceLocator.registerLazySingleton<GetFavouriteProductsIdUsecase>(() => GetFavouriteProductsIdUsecase(serviceLocator()));
  serviceLocator.registerLazySingleton<ToggleFavouriteUsecase>(() => ToggleFavouriteUsecase(serviceLocator()));


  //bloc of product
  serviceLocator.registerFactory(() => ProductBloc(serviceLocator(), serviceLocator(), serviceLocator()));

  //bloc of cart
  serviceLocator.registerFactory(() => CartBloc(getCartUseCase:  serviceLocator(), addToCartUseCase: serviceLocator(), removeFromCartUseCase: serviceLocator(), fetchProuctUseCase: serviceLocator()));

}  