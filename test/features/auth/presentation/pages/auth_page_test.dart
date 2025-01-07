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
import 'package:taskapp/features/task/presentation/bloc/task_bloc.dart';
import 'package:taskapp/features/task/presentation/bloc/task_state.dart';
import 'package:taskapp/features/task/presentation/pages/task_list_screen.dart';
import '../../../task/presentation/add_task_screen_test.dart';


class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockTaskBloc mockTaskBloc;

  setUp(() {
    mockTaskBloc = MockTaskBloc();
    mockAuthBloc = MockAuthBloc();

    // Provide an initial state for the mock AuthBloc
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockTaskBloc.state).thenReturn(TaskInitial());
  });

  tearDown(() {
    mockAuthBloc.close();
  });

Widget createTestableWidget(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(create: (_) => mockAuthBloc), // Provide AuthBloc
      BlocProvider<TaskBloc>(create: (_) => mockTaskBloc), // Provide TaskBloc
    ],
    child: MaterialApp(
      home: child,
      routes: {
        '/auth': (context) => AuthScreen(),
        '/login': (context) => LoginScreen(),
        '/taskList': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final userId = arguments?['userId'] as String? ?? " ";
          return TaskListScreen(userId);
        },
      },
    ),
  );
}

  testWidgets('AuthScreen displays app bar and buttons', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(const AuthScreen()));

    // Verify the app bar title
    expect(find.text("Welcome to TaskApp"), findsOneWidget);

    // Verify the presence of buttons
    expect(find.text("Create User"), findsOneWidget);
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

//   testWidgets('Create User button is tappable and navigates to TaskListScreen', (WidgetTester tester) async {
//   // Mock the stream for AuthBloc
//   when(() => mockAuthBloc.stream).thenAnswer((_) {
//     final controller = StreamController<AuthState>();
//     controller.add(AuthLoading());
//     Future.delayed(Duration.zero, () {
//       controller.add(AuthSuccess("user created successfully")); // Emitting success
//     });
//     Future.delayed(Duration.zero, () {
//       controller.add(AuthLoaded(AuthEntity(userId: 'userId'))); // Emitting loaded state
//     });
//     return controller.stream;
//   });

//   // Mock the state for TaskBloc
//   when(() => mockTaskBloc.stream).thenAnswer((_) {
//     final controller = StreamController<TaskState>();
//     controller.add(TaskLoading());
//     Future.delayed(Duration.zero, () {
//       controller.add(TaskLoaded([])); // Provide a sample loaded state
//     });
//     return controller.stream;
//   });

//   when(() => mockTaskBloc.state).thenReturn(TaskLoaded([])); // Mock initial state

//   // Build the widget tree
//    await tester.pumpWidget(createTestableWidget(AuthScreen()));

//   // // Simulate tapping the "Create User" button
//   // await tester.tap(find.text("Create User"));
//   // await tester.pumpAndSettle();

//   // // Verify that TaskListScreen is displayed
//   // expect(find.byType(TaskListScreen), findsOneWidget);
// });

}
