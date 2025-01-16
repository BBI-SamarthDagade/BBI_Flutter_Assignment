import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserIdFromLocal {
  final AuthRepository authRepository;

  GetUserIdFromLocal(this.authRepository);

  Future<Either<Failure,String?>> call() async {
     return await authRepository.getUserIdFromLocal();
  }
}