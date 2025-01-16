import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/features/profile/domain/usecase/check_profile_status_use_case.dart';
import 'package:ecommerce/features/profile/domain/usecase/get_profile_use_case.dart';
import 'package:ecommerce/features/profile/domain/usecase/save_profile_use_case.dart';
import 'package:ecommerce/features/profile/domain/usecase/update_profile_use_case.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_event.dart';
import 'package:ecommerce/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final CheckProfileStatusUseCase checkProfileStatusUseCase;
  final GetProfileUseCase getProfileUseCase;
  final SaveProfileUseCase saveProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.checkProfileStatusUseCase,
    required this.getProfileUseCase,
    required this.saveProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    on<CheckProfileStatusEvent>(_onCheckProfileStatus);
    on<GetProfileEvent>(_onGetProfile);
    on<SaveProfileEvent>(_onSaveProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  // Event handler for checking profile status
  Future<void> _onCheckProfileStatus(CheckProfileStatusEvent event, Emitter<ProfileState> emit) async {

    final result = await checkProfileStatusUseCase.call(event.userId);
    emit(result.fold(
      (failure) => ProfileError("Error: ${failure.message}"),
      (isComplete) => ProfileStatusChecked(isComplete),
    ));
  }

  // Event handler for getting profile
  Future<void> _onGetProfile(GetProfileEvent event, Emitter<ProfileState> emit) async {
    final result = await getProfileUseCase.call(event.userId);
    emit(result.fold(
      (failure) => ProfileError("Error: ${failure.message}"),
      (profile) => ProfileLoaded(profile),
    ));
  }

  // Event handler for saving profile
  Future<void> _onSaveProfile(SaveProfileEvent event, Emitter<ProfileState> emit) async {
    final result = await saveProfileUseCase.saveProfile(event.profileModel, event.userId);
    emit(result.fold(
      (failure) => ProfileError("Error: ${failure.message}"),
      (_) => ProfileSaved(),
    ));
  }

  // Event handler for updating profile
  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    final result = await updateProfileUseCase.updateProfile(event.profileModel, event.userId);
    emit(result.fold(
      (failure) => ProfileError("Error: ${failure.message}"),
      (_) => ProfileUpdated(),
    ));
  }
}
