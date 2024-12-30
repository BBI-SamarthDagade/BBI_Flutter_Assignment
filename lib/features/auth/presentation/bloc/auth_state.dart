import 'package:equatable/equatable.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AuthLoaded extends AuthState {
  final AuthEntity auth;

  AuthLoaded(this.auth);

  @override
  List<Object?> get props => [auth];
}
