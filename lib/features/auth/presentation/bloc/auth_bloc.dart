import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/usecases/continue_with_google_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/get_user_id_from_local.dart';
import 'package:ecommerce/features/auth/domain/usecases/password_reset_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_in_with_email_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:ecommerce/features/auth/domain/usecases/sign_up_with_email_use_case.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ContinueWithGoogleUseCase continueWithGoogleUseCase;
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SignOutUseCase signOutUseCase;
  final SignUpWithEmailUseCase signUpWithEmailUseCase;
  final GetUserIdFromLocal getUserIdFromLocal;
  final PasswordResetUseCase passwordResetUseCase;

  AuthBloc({
    required this.continueWithGoogleUseCase,
    required this.signInWithEmailUseCase,
    required this.signOutUseCase,
    required this.signUpWithEmailUseCase,
    required this.getUserIdFromLocal,
    required this.passwordResetUseCase,
  }) : super(AuthInitial()) {
    
    print("auth bloc instance created");
    // Register each event handler separately
    on<ContinueWithGoogleEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await continueWithGoogleUseCase.call();
      result.fold(
        (failure) => emit(AuthFailure("Failed to continue With Google")),
        (user){
          emit(AuthSuccess(user));
        }
        
      );
    });

    on<SignInWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signInWithEmailUseCase.call(event.authEntity);
      result.fold(
        (failure) => emit(AuthFailure("Failed to Sign In with Email")),
        (user) {
          emit(AuthSuccess(user));
          emit(Authenticated());
        },
      );
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signOutUseCase.call();
      result.fold((failure) => emit(AuthFailure("Failed to Sign out")), (_) {
        emit(AuthSignedOut());
        emit(Unauthenticated());
      });
    });

    on<SignUpWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signUpWithEmailUseCase.call(event.authEntity);
      result
          .fold((failure) => emit(AuthFailure("Failed to Sign Up With Email")),
              (user) {
        emit(AuthSuccess(user));
      });
    });

    on<CheckUserLoggedIn>((event, emit) async {
      final result = await getUserIdFromLocal.call();
      result.fold((l) => Failure(message: "failed to fetch user id from local"),
          (userId) {
        if (userId != null) {
          emit(Authenticated());
        } else {
          emit(Unauthenticated());
        }
      });
    });

    on<PasswrodResetEvent>((event, emit) async {
      final result = await passwordResetUseCase.call(event.email);
      result.fold((l) => Failure(message: "Failed to Reset and Password using Email"),
      (_) {
         emit(AuthInitial());
      });
    });
  }
}
