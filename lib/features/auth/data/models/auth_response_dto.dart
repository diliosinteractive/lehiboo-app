import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response_dto.freezed.dart';
part 'auth_response_dto.g.dart';

/// The Laravel backend returns the avatar under the key `avatar`, but earlier
/// API revisions used `avatar_url`. Read both so the field survives either.
Object? _readAvatar(Map<dynamic, dynamic> json, String _) =>
    json['avatar'] ?? json['avatar_url'];

@freezed
class AuthResponseDto with _$AuthResponseDto {
  const factory AuthResponseDto({
    required UserDto user,
    required TokensDto tokens,
  }) = _AuthResponseDto;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);
}

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    required int id,
    required String email,
    // Login/refresh returns "display_name", register returns "name"
    @JsonKey(name: 'display_name') String? displayName,
    String? name,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? phone,
    String? city,
    String? bio,
    @JsonKey(name: 'birth_date') String? birthDate,
    @JsonKey(name: 'membership_city') String? membershipCity,
    @JsonKey(name: 'avatar', readValue: _readAvatar) String? avatarUrl,
    required String role,
    @JsonKey(name: 'registered_at') String? registeredAt,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @Default(false) bool newsletter,
    @JsonKey(name: 'push_notifications_enabled') @Default(false) bool pushNotificationsEnabled,
    UserCapabilitiesDto? capabilities,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

@freezed
class UserCapabilitiesDto with _$UserCapabilitiesDto {
  const factory UserCapabilitiesDto({
    @JsonKey(name: 'can_book') @Default(true) bool canBook,
    @JsonKey(name: 'can_scan_tickets') @Default(false) bool canScanTickets,
    @JsonKey(name: 'can_manage_events') @Default(false) bool canManageEvents,
  }) = _UserCapabilitiesDto;

  factory UserCapabilitiesDto.fromJson(Map<String, dynamic> json) =>
      _$UserCapabilitiesDtoFromJson(json);
}

@freezed
class TokensDto with _$TokensDto {
  const factory TokensDto({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
    @JsonKey(name: 'expires_in') @Default(604800) int expiresIn,
  }) = _TokensDto;

  factory TokensDto.fromJson(Map<String, dynamic> json) =>
      _$TokensDtoFromJson(json);
}

@freezed
class ApiResponseDto<T> with _$ApiResponseDto<T> {
  const factory ApiResponseDto({
    required bool success,
    T? data,
    int? status,
  }) = _ApiResponseDto<T>;
}

@freezed
class ApiErrorDto with _$ApiErrorDto {
  const factory ApiErrorDto({
    required bool success,
    required ApiErrorDataDto data,
    int? status,
  }) = _ApiErrorDto;

  factory ApiErrorDto.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorDtoFromJson(json);
}

@freezed
class ApiErrorDataDto with _$ApiErrorDataDto {
  const factory ApiErrorDataDto({
    required String error,
    required String message,
    Map<String, dynamic>? details,
  }) = _ApiErrorDataDto;

  factory ApiErrorDataDto.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorDataDtoFromJson(json);
}
