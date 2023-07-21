import 'package:flutter_test/flutter_test.dart';
import 'package:{{name.snakeCase()}}/shared/data/models/profile_model.dart';
import 'package:{{name.snakeCase()}}/shared/domain/entities/profile.dart';

import '../../../../fixtures/fixtures.dart';

void main() {
  late Profile profile;
  late ProfileModel newProfile;

  setUp(
    () {
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
        suspendedUntil: DateTime.now().add(const Duration(days: 5)),
        updatedAt: profile.updatedAt,
      );
    },
  );

  group(
    'ProfileEntity',
    () {
      test(
        'isAccountVerified is false if either isEmailVerified or isPhoneVerified is false',
        () => expect(profile.isAccountVerified, isFalse),
      );

      test(
        'isAccountVerified is true if both isEmailVerified and isPhoneVerified is true',
        () => expect(newProfile.isAccountVerified, isTrue),
      );

      test(
        'isSuspended is false if suspendedUntil is null',
        () => expect(profile.isSuspended, isFalse),
      );

      test(
        'isSuspended if suspended until is not null',
        () => expect(newProfile.isSuspended, isTrue),
      );
    },
  );
}
