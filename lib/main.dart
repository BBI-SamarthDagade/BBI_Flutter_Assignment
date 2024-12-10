// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/data/data_source/task_local_data_source.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/data/repository/task_repo_impl.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/add_task_use_case.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/delete_task_use_case.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/get_all_tasks_use_case.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/update_task_use_case.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/presentation/pages/add_task_screen.dart';
// import 'package:to_do_list_clean_arch/features/show_to_do/presentation/pages/task_screen.dart';

// void main() async {
//   // Ensure all bindings are initialized
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize SharedPreferences
//   final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

//   // Initialize data source
//   final TaskLocalDataSource localDataSource =
//       TaskLocalDataSourceImpl(sharedPreferences: sharedPreferences);

//   // Initialize repository with data source
//   final TaskRepositoryImplementation taskRepository =
//       TaskRepositoryImplementation(localDataSource: localDataSource);

//   // Initialize use cases
//   final AddTaskUseCase addTaskUseCase = AddTaskUseCase(taskRepository);
//   final GetAllTasksUseCase getAllTasksUseCase = GetAllTasksUseCase(taskRepository);
//   final DeleteTaskUseCase deleteTaskUseCase = DeleteTaskUseCase(taskRepository);
//   final UpdateTaskUseCase updateTaskUseCase = UpdateTaskUseCase(taskRepository);

//   // Run the app
//   runApp(MyApp(
//     addTaskUseCase: addTaskUseCase,
//     getAllTasksUseCase: getAllTasksUseCase,
//     deleteTaskUseCase: deleteTaskUseCase,
//     updateTaskUseCase: updateTaskUseCase,
//   ));
// }

// class MyApp extends StatelessWidget {
//   final AddTaskUseCase addTaskUseCase;
//   final GetAllTasksUseCase getAllTasksUseCase;
//   final DeleteTaskUseCase deleteTaskUseCase;
//   final UpdateTaskUseCase updateTaskUseCase;

//   const MyApp({
//     Key? key,
//     required this.addTaskUseCase,
//     required this.getAllTasksUseCase,
//     required this.deleteTaskUseCase,
//     required this.updateTaskUseCase,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'To-Do List',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: TaskScreen(
//         getAllTasksUseCase: getAllTasksUseCase,
//         deleteTaskUseCase: deleteTaskUseCase,
//         updateTaskUseCase: updateTaskUseCase,
//       ),
//       routes: {
//         '/add': (context) => AddTaskScreen(addTaskUseCase: addTaskUseCase),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/add_task_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/delete_task_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/get_all_tasks_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/update_task_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/presentation/bloc/task_bloc.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/presentation/bloc/task_event.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/presentation/pages/task_screen.dart';
import 'package:to_do_list_clean_arch/service_locator.dart';

void main() async {
  // Initialize the service locator
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      home: BlocProvider<TaskBloc>(
        create: (context) => TaskBloc(
          addTask: serviceLocator<AddTaskUseCase>(),
          getAllTask: serviceLocator<GetAllTasksUseCase>(),
          deleteTask: serviceLocator<DeleteTaskUseCase>(),
          updateTask: serviceLocator<UpdateTaskUseCase>(),
        )..add(GetAllTasks()),
        child: TaskScreen(),
      ),
    );
  }
}
