import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{name.snakeCase()}}/core/use_case/use_case.dart';
import 'package:{{name.snakeCase()}}/shared/domain/repositories/access_token_repository.dart';
import 'package:{{name.snakeCase()}}/shared/domain/use_case/has_access_token.dart';

import '../../../../helpers/test_injection.dart';

class MockAccessTokenRepository extends Mock implements AccessTokenRepository {}

void main() {
  late AccessTokenRepository mockRepository;
  late HasAccessToken usecase;

  setUpAll(
    () {
      mockRepository = MockAccessTokenRepository();
      registerTestLazySingleton<AccessTokenRepository>(mockRepository);
      usecase = HasAccessToken();
    },
  );

  group(
    'HasAccessToken',
    () {
      test(
        'should return true if access token exist!',
        () async {
          when(
            () => mockRepository.hasAccessToken(),
          ).thenAnswer((_) async => const Right(true));

          var result = await usecase(NoParams());

          expect(result, const Right(true));
          verify(
            () => mockRepository.hasAccessToken(),
          ).called(1);
        },
      );

      test(
        'should return false if access token does not exist!',
        () async {
          when(
            () => mockRepository.hasAccessToken(),
          ).thenAnswer((_) async => const Right(false));

          var result = await usecase(NoParams());

          expect(result, const Right(false));
          verify(
            () => mockRepository.hasAccessToken(),
          ).called(1);
        },
      );

      test(
        'should throw right exception when exception occured!',
        () async {
          when(
            () => mockRepository.hasAccessToken(),
          ).thenThrow(Exception());

          var result = usecase(NoParams());

          await expectLater(result, throwsA(isA<Exception>()));
          verify(
            () => mockRepository.hasAccessToken(),
          ).called(1);
        },
      );
    },
  );
}
