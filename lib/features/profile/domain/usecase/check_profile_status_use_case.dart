import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/profile/domain/repository/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class CheckProfileStatusUseCase {
  final ProfileRepository profileRepository;
  CheckProfileStatusUseCase(this.profileRepository);
  
  Future<Either<Failure, bool>> call(String userId) async {
    return await profileRepository.checkProfileStatus(userId);
  }
}