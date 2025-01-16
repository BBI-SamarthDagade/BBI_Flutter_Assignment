import 'dart:io';
import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/profile/domain/entities/profile_model.dart';
import 'package:fpdart/fpdart.dart';


abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> getProfile(String userId);
  Future<Either<Failure, void>> updateProfile(ProfileModel profileModel, String userId);
  Future<Either<Failure, void>> saveProfile(ProfileModel profileModel, String userId); //skip
  Future<Either<Failure,bool>> checkProfileStatus(String userId);
}
