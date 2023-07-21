import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/failures/failures.dart';
import '../../../core/use_case/use_case.dart';
import '../repositories/profile_repository.dart';

@LazySingleton()
class DeleteProfile implements UseCase<bool, NoParams, ProfileRepository> {
  @override
  Future<Either<Failure, bool>> call(NoParams param) async =>
      repo.deleteProfile();

  @override
  ProfileRepository get repo => getIt<ProfileRepository>();
}
