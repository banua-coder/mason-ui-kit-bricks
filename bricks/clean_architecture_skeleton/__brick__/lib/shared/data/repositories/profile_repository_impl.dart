import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/exception/exceptions.dart';
import '../../../core/failures/failures.dart';
import '../../domain/repositories/access_token_repository.dart';
import '../data_sources/access_token_local_data_source.dart';

@LazySingleton(as: AccessTokenRepository)
class AccessTokenRepositoryImpl implements AccessTokenRepository {
  final _dataSource = getIt<AccessTokenLocalDataSource>();

  AccessTokenRepositoryImpl();

  @override
  Future<Either<Failure, bool>> deleteAccessToken() async {
    try {
      var result = await _dataSource.deleteAccessToken();
      return Right(result);
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getAccessToken() async {
    try {
      var result = await _dataSource.getAccessToken();
      return Right(result);
    } on NotFoundException {
      return Left(NotFoundFailure());
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> hasAccessToken() async {
    try {
      var result = await _dataSource.hasAccessToken();
      return Right(result);
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveAccessToken(String token) async {
    try {
      var result = await _dataSource.saveAccessToken(token);
      return Right(result);
    } catch (e) {
      return Left(ClientFailure());
    }
  }
}
