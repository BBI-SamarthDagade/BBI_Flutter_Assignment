import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:taskapp/features/auth/presentation/pages/auth_page.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_state.dart';
import 'package:taskapp/features/task/presentation/pages/add_task_screen.dart';
import 'package:taskapp/features/task/presentation/pages/task_list_screen.dart';

import '../../auth/presentation/pages/auth_page_test.dart';

// Mock class for TaskBloc
class MockTaskBloc extends Mock implements TaskBloc {}

void main() {
  late MockTaskBloc mockTaskBloc;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockTaskBloc = MockTaskBloc();
    mockAuthBloc = MockAuthBloc();

    // Mock the state as a stream
    when(() => mockTaskBloc.stream)
        .thenAnswer((_) => Stream.value(TaskLoading()));

    // Mock the current state
    when(() => mockTaskBloc.state).thenReturn(TaskLoading());

    when(() => mockAuthBloc.state).thenReturn(AuthLoading());
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>.value(value: mockTaskBloc),
        BlocProvider<AuthBloc>.value(value: mockAuthBloc),
      ],
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
          '/addTask': (context) {
            final arguments = ModalRoute.of(context)?.settings.arguments
                as Map<String, dynamic>;
            final userId = arguments['userId'] as String;
            return AddTaskScreen(userId);
          },
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

    testWidgets(
        'Verify that the profile avatar is functional and that all associated buttons are operational.',
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

    testWidgets('Check Navigate to Auth Screen after clicking on Sign Out button on alert box',
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

      expect(find.text('Confirm Sign Out'), findsOneWidget);
      expect(find.text('Are you sure you want to sign out?'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();

      expect(find.byType(AuthScreen), findsOneWidget);
    });

     testWidgets('Tapping the button dismisses the dialog and keeps the user on the TaskListScreen, confirming that the logout action is canceled.',
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

      expect(find.text('Confirm Sign Out'), findsOneWidget);
      expect(find.text('Are you sure you want to sign out?'), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(TaskListScreen), findsOneWidget);
    });

    testWidgets('check edit button works', (WidgetTester tester) async {
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
          controller.add(TaskLoaded(tasks)); // Emit loaded state with tasks
        });
        return controller.stream;
      });

      when(() => mockTaskBloc.state).thenReturn(TaskLoading());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks));
      await tester.pump();

      expect(find.text('Task 1'), findsOneWidget);

      final taskFinder = find.text('Task 1');

      // Now, we should find the parent widget containing the edit icon.
      // For instance, if the edit icon is within a ListTile, you can find it like this:
      final editIconFinder = find.descendant(
        of: find.ancestor(of: taskFinder, matching: find.byType(ListTile)),
        matching: find.byIcon(Icons.edit),
      );

      expect(editIconFinder, findsOneWidget);

      // Uncomment to perform the tap action and check navigation
      await tester.tap(editIconFinder);
      await tester.pumpAndSettle();
      expect(find.byType(AddTaskScreen), findsOneWidget);
    });

    testWidgets('check delete button works', (WidgetTester tester) async {
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
          controller.add(TaskLoaded(tasks)); // Emit loaded state with tasks
        });
        return controller.stream;
      });

      when(() => mockTaskBloc.state).thenReturn(TaskLoading());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks));
      await tester.pump();

      expect(find.text('Task 1'), findsOneWidget);

      final taskFinder = find.text('Task 1');

      // Now, we should find the parent widget containing the edit icon.
      // For instance, if the edit icon is within a ListTile, you can find it like this:
      final deleteIconFinder = find.descendant(
        of: find.ancestor(of: taskFinder, matching: find.byType(ListTile)),
        matching: find.byIcon(Icons.delete),
      );

      expect(deleteIconFinder, findsOneWidget);

      // Uncomment to perform the tap action and check navigation
      await tester.tap(deleteIconFinder);
      await tester.pumpAndSettle();

      expect(find.text('task1'), findsNothing);
    });
  });
}
