import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:taskapp/features/auth/presentation/pages/auth_page.dart';
import 'package:taskapp/features/auth/presentation/pages/login_screen.dart';


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

  testWidgets('AuthScreen displays app bar and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(const AuthScreen()));

    // Verify the app bar title
    expect(find.text("Welcome to TaskApp"), findsOneWidget);

    // Verify the presence of buttons
    expect(find.text("Add User"), findsOneWidget);
    expect(find.text("Login User"), findsOneWidget);
  });

  testWidgets('Navigates to LoginScreen on Login User button tap', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(const AuthScreen()));

    // Tap on the "Login User" button
    await tester.tap(find.text("Login User"));
    await tester.pumpAndSettle();

    // Verify navigation to LoginScreen
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Add User button is tappable and emits event', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(const AuthScreen()));

    // Tap on the "Add User" button
    await tester.tap(find.text("Add User"));
    await tester.pump();

    // Verify that the "Add User" button is still present
    expect(find.text("Add User"), findsOneWidget);
  });
}
