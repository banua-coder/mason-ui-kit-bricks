import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/failures.dart';
import '../../../core/use_case/use_case.dart';
import '../repositories/access_token_repository.dart';

@LazySingleton()
class GetAccessToken
    implements UseCase<String, NoParams, AccessTokenRepository> {
  @override
  Future<Either<Failure, String>> call(NoParams param) async =>
      repo.getAccessToken();

  @override
  AccessTokenRepository get repo => getIt<AccessTokenRepository>();
}
