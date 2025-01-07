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
   


  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
   sl.registerLazySingleton<FirebaseDatabase>(() => FirebaseDatabase.instance);


  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImplementation(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImplementation(sl(),sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));

  // Use cases
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => LogOutUserUseCase(sl()));
  sl.registerLazySingleton(()=> GetUserIdUseCase(sl()));
   
  //data source of task
  sl.registerLazySingleton<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImplementation(sl()));
 
  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImplmentation(sl()));


    // Use cases
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
  sl.registerLazySingleton(()=> GetAllTasksUseCase(sl()));
   

}
