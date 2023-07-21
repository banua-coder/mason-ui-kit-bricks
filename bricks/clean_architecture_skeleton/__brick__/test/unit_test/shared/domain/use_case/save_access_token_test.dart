import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{name.snakeCase()}}/shared/domain/repositories/access_token_repository.dart';
import 'package:{{name.snakeCase()}}/shared/domain/use_case/save_access_token.dart';

import '../../../../helpers/test_injection.dart';

class MockAccessTokenRepository extends Mock implements AccessTokenRepository {}

void main() {
  late AccessTokenRepository mockRepository;
  late SaveAccessToken usecase;

  setUpAll(
    () {
      mockRepository = MockAccessTokenRepository();
      registerTestLazySingleton<AccessTokenRepository>(mockRepository);
      usecase = SaveAccessToken();
    },
  );
  const token = '125ksa2l10sV<a9aD';
  group(
    'SaveAccessToken',
    () {
      test(
        'should return true if access token saved successfully!',
        () async {
          when(
            () => mockRepository.saveAccessToken(token),
          ).thenAnswer((_) async => const Right(true));

          var result = await usecase(token);

          expect(result, const Right(true));
          verify(
            () => mockRepository.saveAccessToken(token),
          ).called(1);
        },
      );

      test(
        'should return false if access token does not saved!',
        () async {
          when(
            () => mockRepository.saveAccessToken(token),
          ).thenAnswer((_) async => const Right(false));

          var result = await usecase(token);

          expect(result, const Right(false));
          verify(
            () => mockRepository.saveAccessToken(token),
          ).called(1);
        },
      );

      test(
        'should throw right exception when exception occured!',
        () async {
          when(
            () => mockRepository.saveAccessToken(token),
          ).thenThrow(Exception());

          var result = usecase(token);

          await expectLater(result, throwsA(isA<Exception>()));
          verify(
            () => mockRepository.saveAccessToken(token),
          ).called(1);
        },
      );
    },
  );
}
