import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce/features/profile/domain/repository/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProfileUseCase {
  final ProfileRepository profileRepository;
  GetProfileUseCase(this.profileRepository);

  Future<Either<Failure, ProfileModel>> call(String userId) async {
    return await profileRepository.getProfile(userId);
  }
}