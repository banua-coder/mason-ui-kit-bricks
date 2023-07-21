import 'package:dartz/dartz.dart';

import '../../../core/failures/failures.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile({bool isUpdated = false});
  Future<Either<Failure, bool>> deleteProfile();
  Future<Either<Failure, bool>> saveProfile(Profile profile);
}
