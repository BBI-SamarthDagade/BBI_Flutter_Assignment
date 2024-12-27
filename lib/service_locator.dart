import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskapp/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:taskapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:taskapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:taskapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskapp/features/auth/domain/usecases/create_user_use_case.dart';
import 'package:taskapp/features/auth/domain/usecases/login_user_use_case.dart';


final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImplementation(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImplementation());

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));

  // Use cases
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
}
