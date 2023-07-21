import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{name.snakeCase()}}/core/exception/exceptions.dart';
import 'package:{{name.snakeCase()}}/core/failures/failures.dart';
import 'package:{{name.snakeCase()}}/shared/data/data_sources/access_token_local_data_source.dart';
import 'package:{{name.snakeCase()}}/shared/data/repositories/access_token_repository_impl.dart';
import 'package:{{name.snakeCase()}}/shared/domain/repositories/access_token_repository.dart';

import '../../../../helpers/test_injection.dart';

class MockAccessTokenLocalDataSource extends Mock
    implements AccessTokenLocalDataSource {}

void main() {
  late AccessTokenLocalDataSource mockLocalDataSource;
  late AccessTokenRepository repository;

  setUpAll(
    () {
      mockLocalDataSource = MockAccessTokenLocalDataSource();
      registerTestLazySingleton<AccessTokenLocalDataSource>(
        mockLocalDataSource,
      );
      repository = AccessTokenRepositoryImpl();
    },
  );

  var token = 'hkagS815hSd210&#@1mdahasddaf';

  group(
    'AccessTokenRepository',
    () {
      group(
        'deleteAccessToken',
        () {
          test(
            'should return true if access token successfully deleted',
            () async {
              when(
                () => mockLocalDataSource.deleteAccessToken(),
              ).thenAnswer(
                (_) async => true,
              );

              var result = await repository.deleteAccessToken();

              expect(result, const Right(true));
              verify(
                () => mockLocalDataSource.deleteAccessToken(),
              ).called(1);
            },
          );

          test(
            'should return false if access token not deleted`',
            () async {
              // arrange
              when(
                () => mockLocalDataSource.deleteAccessToken(),
              ).thenAnswer((_) async => false);

              // act
              var result = await repository.deleteAccessToken();

              // assert
              expect(result, const Right(false));
              verify(
                () => mockLocalDataSource.deleteAccessToken(),
              ).called(1);
            },
          );

          test(
            'should return ClientFailure if exception occured',
            () async {
              // arrange
              when(
                () => mockLocalDataSource.deleteAccessToken(),
              ).thenThrow(Exception());

              // act
              var result = await repository.deleteAccessToken();

              // assert
              expect(
                result,
                Left(
                  ClientFailure(),
                ),
              );
              verify(
                () => mockLocalDataSource.deleteAccessToken(),
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
                () => mockLocalDataSource.hasAccessToken(),
              ).thenAnswer((_) async => true);

              // act
              var result = await repository.hasAccessToken();

              // assert
              expect(result, const Right(true));
              verify(
                () => mockLocalDataSource.hasAccessToken(),
              ).called(1);
            },
          );

          test(
            'should return false if access token does not exist',
            () async {
              // arrange
              when(
                () => mockLocalDataSource.hasAccessToken(),
              ).thenAnswer((_) async => false);

              // act
              var result = await repository.hasAccessToken();

              // assert
              expect(result, const Right(false));
              verify(
                () => mockLocalDataSource.hasAccessToken(),
              ).called(1);
            },
          );

          test(
            'should return ClientFailure if exception occured!',
            () async {
              // arrange
              when(
                () => mockLocalDataSource.hasAccessToken(),
              ).thenThrow(Exception());

              // act
              var result = await repository.hasAccessToken();

              // assert
              expect(
                result,
                Left(
                  ClientFailure(),
                ),
              );
              verify(
                () => mockLocalDataSource.hasAccessToken(),
              ).called(1);
            },
          );
        },
      );

      group(
        'saveAccessToken',
        () {
          test(
            'should return true if access token successfully saved',
            () async {
              // arrange
              when(
                () => mockLocalDataSource.saveAccessToken(token),
              ).thenAnswer((_) async => true);

              // act
              var result = await repository.saveAccessToken(token);

              // assert
              expect(result, const Right(true));
              verify(
                () => mockLocalDataSource.saveAccessToken(token),
              ).called(1);
            },
          );

          test(
            'should return false if access token not saved',
            () async {
              // arrange
              when(
                () => mockLocalDataSource.saveAccessToken(token),
              ).thenAnswer((_) async => false);

              // act
              var result = await repository.saveAccessToken(token);

              // assert
              expect(result, const Right(false));
              verify(
                () => mockLocalDataSource.saveAccessToken(token),
              ).called(1);
            },
          );

          test(
            'should return ClientFailure if exception occured',
            () async {
              // arrange
              when(
                () => mockLocalDataSource.saveAccessToken(token),
              ).thenThrow(Exception());

              // act
              var result = await repository.saveAccessToken(token);

              // assert
              expect(
                result,
                Left(
                  ClientFailure(),
                ),
              );
              verify(
                () => mockLocalDataSource.saveAccessToken(token),
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
                () => mockLocalDataSource.getAccessToken(),
              ).thenAnswer((_) async => token);

              // act
              var result = await repository.getAccessToken();

              // assert
              expect(result, Right(token));
              verify(
                () => mockLocalDataSource.getAccessToken(),
              ).called(1);
            },
          );

          test(
            'should return NotFoundFailure if access token not exist',
            () async {
              // arrange
              when(
                () => mockLocalDataSource.getAccessToken(),
              ).thenThrow(NotFoundException());

              // act
              var result = await repository.getAccessToken();

              // assert
              expect(result, Left(NotFoundFailure()));
              verify(
                () => mockLocalDataSource.getAccessToken(),
              ).called(1);
            },
          );

          test(
            'should return ClientFailure if unknown exception occured',
            () async {
              // arrange
              when(
                () => mockLocalDataSource.getAccessToken(),
              ).thenThrow(Exception());

              // act
              var result = await repository.getAccessToken();

              // assert
              expect(result, Left(ClientFailure()));
              verify(
                () => mockLocalDataSource.getAccessToken(),
              ).called(1);
            },
          );
        },
      );
    },
  );
}
