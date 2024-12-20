import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/entity/task.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/add_task_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/delete_task_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/get_all_tasks_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/domain/usecases/update_task_use_case.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/presentation/bloc/task_event.dart';
import 'package:to_do_list_clean_arch/features/show_to_do/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState>{
  final AddTaskUseCase _addTask;
  final GetAllTasksUseCase _getAllTask;
  final DeleteTaskUseCase _deleteTask;
  final UpdateTaskUseCase _updateTask;

  TaskBloc({
  required AddTaskUseCase addTask,
  required GetAllTasksUseCase getAllTask,
  required DeleteTaskUseCase deleteTask,
  required UpdateTaskUseCase updateTask,
  }) : _addTask = addTask,
        _getAllTask = getAllTask,
        _deleteTask = deleteTask,
        _updateTask = updateTask,

    super(TaskInitial()) {
    on<TaskAdd>(_onTaskAdd);
    on<GetAllTasks>(_onGetAllTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTask>(_onUpdateTask);
    }
    

    List<Task> _tasks = [];

    // void addTask(Task task){
    //     add(TaskAdd(task: task));
    // }


    Future<void> _onTaskAdd(TaskAdd event, Emitter<TaskState> emit) async {
      emit(TaskLoading());
      
      int newId = _tasks.isEmpty ? 1 : _tasks.last.index + 1;
     
      Task task = Task(index: newId, task: event.title);

      final res = await _addTask.call(task);

      res.fold(
        (l){
          print("failure in add Task : ${l}");
          emit(TaskFailure(l.message));
        },
        (r){
           print("Success To Add Task");
          _tasks.add(task);
           add(GetAllTasks());   
           emit(TaskAddSuccess(_tasks));
        }
      );
    }

    void _onGetAllTask(GetAllTasks event, Emitter<TaskState> emit) async{
      print("Fetching Task......");

      emit(TaskLoading());

      final res = await _getAllTask.call();

      res.fold(
        (l){
          print("Failure to Fetching Task");
          emit(TaskFailure(l.message));
        },
        (r){
          print("Task Fetched Succefully");
          _tasks = r;
          emit(TaskGetSuccess(r));
        }
      );
    }
     

    void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
        emit(TaskLoading());

        final UpdateTask = event.task;
        
        final res = await _updateTask.call(UpdateTask);

        res.fold(
          (l){
            emit(TaskFailure(l.message));
          },
          (r){
            print("Task Updated Succefully");

            //indexWhere : if condition matches return index  else return -1
            int index = _tasks.indexWhere((task)=> task.index == event.task.index);

            if(index != -1){
              _tasks[index] = UpdateTask;

              emit(TaskUpdateSuccess());

            }else{
               emit(TaskFailure("Tasks not Found"));
            }
            
            add(GetAllTasks());  //refresh task list and get all updated tasks
          }
        );
    }

    void _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async{
        emit(TaskLoading());
        
        final res = await _deleteTask.call(index: event.index);

        res.fold(
          (l){
             emit(TaskFailure(l.message));
          },

          (r){
            print("Task Deleted Successfully");

            //Removes all elements in the list that satisfy a given condition        
            _tasks.removeWhere((task) => task.index == event.index);
            emit(TaskDeleteSuccess());

            add(GetAllTasks());  //refresh todo after delete
          }

        );
    }
    

 }