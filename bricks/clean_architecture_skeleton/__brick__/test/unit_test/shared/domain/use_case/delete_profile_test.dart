import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{name.snakeCase()}}/core/failures/failures.dart';
import 'package:{{name.snakeCase()}}/core/use_case/use_case.dart';
import 'package:{{name.snakeCase()}}/shared/domain/repositories/profile_repository.dart';
import 'package:{{name.snakeCase()}}/shared/domain/use_case/delete_profile.dart';

import '../../../../helpers/test_injection.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late ProfileRepository mockRepository;
  late DeleteProfile usecase;

  setUpAll(
    () {
      mockRepository = MockProfileRepository();
      registerTestLazySingleton<ProfileRepository>(mockRepository);
      usecase = DeleteProfile();
    },
  );

  group(
    'DeleteProfile',
    () {
      test(
        'should return true if profile successfully deleted!',
        () async {
          when(
            () => mockRepository.deleteProfile(),
          ).thenAnswer((_) async => const Right(true));

          var result = await usecase(NoParams());

          expect(result, const Right(true));
          verify(
            () => mockRepository.deleteProfile(),
          ).called(1);
        },
      );

      test(
        'should return false if profile not deleted!',
        () async {
          when(
            () => mockRepository.deleteProfile(),
          ).thenAnswer((_) async => const Right(false));

          var result = await usecase(NoParams());

          expect(result, const Right(false));
          verify(
            () => mockRepository.deleteProfile(),
          ).called(1);
        },
      );

      test(
        'should return NotFoundFailure if profile does not exist!',
        () async {
          when(
            () => mockRepository.deleteProfile(),
          ).thenAnswer((_) async => Left(NotFoundFailure()));

          var result = await usecase(NoParams());

          expect(result, Left(NotFoundFailure()));
          verify(
            () => mockRepository.deleteProfile(),
          ).called(1);
        },
      );

      test(
        'should throw right exception when exception occured!',
        () async {
          when(
            () => mockRepository.deleteProfile(),
          ).thenThrow(Exception());

          var result = usecase(NoParams());

          await expectLater(result, throwsA(isA<Exception>()));
          verify(
            () => mockRepository.deleteProfile(),
          ).called(1);
        },
      );
    },
  );
}
