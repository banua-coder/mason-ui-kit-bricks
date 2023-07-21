import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/failures/failures.dart';
import '../../../core/use_case/use_case.dart';
import '../repositories/access_token_repository.dart';

@Injectable()
class HasAccessToken implements UseCase<bool, NoParams, AccessTokenRepository> {
  @override
  Future<Either<Failure, bool>> call(NoParams param) async =>
      repo.hasAccessToken();

  @override
  AccessTokenRepository get repo => getIt<AccessTokenRepository>();
}
