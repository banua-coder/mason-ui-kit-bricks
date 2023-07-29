import '../dtos/profile_dto.dart'; // Import your ProfileDto
import '../models/profile_model.dart'; // Import your ProfileModel

class ProfileMapper {
  static ProfileModel fromDto(ProfileDto dto) {
    return ProfileModel(
      id: dto.id,
      name: dto.name,
      isEmailVerified: dto.isEmailVerified,
      isPhoneVerified: dto.isPhoneVerified,
      gender: dto.gender,
      avatar: dto.avatar,
      dateOfBirth: DateTime.tryParse(dto.dateOfBirth ?? ''),
      phoneNumber: dto.phoneNumber,
      suspendedUntil: DateTime.tryParse(dto.suspendedUntil ?? ''),
      updatedAt: DateTime.tryParse(dto.updatedAt ?? ''),
    );
  }
}
