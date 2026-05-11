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
    String? membershipCity,
    @Default(UserRole.subscriber) UserRole role,
    DateTime? registeredAt,
    @Default(false) bool isVerified,
    @Default(false) bool newsletter,
    @Default(false) bool pushNotificationsEnabled,
    /// OneSignal external user id assigned by the backend.
    /// Used as `external_id` for `OneSignal.login()` and as `external_user_id`
    /// in the `POST /auth/device-tokens` payload. Nullable: legacy users may
    /// not have one yet — in that case we skip the OneSignal binding and the
    /// device-token is registered without `external_user_id`.
    String? onesignalId,
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
