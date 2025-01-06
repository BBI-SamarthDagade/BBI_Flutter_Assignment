// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:taskapp/features/task/domain/entities/task_entity.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_state.dart';
// import 'package:taskapp/features/task/presentation/pages/add_task_screen.dart';
// import 'package:taskapp/features/task/presentation/pages/task_list_screen.dart';

// // Mock classes for AuthBloc and TaskBloc
// class MockAuthBloc extends Mock implements AuthBloc {}
// class MockTaskBloc extends Mock implements TaskBloc {}

// void main() {
//   late MockAuthBloc mockAuthBloc;
//   late MockTaskBloc mockTaskBloc;

//   setUp(() {
//     mockAuthBloc = MockAuthBloc();
//     mockTaskBloc = MockTaskBloc();
//   });

//   Widget createWidgetUnderTest() {
//     return BlocProvider.value(
//       value: mockTaskBloc,
//       child: BlocProvider.value(
//         value: mockAuthBloc,
//         child: MaterialApp(home: TaskListScreen('userId')),
//       ),
//     );
//   }

//   group('TaskListScreen', () {

//     // testWidgets('shows loading indicator when tasks are loading', (WidgetTester tester) async {

//     //   when(() => mockTaskBloc.state).thenReturn(TaskLoading());

//     //   await tester.pumpWidget(createWidgetUnderTest());

//     //   //expect(find.text("Loading Tasks....."), findsOneWidget);
//     //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
//     // });

//     // testWidgets('shows logout button', (WidgetTester tester) async {
//     //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: []));

//     //   await tester.pumpWidget(createWidgetUnderTest());

//     //   expect(find.byIcon(Icons.logout), findsOneWidget);
//     // });

//     // testWidgets('logs out user on logout button tap', (WidgetTester tester) async {
//     //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: []));

//     //   await tester.pumpWidget(createWidgetUnderTest());

//     //   await tester.tap(find.byIcon(Icons.logout));
//     //   await tester.pumpAndSettle();

//     //   verify(() => mockAuthBloc.add(LogoutEvent(AuthEntity(userId: 'userId')))).called(1);
//     // });

//     // testWidgets('shows no tasks message when task list is empty', (WidgetTester tester) async {
//     //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: []));

//     //   await tester.pumpWidget(createWidgetUnderTest());

//     //   expect(find.text("No tasks added"), findsOneWidget);
//     // });

//     // testWidgets('displays tasks when loaded', (WidgetTester tester) async {
//     //   final tasks = [
//     //     TaskEntity('1', 'Task 1', 'Description 1', DateTime.now(), Priority.high),
//     //     TaskEntity('2', 'Task 2', 'Description 2', DateTime.now(), Priority.low),
//     //   ];
//     //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: tasks));

//     //   await tester.pumpWidget(createWidgetUnderTest());

//     //   expect(find.text('Task 1'), findsOneWidget);
//     //   expect(find.text('Task 2'), findsOneWidget);
//     // });

//     // testWidgets('sorts tasks correctly when a sorting option is selected', (WidgetTester tester) async {
//     //   final tasks = [
//     //     TaskEntity('1', 'Task 1', 'Description 1', DateTime.now().add(Duration(days: 1)), Priority.high),
//     //     TaskEntity('2', 'Task 2', 'Description 2', DateTime.now(), Priority.low),
//     //   ];
//     //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: tasks));

//     //   await tester.pumpWidget(createWidgetUnderTest());

//     //   await tester.tap(find.byType(PopupMenuButton<String>));
//     //   await tester.tap(find.text('Sort by Due Date'));
//     //   await tester.pump();

//     //   // Check if tasks are sorted by due date
//     //   expect(find.text('Task 2'), findsOneWidget);
//     //   expect(find.text('Task 1'), findsOneWidget); // Verify the order
//     // });

//     // testWidgets('dismisses a task and triggers delete event', (WidgetTester tester) async {
//     //   final tasks = [
//     //     TaskEntity('1', 'Task 1', 'Description 1', DateTime.now(), Priority.high),
//     //   ];
//     //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: tasks));

