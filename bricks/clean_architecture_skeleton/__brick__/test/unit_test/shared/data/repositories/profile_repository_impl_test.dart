import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{name.snakeCase()}}/core/failures/failures.dart';
import 'package:{{name.snakeCase()}}/core/network/api_exception.dart';
import 'package:{{name.snakeCase()}}/shared/data/data_sources/profile_local_data_source.dart';
import 'package:{{name.snakeCase()}}/shared/data/data_sources/profile_remote_data_source.dart';
import 'package:{{name.snakeCase()}}/shared/data/models/profile_model.dart';
import 'package:{{name.snakeCase()}}/shared/data/repositories/profile_repository_impl.dart';
import 'package:{{name.snakeCase()}}/shared/domain/entities/profile.dart';
import 'package:{{name.snakeCase()}}/shared/domain/repositories/profile_repository.dart';

import '../../../../fixtures/fixtures.dart';
import '../../../../helpers/test_injection.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockProfileLocalDataSource extends Mock
    implements ProfileLocalDataSource {}

void main() {
  late ProfileLocalDataSource mockLocalDataSource;
  late ProfileRemoteDataSource mockRemoteDataSource;
  late ProfileRepository repository;
  late Profile profile;
  late ProfileModel newProfile;

  setUpAll(
    () {
      mockLocalDataSource = MockProfileLocalDataSource();
      mockRemoteDataSource = MockProfileRemoteDataSource();
      registerTestLazySingleton<ProfileLocalDataSource>(mockLocalDataSource);
      registerTestLazySingleton<ProfileRemoteDataSource>(mockRemoteDataSource);
      repository = ProfileRepositoryImpl();
      profile = ProfileModel.fromJson(jsonFromFixture('profile_fixture.json'));
      newProfile = ProfileModel(
        id: profile.id,
        name: profile.name,
        isEmailVerified: true,
        isPhoneVerified: true,
        gender: profile.gender,
        avatar: profile.avatar,
        phoneNumber: profile.phoneNumber,
        dateOfBirth: profile.dateOfBirth,
        suspendedUntil: profile.suspendedUntil,
        updatedAt: profile.updatedAt,
      );
    },
  );

  group(
    'ProfileRepository',
    () {
      group(
        'deleteProfile',
        () {
          test(
            'should return true if profile deleted!',
            () async {
              when(
                () => mockLocalDataSource.deleteProfile(),
              ).thenAnswer((_) async => true);

              var result = await repository.deleteProfile();

              expect(result, const Right(true));
              verify(
                () => mockLocalDataSource.deleteProfile(),
              ).called(1);
            },
          );

          test(
            'should return false if profile not deleted!',
            () async {
              when(
                () => mockLocalDataSource.deleteProfile(),
              ).thenAnswer((_) async => false);

              var result = await repository.deleteProfile();

              expect(result, const Right(false));
              verify(
                () => mockLocalDataSource.deleteProfile(),
              ).called(1);
            },
          );

          test(
            'should return ClientFailure when exception occured!',
            () async {
              when(
                () => mockLocalDataSource.deleteProfile(),
              ).thenThrow(Exception());

              var result = await repository.deleteProfile();

              expect(result, Left(ClientFailure()));
              verify(
                () => mockLocalDataSource.deleteProfile(),
              ).called(1);
            },
          );
        },
      );

      group(
        'saveProfile',
        () {
          test(
            'should return true if profile saved!',
            () async {
              when(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(profile),
                ),
              ).thenAnswer((_) async => true);

              var result = await repository.saveProfile(profile);

              expect(result, const Right(true));
              verify(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(profile),
                ),
              ).called(1);
            },
          );

          test(
            'should return false if profile not saved!',
            () async {
              when(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(profile),
                ),
              ).thenAnswer((_) async => false);

              var result = await repository.saveProfile(profile);

              expect(result, const Right(false));
              verify(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(profile),
                ),
              ).called(1);
            },
          );

          test(
            'should return ClientFailure when exception occured!',
            () async {
              when(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(profile),
                ),
              ).thenThrow(Exception());

              var result = await repository.saveProfile(profile);

              expect(result, Left(ClientFailure()));
              verify(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(profile),
                ),
              ).called(1);
            },
          );
        },
      );

      group(
        'getProfile',
        () {
          test(
            'should return profile from local if profile exist and not expired!',
            () async {
              when(
                () => mockLocalDataSource.getProfile(),
              ).thenAnswer(
                (_) async => ProfileModel.fromEntity(profile),
              );
              when(
                () => mockLocalDataSource.getExpiredAt(),
              ).thenAnswer(
                (_) async => DateTime.now().add(const Duration(hours: 2)),
              );

              var result = await repository.getProfile();

              expect(result, Right(profile));
              verify(
                () => mockLocalDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.getExpiredAt(),
              ).called(1);
            },
          );

          test(
            'should return profile from remote if profile exist but expired!',
            () async {
              when(
                () => mockLocalDataSource.getProfile(),
              ).thenAnswer(
                (_) async => ProfileModel.fromEntity(profile),
              );
              when(
                () => mockLocalDataSource.getExpiredAt(),
              ).thenAnswer(
                (_) async => DateTime.now().subtract(const Duration(hours: 2)),
              );
              when(
                () => mockRemoteDataSource.getProfile(),
              ).thenAnswer(
                (_) async => ProfileModel.fromEntity(profile),
              );
              when(
                () => mockLocalDataSource.updateExpiredAt(),
              ).thenAnswer(
                (_) async => true,
              );

              var result = await repository.getProfile();

              expect(result, Right(profile));
              verify(
                () => mockLocalDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.getExpiredAt(),
              ).called(1);
              verify(
                () => mockRemoteDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.updateExpiredAt(),
              ).called(1);
            },
          );

          test(
            'should return profile from remote if profile not exist!',
            () async {
              when(
                () => mockLocalDataSource.getProfile(),
              ).thenAnswer(
                (_) async => null,
              );
              when(
                () => mockLocalDataSource.getExpiredAt(),
              ).thenAnswer(
                (_) async => DateTime.now(),
              );
              when(
                () => mockRemoteDataSource.getProfile(),
              ).thenAnswer(
                (_) async => ProfileModel.fromEntity(profile),
              );
              when(
                () => mockLocalDataSource.updateExpiredAt(),
              ).thenAnswer(
                (_) async => true,
              );
              when(
                () => mockLocalDataSource.deleteProfile(),
              ).thenAnswer(
                (_) async => false,
              );
              when(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(profile),
                ),
              ).thenAnswer(
                (_) async => true,
              );

              var result = await repository.getProfile();

              expect(result, Right(profile));
              verify(
                () => mockLocalDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.getExpiredAt(),
              ).called(1);
              verify(
                () => mockRemoteDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.updateExpiredAt(),
              ).called(1);
              verify(
                () => mockLocalDataSource.deleteProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(profile),
                ),
              ).called(1);
            },
          );

          test(
            'should return profile from remote and update expired at if isUpdate is true!',
            () async {
              when(
                () => mockLocalDataSource.getProfile(),
              ).thenAnswer(
                (_) async => ProfileModel.fromEntity(profile),
              );
              when(
                () => mockLocalDataSource.getExpiredAt(),
              ).thenAnswer(
                (_) async => DateTime.now(),
              );
              when(
                () => mockRemoteDataSource.getProfile(),
              ).thenAnswer(
                (_) async => ProfileModel.fromEntity(profile),
              );
              when(
                () => mockLocalDataSource.updateExpiredAt(),
              ).thenAnswer(
                (_) async => true,
              );
              when(
                () => mockLocalDataSource.deleteProfile(),
              ).thenAnswer(
                (_) async => true,
              );
              when(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(profile),
                ),
              ).thenAnswer(
                (_) async => true,
              );

              var result = await repository.getProfile(isUpdated: true);

              expect(result, Right(profile));
              verify(
                () => mockLocalDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.getExpiredAt(),
              ).called(1);
              verify(
                () => mockRemoteDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.updateExpiredAt(),
              ).called(1);
              verifyNever(
                () => mockLocalDataSource.deleteProfile(),
              );
              verifyNever(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(profile),
                ),
              );
            },
          );

          test(
            'should return profile from remote and update expired at and local profile if isUpdate is true and local data != remote data!',
            () async {
              when(
                () => mockLocalDataSource.getProfile(),
              ).thenAnswer(
                (_) async => ProfileModel.fromEntity(profile),
              );
              when(
                () => mockLocalDataSource.getExpiredAt(),
              ).thenAnswer(
                (_) async => DateTime.now(),
              );
              when(
                () => mockRemoteDataSource.getProfile(),
              ).thenAnswer(
                (_) async => newProfile,
              );
              when(
                () => mockLocalDataSource.updateExpiredAt(),
              ).thenAnswer(
                (_) async => true,
              );
              when(
                () => mockLocalDataSource.deleteProfile(),
              ).thenAnswer(
                (_) async => true,
              );
              when(
                () => mockLocalDataSource.saveProfile(
                  newProfile,
                ),
              ).thenAnswer(
                (_) async => true,
              );

              var result = await repository.getProfile(isUpdated: true);

              expect(result, Right(newProfile));
              verify(
                () => mockLocalDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.getExpiredAt(),
              ).called(1);
              verify(
                () => mockRemoteDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.updateExpiredAt(),
              ).called(1);
              verify(
                () => mockLocalDataSource.deleteProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(newProfile),
                ),
              ).called(1);
            },
          );

          test(
            'should return profile from remote and update elocal profile if local data != remote data!',
            () async {
              when(
                () => mockLocalDataSource.getProfile(),
              ).thenAnswer(
                (_) async => ProfileModel.fromEntity(profile),
              );
              when(
                () => mockLocalDataSource.getExpiredAt(),
              ).thenAnswer(
                (_) async => DateTime.now(),
              );
              when(
                () => mockRemoteDataSource.getProfile(),
              ).thenAnswer(
                (_) async => newProfile,
              );
              when(
                () => mockLocalDataSource.updateExpiredAt(),
              ).thenAnswer(
                (_) async => true,
              );
              when(
                () => mockLocalDataSource.deleteProfile(),
              ).thenAnswer(
                (_) async => true,
              );
              when(
                () => mockLocalDataSource.saveProfile(
                  newProfile,
                ),
              ).thenAnswer(
                (_) async => true,
              );

              var result = await repository.getProfile(isUpdated: true);

              expect(result, Right(newProfile));
              verify(
                () => mockLocalDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.getExpiredAt(),
              ).called(1);
              verify(
                () => mockRemoteDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.updateExpiredAt(),
              ).called(1);
              verify(
                () => mockLocalDataSource.deleteProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(newProfile),
                ),
              ).called(1);
            },
          );

          test(
            'should return ServerFailure if ErrorRequestException occured',
            () async {
              when(
                () => mockLocalDataSource.getProfile(),
              ).thenAnswer(
                (_) async => ProfileModel.fromEntity(profile),
              );
              when(
                () => mockLocalDataSource.getExpiredAt(),
              ).thenAnswer(
                (_) async => DateTime.now(),
              );
              when(
                () => mockRemoteDataSource.getProfile(),
              ).thenThrow(ErrorRequestException(600, 'Unknown'));
              when(
                () => mockLocalDataSource.updateExpiredAt(),
              ).thenAnswer(
                (_) async => true,
              );
              when(
                () => mockLocalDataSource.deleteProfile(),
              ).thenAnswer(
                (_) async => true,
              );
              when(
                () => mockLocalDataSource.saveProfile(
                  newProfile,
                ),
              ).thenAnswer(
                (_) async => true,
              );

              var result = await repository.getProfile(isUpdated: true);

              expect(result, Left(ServerFailure()));
              verify(
                () => mockLocalDataSource.getProfile(),
              ).called(1);
              verify(
                () => mockLocalDataSource.getExpiredAt(),
              ).called(1);
              verify(
                () => mockRemoteDataSource.getProfile(),
              ).called(1);
              verifyNever(
                () => mockLocalDataSource.updateExpiredAt(),
              );
              verifyNever(
                () => mockLocalDataSource.deleteProfile(),
              );
              verifyNever(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(newProfile),
                ),
              );
            },
          );

          test(
            'should return ClientFailure if unknown exception occured',
            () async {
              when(
                () => mockLocalDataSource.getProfile(),
              ).thenThrow(Exception());
              when(
                () => mockLocalDataSource.getExpiredAt(),
              ).thenAnswer(
                (_) async => DateTime.now(),
              );
              when(
                () => mockRemoteDataSource.getProfile(),
              ).thenThrow(ErrorRequestException(600, 'Unknown'));
              when(
                () => mockLocalDataSource.updateExpiredAt(),
              ).thenAnswer(
                (_) async => true,
              );
              when(
                () => mockLocalDataSource.deleteProfile(),
              ).thenAnswer(
                (_) async => true,
              );
              when(
                () => mockLocalDataSource.saveProfile(
                  newProfile,
                ),
              ).thenAnswer(
                (_) async => true,
              );

              var result = await repository.getProfile(isUpdated: true);

              expect(result, Left(ClientFailure()));
              verify(
                () => mockLocalDataSource.getProfile(),
              ).called(1);
              verifyNever(
                () => mockLocalDataSource.getExpiredAt(),
              );
              verifyNever(
                () => mockRemoteDataSource.getProfile(),
              );
              verifyNever(
                () => mockLocalDataSource.updateExpiredAt(),
              );
              verifyNever(
                () => mockLocalDataSource.deleteProfile(),
              );
              verifyNever(
                () => mockLocalDataSource.saveProfile(
                  ProfileModel.fromEntity(newProfile),
                ),
              );
            },
          );
        },
      );
    },
  );
}
