import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{name.snakeCase()}}/core/failures/failures.dart';
import 'package:{{name.snakeCase()}}/core/use_case/use_case.dart';
import 'package:{{name.snakeCase()}}/shared/data/models/profile_model.dart';
import 'package:{{name.snakeCase()}}/shared/domain/entities/profile.dart';
import 'package:{{name.snakeCase()}}/shared/domain/repositories/profile_repository.dart';
import 'package:{{name.snakeCase()}}/shared/domain/use_case/get_profile.dart';

import '../../../../fixtures/fixtures.dart';
import '../../../../helpers/test_injection.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late ProfileRepository mockRepository;
  late GetProfile usecase;
  late Profile profile;

  setUpAll(
    () {
      mockRepository = MockProfileRepository();
      registerTestLazySingleton<ProfileRepository>(mockRepository);
      usecase = GetProfile();
      var json = jsonFromFixture('profile_fixture.json');
      profile = ProfileModel.fromJson(json);
    },
  );

  group(
    'GetProfile',
    () {
      test(
        'should return Profile if profile exist!',
        () async {
          when(
            () => mockRepository.getProfile(),
          ).thenAnswer((_) async => Right(profile));

          var result = await usecase(NoParams());

          expect(result, Right(profile));
          verify(
            () => mockRepository.getProfile(),
          ).called(1);
        },
      );

      test(
        'should return NotFoundFailure if profile not exist!',
        () async {
          when(
            () => mockRepository.getProfile(),
          ).thenAnswer((_) async => Left(NotFoundFailure()));

          var result = await usecase(NoParams());

          expect(result, Left(NotFoundFailure()));
          verify(
            () => mockRepository.getProfile(),
          ).called(1);
        },
      );
    },
  );
}
