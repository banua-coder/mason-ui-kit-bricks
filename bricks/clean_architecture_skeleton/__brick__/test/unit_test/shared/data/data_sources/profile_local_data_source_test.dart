import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{name.snakeCase()}}/core/constants/storage_constant.dart';
import 'package:{{name.snakeCase()}}/core/local_storage/local_storage.dart';
import 'package:{{name.snakeCase()}}/shared/data/data_sources/profile_local_data_source.dart';
import 'package:{{name.snakeCase()}}/shared/data/models/profile_model.dart';
import 'package:{{name.snakeCase()}}/shared/domain/entities/profile.dart';

import '../../../../fixtures/fixtures.dart';
import '../../../../helpers/test_injection.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late LocalStorage mockLocalStorage;
  late ProfileLocalDataSource localDataSource;

  setUp(
    () {
      mockLocalStorage = MockLocalStorage();
      registerTestFactory<LocalStorage>(
        mockLocalStorage,
        instanceName: 'secure',
      );
      localDataSource = ProfileLocalDataSourceImpl();
    },
  );

  group(
    'ProfileLocalDataSource',
    () {
      group(
        'deleteExpiredAt',
        () {
          test(
            'should return true if expired at successfully deleted',
            () async {
              // arrange
              when(
                () => mockLocalStorage.remove(StorageConstant.userExpiredAt),
              ).thenAnswer((_) async => true);

              // act
              var result = await localDataSource.deleteExpiredAt();

              // assert
              expect(result, isTrue);
              verify(
                () => mockLocalStorage.remove(StorageConstant.userExpiredAt),
              ).called(1);
            },
          );

          test(
            'should return false if expired at not deleted',
            () async {
              // arrange
              when(
                () => mockLocalStorage.remove(StorageConstant.userExpiredAt),
              ).thenAnswer((_) async => false);

              // act
              var result = await localDataSource.deleteExpiredAt();

              // assert
              expect(result, isFalse);
              verify(
                () => mockLocalStorage.remove(StorageConstant.userExpiredAt),
              ).called(1);
            },
          );
        },
      );

      group(
        'deleteProfile',
        () {
          test(
            'should return true when profile successfuly deleted',
            () async {
              // arrange
              when(
                () => mockLocalStorage.remove(StorageConstant.user),
              ).thenAnswer((_) async => true);

              // act
              var result = await localDataSource.deleteProfile();

              // assert
              expect(result, isTrue);
              verify(
                () => mockLocalStorage.remove(StorageConstant.user),
              ).called(1);
            },
          );

          test(
            'should return false when profile not deleted',
            () async {
              // arrange
              when(
                () => mockLocalStorage.remove(StorageConstant.user),
              ).thenAnswer((_) async => false);

              // act
              var result = await localDataSource.deleteProfile();

              // assert
              expect(result, isFalse);
              verify(
                () => mockLocalStorage.remove(StorageConstant.user),
              ).called(1);
            },
          );
        },
      );

      group(
        'getExpiredAt',
        () {
          var expiredAt = DateTime.now().add(const Duration(hours: 5));
          test(
            'should return expired DateTime when expired at exist',
            () async {
              // arrange
              when(
                () => mockLocalStorage.get(StorageConstant.userExpiredAt),
              ).thenAnswer((_) async => expiredAt.toString());

              // act
              var result = await localDataSource.getExpiredAt();

              // assert
              expect(result, expiredAt);
              verify(
                () => mockLocalStorage.get(StorageConstant.userExpiredAt),
              ).called(1);
            },
          );

          test(
            'should return DateTime.now() when expired at does not exist',
            () async {
              // arrange
              when(
                () => mockLocalStorage.get(StorageConstant.userExpiredAt),
              ).thenAnswer((_) async => null);
              // act
              var result = await localDataSource.getExpiredAt();
              var dateNow = DateTime.now();

              // assert
              expect(result.difference(dateNow).inHours < 60, isTrue);
              verify(
                () => mockLocalStorage.get(StorageConstant.userExpiredAt),
              ).called(1);
            },
          );
        },
      );

      group(
        'getProfile',
        () {
          test(
            'should return profile when profile exist',
            () async {
              // arrange
              var jsonString = fixture('profile_fixture.json');
              var profile = ProfileModel.fromJson(
                jsonFromFixture('profile_fixture.json'),
              );
              when(
                () => mockLocalStorage.get(StorageConstant.user),
              ).thenAnswer((_) async => jsonString);

              // act
              var result = await localDataSource.getProfile();

              // assert
              expect(result, profile);
              verify(
                () => mockLocalStorage.get(StorageConstant.user),
              ).called(1);
            },
          );

          test(
            'should return null when profile does not exist',
            () async {
              // arrange

              when(
                () => mockLocalStorage.get(StorageConstant.user),
              ).thenAnswer((_) async => null);

              // act
              var result = await localDataSource.getProfile();

              // assert
              expect(result, null);
              verify(
                () => mockLocalStorage.get(StorageConstant.user),
              ).called(1);
            },
          );
        },
      );

      group(
        'saveProfile',
        () {
          Profile profile = ProfileModel.fromJson(
            jsonFromFixture('profile_fixture.json'),
          );

          var json = ProfileModel.fromEntity(profile).toJson();

          test(
            'should return true if profile saved successfully',
            () async {
              // arrange
              when(
                () => mockLocalStorage.save(
                    StorageConstant.user, jsonEncode(json)),
              ).thenAnswer((_) async => true);

              // act
              var result = await localDataSource.saveProfile(profile);

              // assert
              expect(result, isTrue);
              verify(
                () => mockLocalStorage.save(
                    StorageConstant.user, jsonEncode(json)),
              ).called(1);
            },
          );

          test(
            'should return false if profile is not saved',
            () async {
              // arrange
              when(
                () => mockLocalStorage.save(
                    StorageConstant.user, jsonEncode(json)),
              ).thenAnswer((_) async => false);

              // act
              var result = await localDataSource.saveProfile(profile);

              // assert
              expect(result, isFalse);
              verify(
                () => mockLocalStorage.save(
                    StorageConstant.user, jsonEncode(json)),
              ).called(1);
            },
          );
        },
      );

      group(
        'updateExpiredAt',
        () {
          test(
            'should return true if expired at updated successfully',
            () async {
              // arrange
              when(
                () => mockLocalStorage.save(
                  StorageConstant.userExpiredAt,
                  captureAny(),
                ),
              ).thenAnswer((_) async => true);

              // act
              var result = await localDataSource.updateExpiredAt();

              // assert
              expect(result, isTrue);
              verify(
                () => mockLocalStorage.save(
                  StorageConstant.userExpiredAt,
                  captureAny(),
                ),
              ).called(1);
            },
          );

          test(
            'should return false if expired at not updated',
            () async {
              // arrange
              when(
                () => mockLocalStorage.save(
                  StorageConstant.userExpiredAt,
                  captureAny(),
                ),
              ).thenAnswer((_) async => false);

              // act
              var result = await localDataSource.updateExpiredAt();

              // assert
              expect(result, isFalse);
              verify(
                () => mockLocalStorage.save(
                  StorageConstant.userExpiredAt,
                  captureAny(),
                ),
              ).called(1);
            },
          );
        },
      );
    },
  );
}
