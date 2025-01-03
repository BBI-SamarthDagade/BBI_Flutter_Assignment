import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_event.dart';
import 'package:taskapp/features/task/presentation/bloc/task_state.dart';
import 'package:taskapp/features/task/presentation/pages/add_task_screen.dart';
import 'package:taskapp/features/task/presentation/pages/task_list_screen.dart';

// Mock classes for AuthBloc and TaskBloc
class MockAuthBloc extends Mock implements AuthBloc {}
class MockTaskBloc extends Mock implements TaskBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockTaskBloc mockTaskBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockTaskBloc = MockTaskBloc();
  });

  Widget createWidgetUnderTest() {
    return BlocProvider.value(
      value: mockTaskBloc,
      child: BlocProvider.value(
        value: mockAuthBloc,
        child: MaterialApp(home: TaskListScreen('userId')),
      ),
    );
  }

  group('TaskListScreen', () {
    // testWidgets('shows loading indicator when tasks are loading', (WidgetTester tester) async {
    //   when(() => mockTaskBloc.state).thenReturn(TaskLoading());

    //   await tester.pumpWidget(createWidgetUnderTest());

    //   expect(find.text("Loading Tasks....."), findsOneWidget);
    //   expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // });

    // testWidgets('shows logout button', (WidgetTester tester) async {
    //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: []));

    //   await tester.pumpWidget(createWidgetUnderTest());

    //   expect(find.byIcon(Icons.logout), findsOneWidget);
    // });

    // testWidgets('logs out user on logout button tap', (WidgetTester tester) async {
    //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: []));

    //   await tester.pumpWidget(createWidgetUnderTest());

    //   await tester.tap(find.byIcon(Icons.logout));
    //   await tester.pumpAndSettle();

    //   verify(() => mockAuthBloc.add(LogoutEvent(AuthEntity(userId: 'userId')))).called(1);
    // });

    // testWidgets('shows no tasks message when task list is empty', (WidgetTester tester) async {
    //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: []));

    //   await tester.pumpWidget(createWidgetUnderTest());

    //   expect(find.text("No tasks added"), findsOneWidget);
    // });

    // testWidgets('displays tasks when loaded', (WidgetTester tester) async {
    //   final tasks = [
    //     TaskEntity('1', 'Task 1', 'Description 1', DateTime.now(), Priority.high),
    //     TaskEntity('2', 'Task 2', 'Description 2', DateTime.now(), Priority.low),
    //   ];
    //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: tasks));

    //   await tester.pumpWidget(createWidgetUnderTest());

    //   expect(find.text('Task 1'), findsOneWidget);
    //   expect(find.text('Task 2'), findsOneWidget);
    // });

    // testWidgets('sorts tasks correctly when a sorting option is selected', (WidgetTester tester) async {
    //   final tasks = [
    //     TaskEntity('1', 'Task 1', 'Description 1', DateTime.now().add(Duration(days: 1)), Priority.high),
    //     TaskEntity('2', 'Task 2', 'Description 2', DateTime.now(), Priority.low),
    //   ];
    //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: tasks));

    //   await tester.pumpWidget(createWidgetUnderTest());

    //   await tester.tap(find.byType(PopupMenuButton<String>));
    //   await tester.tap(find.text('Sort by Due Date'));
    //   await tester.pump();

    //   // Check if tasks are sorted by due date
    //   expect(find.text('Task 2'), findsOneWidget);
    //   expect(find.text('Task 1'), findsOneWidget); // Verify the order
    // });

    // testWidgets('dismisses a task and triggers delete event', (WidgetTester tester) async {
    //   final tasks = [
    //     TaskEntity('1', 'Task 1', 'Description 1', DateTime.now(), Priority.high),
    //   ];
    //   when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks: tasks));

    //   await tester.pumpWidget(createWidgetUnderTest());

    //   await tester.drag(find.text('Task 1'), Offset(-500, 0)); // Swipe left to dismiss
    //   await tester.pumpAndSettle();

    //   verify(() => mockTaskBloc.add(DeleteTaskEvent('1', 'userId'))).called(1);
    // });

    testWidgets('navigates to AddTaskScreen on floating action button tap', (WidgetTester tester) async {
      final tasks = [
        TaskEntity('1', 'Task 1', 'Description 1', DateTime.now(), Priority.high),
      ];
      when(() => mockTaskBloc.state).thenReturn(TaskLoaded(tasks));

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify navigation to AddTaskScreen (you may need to adjust based on your navigation logic)
      expect(find.byType(AddTaskScreen), findsOneWidget);
    });
  });
}
