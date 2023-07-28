import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/profile.dart';
import '../../../core/constants/json_constant.dart'

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel extends Profile with _$ProfileModel {
  const ProfileModel._();
  factory ProfileModel({
    required String id,
    required String name,
    String? avatar,
    required bool isEmailVerified,
    required bool isPhoneVerified,
    DateTime? dateOfBirth,
    required String gender,
    String? phoneNumber,
    DateTime? suspendedUntil,
    DateTime? updatedAt,
  }) = _ProfileModel;
  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.fromJsonApi(Map<String, dynamic> json) {
    var id = json[JsonConstant.id];
    var attributes = json[JsonConstant.attributes];
    return _$ProfileModelFromJson({
      'id': id,
      ...attributes,
    },);
  }

  factory ProfileModel.fromEntity(Profile profile) => ProfileModel(
        id: profile.id,
        name: profile.name,
        isEmailVerified: profile.isEmailVerified,
        isPhoneVerified: profile.isPhoneVerified,
        gender: profile.gender,
        avatar: profile.avatar,
        dateOfBirth: profile.dateOfBirth,
        phoneNumber: profile.phoneNumber,
        suspendedUntil: profile.suspendedUntil,
        updatedAt: profile.updatedAt,
      );

  Profile toEntity() => Profile(
        id: id,
        name: name,
        avatar: avatar,
        email: email,
        isEmailVerified: isEmailVerified,
        isPhoneVerified: isPhoneVerified,
        dateOfBirth: dateOfBirth,
        gender: gender,
        phoneNumber: phoneNumber,
        suspendedUntil: suspendedUntil,
        updatedAt: updatedAt,
      );
}
