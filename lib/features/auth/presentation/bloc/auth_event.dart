
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

class ValidateUserIdEvent extends AuthEvent {
  final String userId;

  ValidateUserIdEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
class GetUserIdFromLocal extends AuthEvent{
  
}