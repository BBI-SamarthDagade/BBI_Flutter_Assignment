import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce/features/profile/domain/repository/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProfileUseCase {
  final ProfileRepository profileRepository;
  UpdateProfileUseCase(this.profileRepository);

  Future<Either<Failure, void>> updateProfile(ProfileModel profileModel, String userId) async {
    return await profileRepository.updateProfile(profileModel, userId);
  }
}