import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/failures/failures.dart';
import '../../../core/network/api_exception.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_local_data_source.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final _localDataSource = getIt<ProfileLocalDataSource>();
  final _remoteDataSource = getIt<ProfileRemoteDataSource>();

  @override
  Future<Either<Failure, bool>> deleteProfile() async {
    try {
      var result = await _localDataSource.deleteProfile();
      return Right(result);
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, Profile>> getProfile({bool isUpdated = false}) async {
    Profile? result;
    try {
      result = await _localDataSource.getProfile();
      var expiredAt = await _localDataSource.getExpiredAt();
      var difference = DateTime.now().difference(expiredAt);
      var isExpired = difference.inMinutes > 60;

      if (result == null || isExpired || isUpdated) {
        var remoteProfile = await _remoteDataSource.getProfile();
        await _localDataSource.updateExpiredAt();
        if (result != remoteProfile) {
          await _localDataSource.deleteProfile();
          await _localDataSource.saveProfile(remoteProfile);
        }
        result = remoteProfile;
      }

      return Right(result);
    } on ErrorRequestException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ClientFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveProfile(Profile profile) async {
    try {
      var result = await _localDataSource.saveProfile(
        ProfileModel.fromEntity(profile),
      );
      return Right(result);
    } catch (e) {
      return Left(ClientFailure());
    }
  }
}
