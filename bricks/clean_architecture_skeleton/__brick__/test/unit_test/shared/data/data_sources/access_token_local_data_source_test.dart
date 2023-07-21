import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{name.snakeCase()}}/core/constants/storage_constant.dart';
import 'package:{{name.snakeCase()}}/core/exception/exceptions.dart';
import 'package:{{name.snakeCase()}}/core/local_storage/local_storage.dart';
import 'package:{{name.snakeCase()}}/shared/data/data_sources/access_token_local_data_source.dart';

import '../../../../helpers/test_injection.dart';

class MockLocalStorage extends Mock implements LocalStorage {}

void main() {
  late LocalStorage mockLocalStorage;
  late AccessTokenLocalDataSource dataSource;

  setUpAll(
    () {
      mockLocalStorage = MockLocalStorage();
      registerTestFactory<LocalStorage>(
        mockLocalStorage,
        instanceName: 'secure',
      );
      dataSource = AccessTokenLocalDataSourceImpl();
    },
  );

  var token = 'hkagS815hSd210&#@1mdahasddaf';

  group(
    'AcessTokenLocalDataSource',
    () {
      group(
        'deleteAccessToken',
        () {
          test(
            'should return true if access token deleted',
            () async {
              // arrange
              when(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).thenAnswer((_) async => true);
              when(
                () => mockLocalStorage.remove(StorageConstant.bearerToken),
              ).thenAnswer((_) async => true);

              // act
              var result = await dataSource.deleteAccessToken();

              // assert
              expect(result, isTrue);
              verify(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).called(1);
              verify(
                () => mockLocalStorage.remove(StorageConstant.bearerToken),
              ).called(1);
            },
          );

          test(
            'should return false if access token not deleted',
            () async {
              // arrange
              when(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).thenAnswer((_) async => true);
              when(
                () => mockLocalStorage.remove(StorageConstant.bearerToken),
              ).thenAnswer((_) async => false);

              // act
              var result = await dataSource.deleteAccessToken();

              // assert
              expect(result, isFalse);
              verify(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).called(1);
              verify(
                () => mockLocalStorage.remove(StorageConstant.bearerToken),
              ).called(1);
            },
          );

          test(
            'should throw exception when exception occured',
            () async {
              // arrange
              when(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).thenAnswer((_) async => true);
              when(
                () => mockLocalStorage.remove(StorageConstant.bearerToken),
              ).thenThrow(Exception());

              // act
              var result = dataSource.deleteAccessToken();

              // assert
              await expectLater(result, throwsA(isA<Exception>()));
              verify(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).called(1);
              verify(
                () => mockLocalStorage.remove(StorageConstant.bearerToken),
              ).called(1);
            },
          );
        },
      );

      group(
        'hasAccessToken',
        () {
          test(
            'should return true if access token exist',
            () async {
              // arrange
              when(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).thenAnswer((_) async => true);

              // act
              var result = await dataSource.hasAccessToken();

              // assert
              expect(result, isTrue);
              verify(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).called(1);
            },
          );

          test(
            'should return false if access token does not exist',
            () async {
              // arrange
              when(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).thenAnswer((_) async => false);

              // act
              var result = await dataSource.hasAccessToken();

              // assert
              expect(result, isFalse);
              verify(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).called(1);
            },
          );

          test(
            'should throw Exception when exception occured',
            () async {
              // arrange
              when(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).thenThrow(Exception());

              // act
              var result = dataSource.hasAccessToken();

              // assert
              await expectLater(result, throwsA(isA<Exception>()));
              verify(
                () => mockLocalStorage.has(StorageConstant.bearerToken),
              ).called(1);
            },
          );
        },
      );

      group(
        'saveAccessToken',
        () {
          test(
            'should return true if access token saved',
            () async {
              // arrange
              when(
                () => mockLocalStorage.save(StorageConstant.bearerToken, token),
              ).thenAnswer((_) async => true);

              // act
              var result = await dataSource.saveAccessToken(token);

              // assert
              expect(result, isTrue);
              verify(
                () => mockLocalStorage.save(StorageConstant.bearerToken, token),
              ).called(1);
            },
          );

          test(
            'should return false if access token not saved',
            () async {
              // arrange
              when(
                () => mockLocalStorage.save(StorageConstant.bearerToken, token),
              ).thenAnswer((_) async => false);

              // act
              var result = await dataSource.saveAccessToken(token);

              // assert
              expect(result, isFalse);
              verify(
                () => mockLocalStorage.save(StorageConstant.bearerToken, token),
              ).called(1);
            },
          );

          test(
            'should throw Exception if exception occured',
            () async {
              // arrange
              when(
                () => mockLocalStorage.save(StorageConstant.bearerToken, token),
              ).thenThrow(Exception());

              // act
              var result = dataSource.saveAccessToken(token);

              // assert
              await expectLater(result, throwsA(isA<Exception>()));
              verify(
                () => mockLocalStorage.save(StorageConstant.bearerToken, token),
              ).called(1);
            },
          );
        },
      );

      group(
        'getAccessToken',
        () {
          test(
            'should return access token if access token exist',
            () async {
              // arrange
              when(
                () => mockLocalStorage.get(StorageConstant.bearerToken),
              ).thenAnswer((_) async => token);

              // act
              var result = await dataSource.getAccessToken();

              // assert
              expect(result, token);
              verify(
                () => mockLocalStorage.get(StorageConstant.bearerToken),
              ).called(1);
            },
          );

          test(
            'should throw NotFoundException if access token does not exist',
            () async {
              // arrange
              when(
                () => mockLocalStorage.get(StorageConstant.bearerToken),
              ).thenAnswer((_) async => null);

              // act
              var result = dataSource.getAccessToken();

              // assert
              await expectLater(result, throwsA(isA<NotFoundException>()));
              verify(
                () => mockLocalStorage.get(StorageConstant.bearerToken),
              ).called(1);
            },
          );

          test(
            'should throw Exception if unkown exception occured',
            () async {
              // arrange
              when(
                () => mockLocalStorage.get(StorageConstant.bearerToken),
              ).thenThrow(Exception());

              // act
              var result = dataSource.getAccessToken();

              // assert
              await expectLater(result, throwsA(isA<Exception>()));
              verify(
                () => mockLocalStorage.get(StorageConstant.bearerToken),
              ).called(1);
            },
          );
        },
      );
    },
  );
}