//     //   await tester.pumpWidget(createWidgetUnderTest());

//     //   await tester.drag(find.text('Task 1'), Offset(-500, 0)); // Swipe left to dismiss
//     //   await tester.pumpAndSettle();

//     //   verify(() => mockTaskBloc.add(DeleteTaskEvent('1', 'userId'))).called(1);
//     // });

//     testWidgets('navigates to AddTaskScreen on floating action button tap', (WidgetTester tester) async {
//       final tasks = [
//         TaskEntity('1', 'Task 1', 'Description 1', DateTime.now(), Priority.high),
//       ];
//       when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks));

//       await tester.pumpWidget(createWidgetUnderTest());

//       await tester.tap(find.byType(FloatingActionButton));
//       await tester.pumpAndSettle();

//       // Verify navigation to AddTaskScreen (you may need to adjust based on your navigation logic)
//       expect(find.byType(AddTaskScreen), findsOneWidget);
//     });
//   });
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
// import 'package:taskapp/features/auth/presentation/pages/auth_page.dart';
// import 'package:taskapp/features/task/domain/entities/task_entity.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
// import 'package:taskapp/features/task/presentation/bloc/task_state.dart';
// import 'package:taskapp/features/task/presentation/pages/add_task_screen.dart';
// import 'package:taskapp/features/task/presentation/pages/task_list_screen.dart';

// // Mock classes
// class MockTaskBloc extends Mock implements TaskBloc {}
// class MockAuthBloc extends Mock implements AuthBloc {}

// void main() {
//   late MockTaskBloc mockTaskBloc;

//   setUp(() {
//     mockTaskBloc = MockTaskBloc();
//   });

//   Widget createWidgetUnderTest() {
//     return BlocProvider<TaskBloc>.value(
//       value: mockTaskBloc,
//       child: MaterialApp(
//         home: TaskListScreen('test_user'),
//       ),
//     );
//   }

//   group('TaskListScreen', () {
//     testWidgets('displays loading indicator when tasks are loading', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: BlocProvider<TaskBloc>.value(
//             value: mockTaskBloc,
//             child: TaskListScreen('userId'),
//           ),
//         ),
//       );

//       await tester.pumpWidget(createWidgetUnderTest());

//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//     });

//     testWidgets('displays task list when tasks are loaded', (WidgetTester tester) async {
//       final tasks = [
//         TaskEntity( '1',  'Task 1','Description 1',  DateTime.now(),  Priority.high),
//         TaskEntity( '2',  'Task 2',  'Description 2',  DateTime.now(), Priority.medium),
//       ];

//       when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks));

//       await tester.pumpWidget(createWidgetUnderTest());

//       expect(find.text('Welcome, test_user'), findsOneWidget);
//       expect(find.text('Task 1'), findsOneWidget);
//       expect(find.text('Task 2'), findsOneWidget);
//     });

//     testWidgets('displays message when no tasks are present', (WidgetTester tester) async {
//   // Set the mock state to indicate that no tasks are loaded
//   when(() => mockTaskBloc.state).thenReturn(TaskLoaded([]));

//   await tester.pumpWidget(
//     MaterialApp(
//       home: BlocProvider<TaskBloc>.value(
//         value: mockTaskBloc,
//         child: TaskListScreen('userId'),
//       ),
//     ),
//   );

//   // Allow the widget to build with the state
//   await tester.pump();

//   // Check that the message is displayed
//   expect(find.text('No tasks added'), findsOneWidget);
// });

//     testWidgets('toggles sorting when sort buttons are pressed', (WidgetTester tester) async {
//       when(() => mockTaskBloc.state).thenReturn(TaskLoaded( []));

//       await tester.pumpWidget(createWidgetUnderTest());

//       await tester.tap(find.byIcon(Icons.sort_by_alpha));
//       await tester.pump();
//       expect(find.byIcon(Icons.calendar_today), findsOneWidget);

