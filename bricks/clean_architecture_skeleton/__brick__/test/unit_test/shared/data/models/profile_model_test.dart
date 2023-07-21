import 'package:flutter_test/flutter_test.dart';
import 'package:{{name.snakeCase()}}/shared/data/models/profile_model.dart';
import 'package:{{name.snakeCase()}}/shared/domain/entities/profile.dart';

import '../../../../fixtures/fixtures.dart';

void main() {
  group(
    'ProfileModel',
    () {
      test(
        'fromJson will built a ProfileModel from given json',
        () {
          var profile =
              ProfileModel.fromJson(jsonFromFixture('profile_fixture.json'));
          expect(profile, isA<ProfileModel>());
        },
      );

      test(
        'date_of_birth will be parsed to DateTime if present in json',
        () {
          var profile = ProfileModel.fromJson(
            {
              ...jsonFromFixture('profile_fixture.json'),
              ...{'date_of_birth': '2001-02-02'}
            },
          );
          expect(profile.dateOfBirth, DateTime(2001, 2, 2));
        },
      );

      test(
        'suspended_until will be parsed to DateTime if present in json',
        () {
          var suspendedUntil = DateTime.now().add(const Duration(days: 5));
          var profile = ProfileModel.fromJson(
            {
              ...jsonFromFixture('profile_fixture.json'),
              ...{'suspended_until': suspendedUntil.toString()}
            },
          );
          expect(
            profile.suspendedUntil,
            suspendedUntil,
          );
        },
      );

      test(
        'updated_at will be parsed to DateTime if present in json',
        () {
          var updatedAt = DateTime.now();
          var profile = ProfileModel.fromJson(
            {
              ...jsonFromFixture('profile_fixture.json'),
              ...{'updated_at': updatedAt.toString()}
            },
          );
          expect(
            profile.updatedAt,
            updatedAt,
          );
        },
      );

      test(
        'toJson will be parsed to json',
        () {
          var json = jsonFromFixture('profile_fixture.json');

          var profile = ProfileModel.fromJson(json);

          expect(
            profile.toJson(),
            json,
          );
        },
      );

      test(
        'toEntity will convert ProfileModel to Profile',
        () {
          var json = jsonFromFixture('profile_fixture.json');

          var profile = ProfileModel.fromJson(json);

          expect(
            profile.toEntity(),
            isA<Profile>(),
          );
        },
      );
    },
  );
}
