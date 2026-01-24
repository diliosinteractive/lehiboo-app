import 'package:freezed_annotation/freezed_annotation.dart';
import 'auth_response_dto.dart';

part 'business_register_dto.freezed.dart';
part 'business_register_dto.g.dart';

/// DTO for business registration multi-step flow
@freezed
class BusinessRegisterDto with _$BusinessRegisterDto {
  const factory BusinessRegisterDto({
    // Personal Info (Step 1)
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    String? phone,
    required String password,
    @JsonKey(name: 'password_confirmation') required String passwordConfirmation,

    // Company Info (Step 3)
    @JsonKey(name: 'organization_type') @Default('company') String organizationType,
    @JsonKey(name: 'company_name') required String companyName,
    String? siret,
    String? industry,
    @JsonKey(name: 'employee_count') String? employeeCount,
    required String address,
    required String city,
    @JsonKey(name: 'postal_code') required String postalCode,
    @Default('FR') String country,

    // Usage Mode (Step 4)
    @JsonKey(name: 'usage_mode') required String usageMode,
    @JsonKey(name: 'team_emails') String? teamEmails,
    @JsonKey(name: 'default_budget') double? defaultBudget,

    // Terms (Step 5)
    @JsonKey(name: 'accept_terms') required bool acceptTerms,
    @JsonKey(name: 'accept_business_terms') required bool acceptBusinessTerms,
  }) = _BusinessRegisterDto;

  factory BusinessRegisterDto.fromJson(Map<String, dynamic> json) =>
      _$BusinessRegisterDtoFromJson(json);
}

/// Response from business registration
@freezed
class BusinessRegisterResponseDto with _$BusinessRegisterResponseDto {
  const factory BusinessRegisterResponseDto({
    required UserDto user,
    OrganizationDto? organization,
    required String token,
    @JsonKey(name: 'invitations_sent') @Default(0) int invitationsSent,
    @JsonKey(name: 'invited_emails') List<String>? invitedEmails,
  }) = _BusinessRegisterResponseDto;

  factory BusinessRegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BusinessRegisterResponseDtoFromJson(json);
}

/// Organization DTO
@freezed
class OrganizationDto with _$OrganizationDto {
  const factory OrganizationDto({
    required int id,
    required String uuid,
    // API returns "name" not "organization_name"
    required String name,
    String? slug,
    String? siret,
    String? address,
    String? city,
    // API returns "zipCode" not "postal_code"
    String? zipCode,
    String? country,
    String? industry,
    @JsonKey(name: 'employee_count') String? employeeCount,
    @JsonKey(name: 'isActive') bool? isActive,
    @JsonKey(name: 'isVerified') bool? isVerified,
    @JsonKey(name: 'createdAt') String? createdAt,
  }) = _OrganizationDto;

  factory OrganizationDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizationDtoFromJson(json);
}

/// OTP request DTO
@freezed
class OtpRequestDto with _$OtpRequestDto {
  const factory OtpRequestDto({
    required String email,
    required String type,
  }) = _OtpRequestDto;

  factory OtpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestDtoFromJson(json);
}

/// OTP verification DTO
@freezed
class OtpVerifyDto with _$OtpVerifyDto {
  const factory OtpVerifyDto({
    required String email,
    required String code,
    required String type,
  }) = _OtpVerifyDto;

  factory OtpVerifyDto.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyDtoFromJson(json);
}

/// Customer simple registration DTO
@freezed
class CustomerRegisterDto with _$CustomerRegisterDto {
  const factory CustomerRegisterDto({
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    required String password,
    @JsonKey(name: 'password_confirmation') required String passwordConfirmation,
    String? phone,
    @JsonKey(name: 'accept_terms') required bool acceptTerms,
  }) = _CustomerRegisterDto;

  factory CustomerRegisterDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerRegisterDtoFromJson(json);
}

/// Customer registration response
@freezed
class CustomerRegisterResponseDto with _$CustomerRegisterResponseDto {
  const factory CustomerRegisterResponseDto({
    required UserDto user,
    required String token,
    @JsonKey(name: 'email_verification_required') @Default(true) bool emailVerificationRequired,
  }) = _CustomerRegisterResponseDto;

  factory CustomerRegisterResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerRegisterResponseDtoFromJson(json);
}
