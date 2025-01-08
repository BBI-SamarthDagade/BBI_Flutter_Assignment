import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/auth/domain/usecases/create_user_use_case.dart';
import 'package:taskapp/features/auth/domain/usecases/get_user_id_user_case.dart';
import 'package:taskapp/features/auth/domain/usecases/log_out_user_use_case.dart';
import 'package:taskapp/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:taskapp/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CreateUserUseCase createUserUseCase;
  final LoginUserUseCase loginUserUseCase;
  final LogOutUserUseCase logOutUserUseCase;
  final GetUserIdUseCase getUserIdUseCase;

  AuthBloc(this.createUserUseCase, this.loginUserUseCase, this.logOutUserUseCase, this.getUserIdUseCase)
      : super(AuthInitial()) {

    on<AddUserEvent>((event, emit) async {
      emit(AuthLoading());
      
      final result = await createUserUseCase.call();
      print(result);
      result.fold(
        (failure) {
          emit(AuthFailure("Failed to add user"));
        },
        (user) async {
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('userId', user.userId);
          emit(AuthSuccess("User added successfully: ${user.userId}"));
          
          emit(AuthLoaded(user));
        },
      );
    });

    on<LoginUserEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await loginUserUseCase.call(event.auth);
      result.fold(
        (failure) {
          emit(AuthFailure("Login failed"));
        },
        (user) async {
          emit(AuthSuccess("Login successful : ${user.userId}")); 
          emit(AuthLoaded(user));
        },
      );
    });

    on<LogoutEvent>((event, emit) async {
      await logOutUserUseCase.call(event.auth);
      emit(AuthInitial());
    });


    on<GetUserIdFromLocalEvent>((event, emit) async {
       emit(AuthLoading());
      try {
        final userId = await getUserIdUseCase.call();
        if (userId != null) {
          emit(AuthSuccess("User ID retrieved successfully: $userId"));
        } else {
          emit(AuthFailure("No User ID found in local storage"));
        }
      } catch (e) {
        emit(AuthFailure("Error retrieving User ID: $e"));
      }
    });

  }
}
