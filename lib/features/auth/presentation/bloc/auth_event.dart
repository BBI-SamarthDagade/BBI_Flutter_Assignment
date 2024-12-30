

// import 'package:equatable/equatable.dart';
// import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';

// abstract class AuthEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class AddUserEvent extends AuthEvent {}

// class LoginUserEvent extends AuthEvent {
//   final AuthEntity auth;

//   LoginUserEvent(this.auth);

//   @override
//   List<Object?> get props => [auth];
// }
// class GetUserIdFromLocalEvent extends AuthEvent{
  
// }

import 'package:equatable/equatable.dart';
import 'package:taskapp/features/auth/domain/entities/auth_entity.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddUserEvent extends AuthEvent {}

class LoginUserEvent extends AuthEvent {
  final AuthEntity auth;

  LoginUserEvent(this.auth);

  @override
  List<Object?> get props => [auth];
}

class LogoutEvent extends AuthEvent {
  final AuthEntity auth;
  LogoutEvent(this.auth);
}
