import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/features/task/domain/entities/task_entity.dart';
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/pages/add_task_screen.dart';

class MockTaskBloc extends Mock implements TaskBloc {}

void main() {
  group('AddTaskScreen', () {
    late MockTaskBloc mockTaskBloc;

    setUp(() {
      mockTaskBloc = MockTaskBloc();
    });

    testWidgets('renders Add Task form correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>.value(
            value: mockTaskBloc,
            child: AddTaskScreen('userId'),
          ),
        ),
      );

      expect(find.text('Add Task'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3)); // Title, Description, Due Date
      expect(find.byType(DropdownButtonFormField<Priority>), findsOneWidget);
    });

    testWidgets('validates input fields', (WidgetTester tester) async {

     await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>.value(
            value: mockTaskBloc,
            child: AddTaskScreen('userId'),
          ),
        ),
      );
      
      await tester.tap(find.text('Create Task'));
      await tester.pump(); // Rebuild the widget

      expect(find.text('Title is required'), findsOneWidget);
      expect(find.text('Description is required'), findsOneWidget);
      expect(find.text('Due date is required'), findsOneWidget);
    });


    testWidgets('renders Edit Task form correctly', (WidgetTester tester) async {
      final task = TaskEntity('1', 'Existing Task', 'Existing Description', DateTime.now(), Priority.low);
      
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TaskBloc>.value(
            value: mockTaskBloc,
            child: AddTaskScreen('userId', task: task),
          ),
        ),
      );

      expect(find.text('Edit Task'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3)); // Title, Description, Due Date
      expect(find.text('Existing Task'), findsOneWidget);
      expect(find.text('Existing Description'), findsOneWidget);
    });
  });
}
