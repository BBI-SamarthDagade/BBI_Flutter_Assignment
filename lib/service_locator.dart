import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/data/data_source/task_local_data_source.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/data/repository/task_repo_impl.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/repository/task_repo.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/add_task_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/delete_task_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/get_all_tasks_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/update_task_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/presentation/bloc/task_bloc.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // Register Local Data Source
  serviceLocator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(sharedPreferences: sharedPreferences),
  );

  // Register Repositories
  serviceLocator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImplementation(localDataSource: serviceLocator()),
  );

  // Register Use Cases
  serviceLocator.registerLazySingleton(() => AddTaskUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetAllTasksUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteTaskUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateTaskUseCase(serviceLocator()));



    serviceLocator.registerFactory(
    () => TaskBloc(
      
      addTask: serviceLocator(),
      getAllTask: serviceLocator(),
      deleteTask: serviceLocator(),
      updateTask:  serviceLocator(),
    ),
  );
}