//       await tester.tap(find.byIcon(Icons.arrow_downward));
//       await tester.pump();
//       expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
//     });

//     testWidgets('navigates to add task screen on FAB tap', (WidgetTester tester) async {
//       when(() => mockTaskBloc.state).thenReturn(TaskLoaded( []));

//       await tester.pumpWidget(createWidgetUnderTest());

//       await tester.tap(find.byIcon(Icons.add));
//       await tester.pumpAndSettle();

//       expect(find.byType(AddTaskScreen), findsOneWidget);
//     });

//     testWidgets('navigates to profile screen on profile click', (WidgetTester tester) async {
//       when(() => mockTaskBloc.state).thenReturn(TaskLoaded( []));

//       await tester.pumpWidget(createWidgetUnderTest());

//       await tester.tap(find.byType(PopupMenuButton));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Profile'));
//       await tester.pumpAndSettle();

//       expect(find.byType(AuthScreen), findsOneWidget);
//     });

//     // testWidgets('signs out when sign out is clicked', (WidgetTester tester) async {
//     //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded([]));

//     //   await tester.pumpWidget(createWidgetUnderTest());

//     //   await tester.tap(find.byType(PopupMenuButton));
//     //   await tester.pumpAndSettle();

//     //   await tester.tap(find.text('Sign Out'));
//     //   await tester.pumpAndSettle();

//     //   verify(() => mockAuthBloc.add(LogoutEvent(AuthEntity(userId: 'test_user')))).called(1);
//     // });
//   });
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/features/auth/presentation/pages/auth_page.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_state.dart';
import 'package:taskapp/features/task/presentation/pages/add_task_screen.dart';
import 'package:taskapp/features/task/presentation/pages/task_list_screen.dart';

// Mock class for TaskBloc
class MockTaskBloc extends Mock implements TaskBloc {}

