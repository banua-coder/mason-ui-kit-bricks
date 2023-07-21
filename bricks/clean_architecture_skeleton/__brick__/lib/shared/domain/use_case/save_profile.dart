import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/failures/failures.dart';
import '../../../core/use_case/use_case.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

@Injectable()
class SaveProfile implements UseCase<bool, Profile, ProfileRepository> {
  @override
  Future<Either<Failure, bool>> call(Profile profile) async =>
      repo.saveProfile(profile);

  @override
  ProfileRepository get repo => getIt<ProfileRepository>();
}
