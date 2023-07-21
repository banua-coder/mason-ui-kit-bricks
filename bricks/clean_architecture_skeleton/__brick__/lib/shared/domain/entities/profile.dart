import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String name;
  final String? avatar;
  final String email;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime? dateOfBirth;
  final String gender;
  final String? phoneNumber;
  final DateTime? suspendedUntil;
  final DateTime? updatedAt;

  const Profile({
    this.id = '',
    this.name = '',
    this.avatar = '',
    this.email = '',
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.dateOfBirth,
    this.gender = '',
    this.phoneNumber = '',
    this.suspendedUntil,
    this.updatedAt,
  });

  bool get isSuspended => suspendedUntil != null;

  bool get isAccountVerified => isPhoneVerified && isEmailVerified;

  @override
  List<Object?> get props => [
        id,
        name,
        avatar,
        email,
        isEmailVerified,
        isPhoneVerified,
        dateOfBirth,
        gender,
        phoneNumber,
        suspendedUntil,
        updatedAt,
      ];
}
