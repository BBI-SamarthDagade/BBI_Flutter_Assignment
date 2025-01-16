// profile_state.dart
import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileStatusChecked extends ProfileState {
  final bool isComplete;

  ProfileStatusChecked(this.isComplete);
}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;

  ProfileLoaded(this.profile);
}

class ProfileSaved extends ProfileState {}

class ProfileUpdated extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileLoading extends ProfileState{ }
