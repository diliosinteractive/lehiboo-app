// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResponseDtoImpl _$$AuthResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthResponseDtoImpl(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      tokens: TokensDto.fromJson(json['tokens'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResponseDtoImplToJson(
        _$AuthResponseDtoImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'tokens': instance.tokens,
    };

_$UserDtoImpl _$$UserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserDtoImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      displayName: json['display_name'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      bio: json['bio'] as String?,
      birthDate: json['birth_date'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
      registeredAt: json['registered_at'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      capabilities: json['capabilities'] == null
          ? null
          : UserCapabilitiesDto.fromJson(
              json['capabilities'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserDtoImplToJson(_$UserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'display_name': instance.displayName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone': instance.phone,
      'city': instance.city,
      'bio': instance.bio,
      'birth_date': instance.birthDate,
      'avatar_url': instance.avatarUrl,
      'role': instance.role,
      'registered_at': instance.registeredAt,
      'is_verified': instance.isVerified,
      'capabilities': instance.capabilities,
    };

_$UserCapabilitiesDtoImpl _$$UserCapabilitiesDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UserCapabilitiesDtoImpl(
      canBook: json['can_book'] as bool? ?? true,
      canScanTickets: json['can_scan_tickets'] as bool? ?? false,
      canManageEvents: json['can_manage_events'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserCapabilitiesDtoImplToJson(
        _$UserCapabilitiesDtoImpl instance) =>
    <String, dynamic>{
      'can_book': instance.canBook,
      'can_scan_tickets': instance.canScanTickets,
      'can_manage_events': instance.canManageEvents,
    };

_$TokensDtoImpl _$$TokensDtoImplFromJson(Map<String, dynamic> json) =>
    _$TokensDtoImpl(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: (json['expires_in'] as num?)?.toInt() ?? 604800,
    );

Map<String, dynamic> _$$TokensDtoImplToJson(_$TokensDtoImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
    };

_$ApiErrorDtoImpl _$$ApiErrorDtoImplFromJson(Map<String, dynamic> json) =>
    _$ApiErrorDtoImpl(
      success: json['success'] as bool,
      data: ApiErrorDataDto.fromJson(json['data'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ApiErrorDtoImplToJson(_$ApiErrorDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'status': instance.status,
    };

_$ApiErrorDataDtoImpl _$$ApiErrorDataDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ApiErrorDataDtoImpl(
      error: json['error'] as String,
      message: json['message'] as String,
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ApiErrorDataDtoImplToJson(
        _$ApiErrorDataDtoImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'details': instance.details,
    };
