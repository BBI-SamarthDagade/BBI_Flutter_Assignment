import 'package:ecommerce/features/auth/domain/usecases/continue_with_google_use_case.dart';
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

  AuthBloc({
    required this.continueWithGoogleUseCase,
    required this.signInWithEmailUseCase,
    required this.signOutUseCase,
    required this.signUpWithEmailUseCase,
  }) : super(AuthInitial()) {
    
    // Register each event handler separately
    on<ContinueWithGoogleEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await continueWithGoogleUseCase.call();
      result.fold(
        (failure) => emit(AuthFailure("Failed to continue With Google")),
        (user) => emit(AuthSuccess(user)),
      );
    });

    on<SignInWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signInWithEmailUseCase.call(event.authEntity);
      result.fold(
        (failure) => emit(AuthFailure("Failed to Sign In with Email")),
        (user) => emit(AuthSuccess(user)),
      );
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signOutUseCase.call();
      result.fold(
        (failure) => emit(AuthFailure("Failed to Sign out")),
        (_) => emit(AuthSignedOut()),
      );
    });

    on<SignUpWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signUpWithEmailUseCase.call(event.authEntity);
      result.fold(
        (failure) => emit(AuthFailure("Failed to Sign Up With Email")),
        (user) => emit(AuthSuccess(user)),
      );
    });
  }
}
