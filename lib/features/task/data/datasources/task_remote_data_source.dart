import 'package:firebase_database/firebase_database.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
abstract class TaskRemoteDataSource {
  Future<void> addTask(String userId, TaskEntity task);
  Future<void> deleteTask(String taskId, String userId);
  Future<void> updateTask(String userId, TaskEntity task);
  Future<List<TaskEntity>> getTasks(String userId);
}


class TaskRemoteDataSourceImplementation extends TaskRemoteDataSource {
   
   //instace : is getter of static class FirebaseDatabase which give's singletone(only one) firebase realtime database instance
   //FirebaseDatabase database = FirebaseDatabase.instance;
  

  //ref() is gives the referance of specific location in Firebase Realtime Database
  //using this _taskRef we perform read write operations in Firebase Realtime Database
  
  final FirebaseDatabase _firebaseDatabase;
  
  TaskRemoteDataSourceImplementation(this._firebaseDatabase);
   


  DatabaseReference get _taskRef => _firebaseDatabase.ref('tasks');

  @override
  Future<void> addTask(String userId, TaskEntity task) async {
  try {
    // Generate a unique reference for the new task under the user's node
    final taskRef = _taskRef.child(userId).push();
    
    // Save the task data to the database
    await taskRef.set(task.toMap());

    print("Task added successfully for user $userId");
  } 
  catch (e) {
    // Handle any errors that occur during the operation
    print("Error adding task for user");
    throw e;
  }
}


  @override
  Future<void> deleteTask(String taskId, String userId)async{


    final userTaskRef = _taskRef.child(userId).child(taskId);

     
    try {
      await userTaskRef.remove();
      print("task with id $taskId of user $userId deleted succefully");
    } 
    catch (e) {
       print("Failed to delete task");
       throw e;
    }
    
  }

  @override
  Future<void> updateTask(String userId, TaskEntity task) async{

     final taskRef = _taskRef.child(userId).child(task.taskId.toString());
      
      try {
        await taskRef.update(task.toMap());
      } catch (e) {
         // Handle any errors during the update
         print("Failed to update task");
         throw e;
      }
  }
  
  @override
Future<List<TaskEntity>> getTasks(String userId) async {


  final userTaskRef = _taskRef.child(userId);

  try {

    // Retrieve a DataSnapshot from the database
    final DataSnapshot snapshot = await userTaskRef.get();
     
    // Check if data exists
    if (snapshot.exists) {
      // Convert the snapshot value to a map
      final tasksMap = Map<String, dynamic>.from(snapshot.value as Map);

      List<TaskEntity> tasks=[];
      
      tasksMap.forEach((id,taskData){
          tasks.add(TaskEntity.fromMap(taskData,id));
      });



      return tasks;
    } else {
      // Return an empty list if no tasks exist for the user
      return [];
    }
  } catch (e) {
    // Handle any errors that occur during the operation
    print("Failed to Fetch Task");
    throw e;
    return [];
  }
} 

}

//structre of Json in Firebase Realtime Database


// Tasks:{
//       	User1:[
          
//               Task(
//                    Id
//                    Title
//                    Description
//                    dueDate
//                    Priority
//                ),
 
//                Task(
//                    Id
//                    Title
//                    Description
//                    dueDate
//                    Priority
//                ),

//         ],

// 	User2:[
//               Task(
//                    Id
//                    Title
//                    Description
//                    dueDate
//                    Priority
//               )
//       ]
// }



