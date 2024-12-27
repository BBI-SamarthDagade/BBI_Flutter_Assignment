import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/auth/domain/usecases/create_user_use_case.dart';
import 'package:taskapp/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateUserUseCase createUserUseCase;
  final LoginUserUseCase loginUserUseCase;

  AuthBloc(this.createUserUseCase, this.loginUserUseCase) : super(AuthInitial()) {
    on<AddUserEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await createUserUseCase.call();
      result.fold(
        (failure) => emit(AuthFailure("Failed to add user")),
        (user) => emit(AuthSuccess("User added successfully: ${user.userId}")),
      );
    });

    on<LoginUserEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUserUseCase.call(event.auth);
      result.fold(
        (failure) => emit(AuthFailure("Login failed")),
        (user) => emit(AuthSuccess("Login successful: ${user.userId}")),
      );
    });
  }
  
}

