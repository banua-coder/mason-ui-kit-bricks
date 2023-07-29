import '../../../core/constants/json_constant.dart';

class ProfileDto {
  final String id;
  final String name;
  final String? avatar;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String gender;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? suspendedUntil;
  final String? updatedAt;

  ProfileDto({
    required this.id,
    required this.name,
    this.avatar,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.gender,
    this.phoneNumber,
    this.dateOfBirth,
    this.suspendedUntil,
    this.updatedAt,
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    var attributes = json[JsonConstant.attributes] as Map<String, dynamic>;
    return ProfileDto(
      id: json[JsonConstant.id] as String,
      name: attributes['name'] as String,
      avatar: attributes['avatar'] as String?,
      isEmailVerified: attributes['is_email_verified'] as bool,
      isPhoneVerified: attributes['is_phone_verified'] as bool,
      gender: attributes['gender'] as String,
      phoneNumber: attributes['phone_number'] as String?,
      dateOfBirth: attributes['date_of_birth'] as String?,
      suspendedUntil: attributes['suspended_until'] as String?,
      updatedAt: attributes['updated_at'] as String?,
    );
  }
}
