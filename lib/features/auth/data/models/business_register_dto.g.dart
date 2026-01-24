// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_register_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessRegisterDtoImpl _$$BusinessRegisterDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessRegisterDtoImpl(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      password: json['password'] as String,
      passwordConfirmation: json['password_confirmation'] as String,
      organizationType: json['organization_type'] as String? ?? 'company',
      companyName: json['company_name'] as String,
      siret: json['siret'] as String?,
      industry: json['industry'] as String?,
      employeeCount: json['employee_count'] as String?,
      address: json['address'] as String,
      city: json['city'] as String,
      postalCode: json['postal_code'] as String,
      country: json['country'] as String? ?? 'FR',
      usageMode: json['usage_mode'] as String,
      teamEmails: json['team_emails'] as String?,
      defaultBudget: (json['default_budget'] as num?)?.toDouble(),
      acceptTerms: json['accept_terms'] as bool,
      acceptBusinessTerms: json['accept_business_terms'] as bool,
    );

Map<String, dynamic> _$$BusinessRegisterDtoImplToJson(
        _$BusinessRegisterDtoImpl instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'password_confirmation': instance.passwordConfirmation,
      'organization_type': instance.organizationType,
      'company_name': instance.companyName,
      'siret': instance.siret,
      'industry': instance.industry,
      'employee_count': instance.employeeCount,
      'address': instance.address,
      'city': instance.city,
      'postal_code': instance.postalCode,
      'country': instance.country,
      'usage_mode': instance.usageMode,
      'team_emails': instance.teamEmails,
      'default_budget': instance.defaultBudget,
      'accept_terms': instance.acceptTerms,
      'accept_business_terms': instance.acceptBusinessTerms,
    };

_$BusinessRegisterResponseDtoImpl _$$BusinessRegisterResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessRegisterResponseDtoImpl(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      organization: json['organization'] == null
          ? null
          : OrganizationDto.fromJson(
              json['organization'] as Map<String, dynamic>),
      token: json['token'] as String,
      invitationsSent: (json['invitations_sent'] as num?)?.toInt() ?? 0,
      invitedEmails: (json['invited_emails'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$BusinessRegisterResponseDtoImplToJson(
        _$BusinessRegisterResponseDtoImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'organization': instance.organization,
      'token': instance.token,
      'invitations_sent': instance.invitationsSent,
      'invited_emails': instance.invitedEmails,
    };

_$OrganizationDtoImpl _$$OrganizationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationDtoImpl(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      siret: json['siret'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
      industry: json['industry'] as String?,
      employeeCount: json['employee_count'] as String?,
      isActive: json['isActive'] as bool?,
      isVerified: json['isVerified'] as bool?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$OrganizationDtoImplToJson(
        _$OrganizationDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'name': instance.name,
      'slug': instance.slug,
      'siret': instance.siret,
      'address': instance.address,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'country': instance.country,
      'industry': instance.industry,
      'employee_count': instance.employeeCount,
      'isActive': instance.isActive,
      'isVerified': instance.isVerified,
      'createdAt': instance.createdAt,
    };

_$OtpRequestDtoImpl _$$OtpRequestDtoImplFromJson(Map<String, dynamic> json) =>
    _$OtpRequestDtoImpl(
      email: json['email'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$OtpRequestDtoImplToJson(_$OtpRequestDtoImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'type': instance.type,
    };

_$OtpVerifyDtoImpl _$$OtpVerifyDtoImplFromJson(Map<String, dynamic> json) =>
    _$OtpVerifyDtoImpl(
      email: json['email'] as String,
      code: json['code'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$OtpVerifyDtoImplToJson(_$OtpVerifyDtoImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'code': instance.code,
      'type': instance.type,
    };

_$CustomerRegisterDtoImpl _$$CustomerRegisterDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomerRegisterDtoImpl(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      passwordConfirmation: json['password_confirmation'] as String,
      phone: json['phone'] as String?,
      acceptTerms: json['accept_terms'] as bool,
    );

Map<String, dynamic> _$$CustomerRegisterDtoImplToJson(
        _$CustomerRegisterDtoImpl instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'password_confirmation': instance.passwordConfirmation,
      'phone': instance.phone,
      'accept_terms': instance.acceptTerms,
    };

_$CustomerRegisterResponseDtoImpl _$$CustomerRegisterResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomerRegisterResponseDtoImpl(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      emailVerificationRequired:
          json['email_verification_required'] as bool? ?? true,
    );

Map<String, dynamic> _$$CustomerRegisterResponseDtoImplToJson(
        _$CustomerRegisterResponseDtoImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'email_verification_required': instance.emailVerificationRequired,
    };
