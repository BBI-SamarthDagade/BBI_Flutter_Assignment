import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskapp/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:taskapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:taskapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:taskapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:taskapp/features/auth/domain/usecases/create_user_use_case.dart';
import 'package:taskapp/features/auth/domain/usecases/get_user_id_user_case.dart';
import 'package:taskapp/features/auth/domain/usecases/log_out_user_use_case.dart';
import 'package:taskapp/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:taskapp/features/task/data/datasources/task_remote_data_source.dart';
import 'package:taskapp/features/task/data/repositories/task_repository_impl.dart';
import 'package:taskapp/features/task/domain/repositories/task_repository.dart';
import 'package:taskapp/features/task/domain/usecases/add_task_use_case.dart';
import 'package:taskapp/features/task/domain/usecases/delete_task_use_case.dart';
import 'package:taskapp/features/task/domain/usecases/get_all_tasks_use_case.dart';
import 'package:taskapp/features/task/domain/usecases/update_task_use_case.dart';


final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
   

   //shared preferance
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  //firebase
  sl.registerLazySingleton<FirebaseDatabase>(() => FirebaseDatabase.instance);

  
  //sl() checks the GetIt registry to find an instance of SharedPreferences (or any other registered dependency) and passes it to the constructor.
  // Data sources of Auth
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImplementation(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImplementation(sl(),sl()));
  
  //Other parts of your app only need to know about the interface (AuthRepository), not the concrete implementation (AuthRepositoryImpl).
  // Repository of Auth
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));

  // Use cases of Auth
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => LogOutUserUseCase(sl()));
  sl.registerLazySingleton(()=> GetUserIdUseCase(sl()));
   
  //Data Source of Task
  sl.registerLazySingleton<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImplementation(sl()));
 
  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImplmentation(sl()));


    // Use cases of Task
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
  sl.registerLazySingleton(()=> GetAllTasksUseCase(sl()));
   

}

// GetIt is a lightweight dependency injection (DI) package in Dart. It acts as a 
// Service Locator, allowing you to register and retrieve dependencies 
// (like services, repositories, or objects) globally in your application.
  
//    > flutter pub add get_it 
   
// final sl = GetIt.instance;  assign instance of get it to the sl

// GetIt.instance provides the singleton(only one instance throught the app exist) instance of GetIt.

// sl.registerLazySingleton(()=> sharedPreferances);
// The instance is created only once, the first time it’s accessed.
// The same instance is reused whenever it’s needed.

// sl() checks the GetIt registry to find an instance of SharedPreferences (or any other registered dependency) and passes it to the constructor.

// Other parts of your app only need to know about the interface (AuthRepository), not the concrete implementation (AuthRepositoryImpl).