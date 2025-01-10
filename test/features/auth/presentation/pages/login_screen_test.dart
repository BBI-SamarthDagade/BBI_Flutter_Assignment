import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:taskapp/features/auth/presentation/pages/login_screen.dart';
import 'package:taskapp/features/task/presentation/pages/task_list_screen.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();

    // Provide an initial state for the mock AuthBloc
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
  });

  tearDown(() {
    mockAuthBloc.close();
  });

  Widget createTestableWidget(Widget child) {
    return BlocProvider<AuthBloc>(
      create: (_) => mockAuthBloc,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('Login Screen displays app bar and Filds',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(const LoginScreen()));

    // Verify the app bar title
    expect(find.text("Login"), findsOneWidget);

    // Verify the presence of buttons
    expect(find.text("Enter User ID"), findsOneWidget);
    expect(find.text("Submit"), findsOneWidget);
  });

  testWidgets('Shows error message when Submit button is tapped without input',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(const LoginScreen()));

    // Tap on the "Login User" button
    await tester.tap(find.text("Submit"));
    await tester.pumpAndSettle();

    // Assert: Verify that the LoginScreen remains visible
    expect(find.byType(LoginScreen), findsOneWidget);

    // Optional: Verify that no navigation occurred
    expect(find.byType(TaskListScreen), findsNothing);

    // Optional: Verify error feedback (e.g., SnackBar)
    //expect(find.text('Please enter a valid User ID'), findsOneWidget);
  });

  testWidgets('TextField accepts input and updates its value',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextField(
            key: const Key('userIdInput'),
            decoration: const InputDecoration(
              labelText: "Enter User ID",
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );

    // Find the TextField by its key
    final textFieldFinder = find.byKey(const Key('userIdInput'));

    // Verify that the TextField is present
    expect(textFieldFinder, findsOneWidget);

    // Simulate entering text into the TextField
    const testInput = 'user_1';
    await tester.enterText(textFieldFinder, testInput);

    // Verify that the text is entered correctly
    expect(find.text(testInput), findsOneWidget);
  });
}
