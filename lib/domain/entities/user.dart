import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

enum UserRole { subscriber, partner, admin }

@freezed
class HbUser with _$HbUser {
  const factory HbUser({
    required String id,
    required String email,
    required String displayName,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    String? city,
    String? bio,
    DateTime? birthDate,
    @Default(UserRole.subscriber) UserRole role,
    DateTime? registeredAt,
    @Default(false) bool isVerified,
    @Default(UserCapabilities()) UserCapabilities capabilities,
    // Legacy fields for backwards compatibility
    List<String>? interestsCategoryIds,
  }) = _HbUser;
}

@freezed
class UserCapabilities with _$UserCapabilities {
  const factory UserCapabilities({
    @Default(true) bool canBook,
    @Default(false) bool canScanTickets,
    @Default(false) bool canManageEvents,
  }) = _UserCapabilities;
}
