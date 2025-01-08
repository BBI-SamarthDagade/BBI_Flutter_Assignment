import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/domain/usecases/add_task_use_case.dart';
import 'package:taskapp/features/task/domain/usecases/delete_task_use_case.dart';
import 'package:taskapp/features/task/domain/usecases/get_all_tasks_use_case.dart';
import 'package:taskapp/features/task/domain/usecases/update_task_use_case.dart';
import 'package:taskapp/features/task/presentation/bloc/task_event.dart';
import 'package:taskapp/features/task/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  final AddTaskUseCase _addTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final GetAllTasksUseCase _getAllTasksUseCase;
  

  TaskBloc({
     required AddTaskUseCase addTaskUseCase,
     required UpdateTaskUseCase updateTaskUseCase,
     required DeleteTaskUseCase deleteTaskUseCase,
     required GetAllTasksUseCase getAllTasksUseCase,
  }) : _addTaskUseCase = addTaskUseCase,
       _updateTaskUseCase = updateTaskUseCase,
       _deleteTaskUseCase = deleteTaskUseCase,
       _getAllTasksUseCase = getAllTasksUseCase,

       super(TaskInitial()){
          on<AddTaskEvent>(_onAddTask);
          on<UpdateTaskEvent>(_onUpdateTask);
          on<DeleteTaskEvent>(_onDeleteTask);
          on<LoadTasksEvent>(_onFetchTask);
       }
 

       List<TaskEntity> _tasks = [];

    
    List<TaskEntity> _sortTasksByDueDate(List<TaskEntity> tasks){
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return tasks;
    }


    Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async{
      emit(TaskLoading());

      final res = await _addTaskUseCase.call(event.task, event.userId);

      res.fold(
         (l){
            emit(TaskFailure(l.message));
         }, 
         (r){
            _tasks.add(event.task);
            _tasks = _sortTasksByDueDate(_tasks);
            emit(TaskLoaded(_tasks));
         }
      );
    }


    Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async{
      final res = await _updateTaskUseCase.call(event.task, event.userId);

      res.fold(
         (l){
            emit(TaskFailure(l.message));
         }, 
         (r){
            _tasks = _tasks.map((task){
               return task.taskId == event.task.taskId ? event.task : task;
            }).toList();

            _tasks = _sortTasksByDueDate(_tasks);
            emit(TaskLoaded(_tasks));
         }
      );
    }

   
   Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final res = await _deleteTaskUseCase.call(event.taskId, event.userId);

    res.fold(
      (l) => emit(TaskFailure(l.message)),
      (r) {
        // Remove the task from the sorted list
       _tasks.removeWhere((task) => task.taskId == event.taskId);
    
       
        emit(TaskLoaded(_tasks));
      },
    );
  }
  
    // Handle fetching tasks
  Future<void> _onFetchTask( LoadTasksEvent event, Emitter<TaskState> emit) async {

    emit(TaskLoading());
    final res = await _getAllTasksUseCase.call(event.userId);
    res.fold(
      (l){
        emit(TaskFailure(l.message));
      },
      (r) {
         _tasks = _sortTasksByDueDate(r);
        emit(TaskLoaded(_tasks));
      },
    );
  }
  
}