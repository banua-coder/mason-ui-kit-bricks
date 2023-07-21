import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{name.snakeCase()}}/core/failures/failures.dart';
import 'package:{{name.snakeCase()}}/shared/data/models/profile_model.dart';
import 'package:{{name.snakeCase()}}/shared/domain/entities/profile.dart';
import 'package:{{name.snakeCase()}}/shared/domain/repositories/profile_repository.dart';
import 'package:{{name.snakeCase()}}/shared/domain/use_case/save_profile.dart';

import '../../../../fixtures/fixtures.dart';
import '../../../../helpers/test_injection.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late ProfileRepository mockRepository;
  late SaveProfile usecase;
  late Profile profile;

  setUpAll(
    () {
      mockRepository = MockProfileRepository();
      registerTestLazySingleton<ProfileRepository>(mockRepository);
      usecase = SaveProfile();
      var json = jsonFromFixture('profile_fixture.json');
      profile = ProfileModel.fromJson(json);
    },
  );

  group(
    'SaveProfile',
    () {
      test(
        'should return true if profile successfully save!',
        () async {
          when(
            () => mockRepository.saveProfile(profile),
          ).thenAnswer((_) async => const Right(true));

          var result = await usecase(profile);

          expect(result, const Right(true));
          verify(
            () => mockRepository.saveProfile(profile),
          ).called(1);
        },
      );

      test(
        'should return false if profile not saved!',
        () async {
          when(
            () => mockRepository.saveProfile(profile),
          ).thenAnswer((_) async => const Right(false));

          var result = await usecase(profile);

          expect(result, const Right(false));
          verify(
            () => mockRepository.saveProfile(profile),
          ).called(1);
        },
      );

      test(
        'should return ClientFailure if profile does not exist!',
        () async {
          when(
            () => mockRepository.saveProfile(profile),
          ).thenAnswer((_) async => Left(ClientFailure()));

          var result = await usecase(profile);

          expect(result, Left(ClientFailure()));
          verify(
            () => mockRepository.saveProfile(profile),
          ).called(1);
        },
      );

      test(
        'should throw right exception when exception occured!',
        () async {
          when(
            () => mockRepository.saveProfile(profile),
          ).thenThrow(Exception());

          var result = usecase(profile);

          await expectLater(result, throwsA(isA<Exception>()));
          verify(
            () => mockRepository.saveProfile(profile),
          ).called(1);
        },
      );
    },
  );
}
