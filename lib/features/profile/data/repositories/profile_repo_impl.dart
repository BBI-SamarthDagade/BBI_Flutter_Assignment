import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/profile/data/datasouce/profile_remote_data_source.dart';
import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';
import 'package:ecommerce/features/profile/domain/repository/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProfileRepoImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> checkProfileStatus(String userId) async {
    try {
      final result = await remoteDataSource.checkProfileStatus(userId);
      return Right(result); // Pass the result if successful
    } catch (e) {
      return Left(Failure(message: e.toString())); // Wrap the exception in a Failure
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> getProfile(String userId) async {
    try {
      final profile = await remoteDataSource.getProfile(userId);
      return Right(profile); // Pass the profile if successful
    } catch (e) {
      return Left(Failure(message: e.toString())); // Wrap the exception in a Failure
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile(ProfileModel profileModel, String userId) async {
    try {
      await remoteDataSource.saveProfile(profileModel, userId);
      return const Right(null); // Indicate success with `null` as the result
    } catch (e) {
      return Left(Failure(message: e.toString())); // Wrap the exception in a Failure
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(ProfileModel profileModel, String userId) async {
    try {
      await remoteDataSource.updateProfile(profileModel, userId);
      return const Right(null); // Indicate success with `null` as the result
    } catch (e) {
      return Left(Failure(message: e.toString())); // Wrap the exception in a Failure
    }
  }
}
