import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce/features/profile/domain/repository/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveProfileUseCase {
  final ProfileRepository profileRepository;
  SaveProfileUseCase(this.profileRepository);

  Future<Either<Failure, void>> saveProfile(ProfileModel profileModel, String userId) async {
    return await profileRepository.saveProfile(profileModel, userId);
  }
}