void main() {
  late MockTaskBloc mockTaskBloc;

  setUp(() {
    mockTaskBloc = MockTaskBloc();

    // Mock the state as a stream
    when(() => mockTaskBloc.stream)
        .thenAnswer((_) => Stream.value(TaskLoading()));

    // Mock the current state
    when(() => mockTaskBloc.state).thenReturn(TaskLoading());
  });

 Widget createWidgetUnderTest() {
    return BlocProvider<TaskBloc>.value(
      value: mockTaskBloc,
      child: MaterialApp(
        home: TaskListScreen('userId'),
        routes: {
          '/taskList': (context) {
            final arguments = ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>;
            final userId = arguments['userId'] as String;
            return TaskListScreen(userId ?? " ");
          },
          '/auth': (context) => AuthScreen(),
          '/addTask': (context) => AddTaskScreen('userId'),
        },
      ),
    );
  }  

  group('TaskListScreen', () {
    testWidgets('displays message when no tasks are present',
        (WidgetTester tester) async {
      // Set the state to Loaded with an empty list
      when(() => mockTaskBloc.state).thenReturn(TaskLoaded([]));
      when(() => mockTaskBloc.stream).thenAnswer((_) {
        // Create a stream that first emits loading, then emits loaded state
        final controller = StreamController<TaskState>();
        controller.add(TaskLoading()); // Emit loading first
        Future.delayed(Duration.zero, () {
          controller.add(TaskLoaded([])); // Then emit loaded with empty list
        });
        return controller.stream;
      });

      // Build the widget
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Wait for all animations to finish

      // Expect the message to be found
      expect(find.text('No tasks added'), findsOneWidget);
    });

    testWidgets('displays task list when tasks are loaded',
        (WidgetTester tester) async {
      final tasks = [
        TaskEntity(
            '1', 'Task 1', 'Description 1', DateTime.now(), Priority.high),
        TaskEntity(
            '2', 'Task 2', 'Description 2', DateTime.now(), Priority.medium),
      ];

      when(() => mockTaskBloc.stream).thenAnswer((_) {
        final controller = StreamController<TaskState>();
        controller.add(TaskLoading());
        Future.delayed(Duration.zero, () {
          controller.add(TaskLoaded(tasks));
        });
        return controller.stream;
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Wait for all animations to finish

      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
    });

    testWidgets('verify sorting functionality in Task App',
        (WidgetTester tester) async {
      final tasks = [
        TaskEntity(
            '1', 'Task 1', 'Description 1', DateTime.now(), Priority.high),
        TaskEntity(
            '2', 'Task 2', 'Description 2', DateTime.now(), Priority.medium),
      ];

      // Set up the stream to first emit loading, then emit loaded state
      when(() => mockTaskBloc.stream).thenAnswer((_) {
        final controller = StreamController<TaskState>();
        controller.add(TaskLoading());
        Future.delayed(Duration.zero, () {
          controller.add(TaskLoaded(tasks)); // Emit loaded state with tasks
        });
        return controller.stream;
      });

      // Start with loading state
      when(() => mockTaskBloc.state).thenReturn(TaskLoading());

      // Build the widget
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Update state to loaded
      when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks));
      await tester.pump();

      expect(find.byIcon(Icons.sort_by_alpha), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);

      await tester.tap(find.byIcon(Icons.sort_by_alpha));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);

      expect(find.text('Task 2'), findsOneWidget);
      expect(find.text('Task 1'), findsOneWidget);
    });

    testWidgets('Check floating action button works for adding tasks',
        (WidgetTester tester) async {
      final tasks = [
        TaskEntity(
            '1', 'Task 1', 'Description 1', DateTime.now(), Priority.high),
        TaskEntity(
            '2', 'Task 2', 'Description 2', DateTime.now(), Priority.medium),
      ];

      when(() => mockTaskBloc.stream).thenAnswer((_) {
        final controller = StreamController<TaskState>();
        controller.add(TaskLoading());
        controller.add(TaskLoaded(tasks)); // Emit loaded state immediately
        return controller.stream;
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(); // Wait for the navigation to complete

      // Debugging: Check if the widget tree contains AddTaskScreen
      final addTaskScreenFinder = find.byType(AddTaskScreen);
      expect(addTaskScreenFinder, findsOneWidget); // This should now pass
    });

    testWidgets('Check floating action button works for adding tasks',
        (WidgetTester tester) async {
      final tasks = [
        TaskEntity(
            '1', 'Task 1', 'Description 1', DateTime.now(), Priority.high),
        TaskEntity(
            '2', 'Task 2', 'Description 2', DateTime.now(), Priority.medium),
      ];

      when(() => mockTaskBloc.stream).thenAnswer((_) {
        final controller = StreamController<TaskState>();
        controller.add(TaskLoading());
        controller.add(TaskLoaded(tasks)); // Emit loaded state immediately
        return controller.stream;
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);

      await tester.tap(find.byType(CircleAvatar));
      await tester.pumpAndSettle(); // Wait for the navigation to complete

      expect(find.byIcon(Icons.account_circle), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.help), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

        testWidgets('Check floating action button works for adding tasks',
        (WidgetTester tester) async {
      final tasks = [
        TaskEntity(
            '1', 'Task 1', 'Description 1', DateTime.now(), Priority.high),
        TaskEntity(
            '2', 'Task 2', 'Description 2', DateTime.now(), Priority.medium),
      ];

      when(() => mockTaskBloc.stream).thenAnswer((_) {
        final controller = StreamController<TaskState>();
        controller.add(TaskLoading());
        controller.add(TaskLoaded(tasks)); // Emit loaded state immediately
        return controller.stream;
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);

      await tester.tap(find.byType(CircleAvatar));
     await tester.pumpAndSettle(); // Wait for the navigation to complete


         expect(find.byIcon(Icons.logout), findsOneWidget);
         await tester.tap(find.byIcon(Icons.logout));
         await tester.pumpAndSettle(); // Wait for the navigation to complete

     

      expect(find.byType(AuthScreen), findsOneWidget);
      
    });
  });
}
