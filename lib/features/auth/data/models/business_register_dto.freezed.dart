// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_register_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusinessRegisterDto _$BusinessRegisterDtoFromJson(Map<String, dynamic> json) {
  return _BusinessRegisterDto.fromJson(json);
}

/// @nodoc
mixin _$BusinessRegisterDto {
// Personal Info (Step 1)
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'password_confirmation')
  String get passwordConfirmation =>
      throw _privateConstructorUsedError; // Company Info (Step 3)
  @JsonKey(name: 'organization_type')
  String get organizationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  String? get siret => throw _privateConstructorUsedError;
  String? get industry => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_count')
  String? get employeeCount => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'postal_code')
  String get postalCode => throw _privateConstructorUsedError;
  String get country =>
      throw _privateConstructorUsedError; // Usage Mode (Step 4)
  @JsonKey(name: 'usage_mode')
  String get usageMode => throw _privateConstructorUsedError;
  @JsonKey(name: 'team_emails')
  String? get teamEmails => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_budget')
  double? get defaultBudget =>
      throw _privateConstructorUsedError; // Terms (Step 5)
  @JsonKey(name: 'accept_terms')
  bool get acceptTerms => throw _privateConstructorUsedError;
  @JsonKey(name: 'accept_business_terms')
  bool get acceptBusinessTerms => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessRegisterDtoCopyWith<BusinessRegisterDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessRegisterDtoCopyWith<$Res> {
  factory $BusinessRegisterDtoCopyWith(
          BusinessRegisterDto value, $Res Function(BusinessRegisterDto) then) =
      _$BusinessRegisterDtoCopyWithImpl<$Res, BusinessRegisterDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String email,
      String? phone,
      String password,
      @JsonKey(name: 'password_confirmation') String passwordConfirmation,
      @JsonKey(name: 'organization_type') String organizationType,
      @JsonKey(name: 'company_name') String companyName,
      String? siret,
      String? industry,
      @JsonKey(name: 'employee_count') String? employeeCount,
      String address,
      String city,
      @JsonKey(name: 'postal_code') String postalCode,
      String country,
      @JsonKey(name: 'usage_mode') String usageMode,
      @JsonKey(name: 'team_emails') String? teamEmails,
      @JsonKey(name: 'default_budget') double? defaultBudget,
      @JsonKey(name: 'accept_terms') bool acceptTerms,
      @JsonKey(name: 'accept_business_terms') bool acceptBusinessTerms});
}

/// @nodoc
class _$BusinessRegisterDtoCopyWithImpl<$Res, $Val extends BusinessRegisterDto>
    implements $BusinessRegisterDtoCopyWith<$Res> {
  _$BusinessRegisterDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = freezed,
    Object? password = null,
    Object? passwordConfirmation = null,
    Object? organizationType = null,
    Object? companyName = null,
    Object? siret = freezed,
    Object? industry = freezed,
    Object? employeeCount = freezed,
    Object? address = null,
    Object? city = null,
    Object? postalCode = null,
    Object? country = null,
    Object? usageMode = null,
    Object? teamEmails = freezed,
    Object? defaultBudget = freezed,
    Object? acceptTerms = null,
    Object? acceptBusinessTerms = null,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordConfirmation: null == passwordConfirmation
          ? _value.passwordConfirmation
          : passwordConfirmation // ignore: cast_nullable_to_non_nullable
              as String,
      organizationType: null == organizationType
          ? _value.organizationType
          : organizationType // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      siret: freezed == siret
          ? _value.siret
          : siret // ignore: cast_nullable_to_non_nullable
              as String?,
      industry: freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeCount: freezed == employeeCount
          ? _value.employeeCount
          : employeeCount // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      usageMode: null == usageMode
          ? _value.usageMode
          : usageMode // ignore: cast_nullable_to_non_nullable
              as String,
      teamEmails: freezed == teamEmails
          ? _value.teamEmails
          : teamEmails // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultBudget: freezed == defaultBudget
          ? _value.defaultBudget
          : defaultBudget // ignore: cast_nullable_to_non_nullable
              as double?,
      acceptTerms: null == acceptTerms
          ? _value.acceptTerms
          : acceptTerms // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptBusinessTerms: null == acceptBusinessTerms
          ? _value.acceptBusinessTerms
          : acceptBusinessTerms // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessRegisterDtoImplCopyWith<$Res>
    implements $BusinessRegisterDtoCopyWith<$Res> {
  factory _$$BusinessRegisterDtoImplCopyWith(_$BusinessRegisterDtoImpl value,
          $Res Function(_$BusinessRegisterDtoImpl) then) =
      __$$BusinessRegisterDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String email,
      String? phone,
      String password,
      @JsonKey(name: 'password_confirmation') String passwordConfirmation,
      @JsonKey(name: 'organization_type') String organizationType,
      @JsonKey(name: 'company_name') String companyName,
      String? siret,
      String? industry,
      @JsonKey(name: 'employee_count') String? employeeCount,
      String address,
      String city,
      @JsonKey(name: 'postal_code') String postalCode,
      String country,
      @JsonKey(name: 'usage_mode') String usageMode,
      @JsonKey(name: 'team_emails') String? teamEmails,
      @JsonKey(name: 'default_budget') double? defaultBudget,
      @JsonKey(name: 'accept_terms') bool acceptTerms,
      @JsonKey(name: 'accept_business_terms') bool acceptBusinessTerms});
}

/// @nodoc
class __$$BusinessRegisterDtoImplCopyWithImpl<$Res>
    extends _$BusinessRegisterDtoCopyWithImpl<$Res, _$BusinessRegisterDtoImpl>
    implements _$$BusinessRegisterDtoImplCopyWith<$Res> {
  __$$BusinessRegisterDtoImplCopyWithImpl(_$BusinessRegisterDtoImpl _value,
      $Res Function(_$BusinessRegisterDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? phone = freezed,
    Object? password = null,
    Object? passwordConfirmation = null,
    Object? organizationType = null,
    Object? companyName = null,
    Object? siret = freezed,
    Object? industry = freezed,
    Object? employeeCount = freezed,
    Object? address = null,
    Object? city = null,
    Object? postalCode = null,
    Object? country = null,
    Object? usageMode = null,
    Object? teamEmails = freezed,
    Object? defaultBudget = freezed,
    Object? acceptTerms = null,
    Object? acceptBusinessTerms = null,
  }) {
    return _then(_$BusinessRegisterDtoImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordConfirmation: null == passwordConfirmation
          ? _value.passwordConfirmation
          : passwordConfirmation // ignore: cast_nullable_to_non_nullable
              as String,
      organizationType: null == organizationType
          ? _value.organizationType
          : organizationType // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      siret: freezed == siret
          ? _value.siret
          : siret // ignore: cast_nullable_to_non_nullable
              as String?,
      industry: freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeCount: freezed == employeeCount
          ? _value.employeeCount
          : employeeCount // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      usageMode: null == usageMode
          ? _value.usageMode
          : usageMode // ignore: cast_nullable_to_non_nullable
              as String,
      teamEmails: freezed == teamEmails
          ? _value.teamEmails
          : teamEmails // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultBudget: freezed == defaultBudget
          ? _value.defaultBudget
          : defaultBudget // ignore: cast_nullable_to_non_nullable
              as double?,
      acceptTerms: null == acceptTerms
          ? _value.acceptTerms
          : acceptTerms // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptBusinessTerms: null == acceptBusinessTerms
          ? _value.acceptBusinessTerms
          : acceptBusinessTerms // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessRegisterDtoImpl implements _BusinessRegisterDto {
  const _$BusinessRegisterDtoImpl(
      {@JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      required this.email,
      this.phone,
      required this.password,
      @JsonKey(name: 'password_confirmation')
      required this.passwordConfirmation,
      @JsonKey(name: 'organization_type') this.organizationType = 'company',
      @JsonKey(name: 'company_name') required this.companyName,
      this.siret,
      this.industry,
      @JsonKey(name: 'employee_count') this.employeeCount,
      required this.address,
      required this.city,
      @JsonKey(name: 'postal_code') required this.postalCode,
      this.country = 'FR',
      @JsonKey(name: 'usage_mode') required this.usageMode,
      @JsonKey(name: 'team_emails') this.teamEmails,
      @JsonKey(name: 'default_budget') this.defaultBudget,
      @JsonKey(name: 'accept_terms') required this.acceptTerms,
      @JsonKey(name: 'accept_business_terms')
      required this.acceptBusinessTerms});

  factory _$BusinessRegisterDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessRegisterDtoImplFromJson(json);

// Personal Info (Step 1)
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  final String email;
  @override
  final String? phone;
  @override
  final String password;
  @override
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;
// Company Info (Step 3)
  @override
  @JsonKey(name: 'organization_type')
  final String organizationType;
  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  @override
  final String? siret;
  @override
  final String? industry;
  @override
  @JsonKey(name: 'employee_count')
  final String? employeeCount;
  @override
  final String address;
  @override
  final String city;
  @override
  @JsonKey(name: 'postal_code')
  final String postalCode;
  @override
  @JsonKey()
  final String country;
// Usage Mode (Step 4)
  @override
  @JsonKey(name: 'usage_mode')
  final String usageMode;
  @override
  @JsonKey(name: 'team_emails')
  final String? teamEmails;
  @override
  @JsonKey(name: 'default_budget')
  final double? defaultBudget;
// Terms (Step 5)
  @override
  @JsonKey(name: 'accept_terms')
  final bool acceptTerms;
  @override
  @JsonKey(name: 'accept_business_terms')
  final bool acceptBusinessTerms;

  @override
  String toString() {
    return 'BusinessRegisterDto(firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, password: $password, passwordConfirmation: $passwordConfirmation, organizationType: $organizationType, companyName: $companyName, siret: $siret, industry: $industry, employeeCount: $employeeCount, address: $address, city: $city, postalCode: $postalCode, country: $country, usageMode: $usageMode, teamEmails: $teamEmails, defaultBudget: $defaultBudget, acceptTerms: $acceptTerms, acceptBusinessTerms: $acceptBusinessTerms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessRegisterDtoImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordConfirmation, passwordConfirmation) ||
                other.passwordConfirmation == passwordConfirmation) &&
            (identical(other.organizationType, organizationType) ||
                other.organizationType == organizationType) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.siret, siret) || other.siret == siret) &&
            (identical(other.industry, industry) ||
                other.industry == industry) &&
            (identical(other.employeeCount, employeeCount) ||
                other.employeeCount == employeeCount) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.usageMode, usageMode) ||
                other.usageMode == usageMode) &&
            (identical(other.teamEmails, teamEmails) ||
                other.teamEmails == teamEmails) &&
            (identical(other.defaultBudget, defaultBudget) ||
                other.defaultBudget == defaultBudget) &&
            (identical(other.acceptTerms, acceptTerms) ||
                other.acceptTerms == acceptTerms) &&
            (identical(other.acceptBusinessTerms, acceptBusinessTerms) ||
                other.acceptBusinessTerms == acceptBusinessTerms));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        firstName,
        lastName,
        email,
        phone,
        password,
        passwordConfirmation,
        organizationType,
        companyName,
        siret,
        industry,
        employeeCount,
        address,
        city,
        postalCode,
        country,
        usageMode,
        teamEmails,
        defaultBudget,
        acceptTerms,
        acceptBusinessTerms
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessRegisterDtoImplCopyWith<_$BusinessRegisterDtoImpl> get copyWith =>
      __$$BusinessRegisterDtoImplCopyWithImpl<_$BusinessRegisterDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessRegisterDtoImplToJson(
      this,
    );
  }
}

abstract class _BusinessRegisterDto implements BusinessRegisterDto {
  const factory _BusinessRegisterDto(
      {@JsonKey(name: 'first_name') required final String firstName,
      @JsonKey(name: 'last_name') required final String lastName,
      required final String email,
      final String? phone,
      required final String password,
      @JsonKey(name: 'password_confirmation')
      required final String passwordConfirmation,
      @JsonKey(name: 'organization_type') final String organizationType,
      @JsonKey(name: 'company_name') required final String companyName,
      final String? siret,
      final String? industry,
      @JsonKey(name: 'employee_count') final String? employeeCount,
      required final String address,
      required final String city,
      @JsonKey(name: 'postal_code') required final String postalCode,
      final String country,
      @JsonKey(name: 'usage_mode') required final String usageMode,
      @JsonKey(name: 'team_emails') final String? teamEmails,
      @JsonKey(name: 'default_budget') final double? defaultBudget,
      @JsonKey(name: 'accept_terms') required final bool acceptTerms,
      @JsonKey(name: 'accept_business_terms')
      required final bool acceptBusinessTerms}) = _$BusinessRegisterDtoImpl;

  factory _BusinessRegisterDto.fromJson(Map<String, dynamic> json) =
      _$BusinessRegisterDtoImpl.fromJson;

  @override // Personal Info (Step 1)
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  String get email;
  @override
  String? get phone;
  @override
  String get password;
  @override
  @JsonKey(name: 'password_confirmation')
  String get passwordConfirmation;
  @override // Company Info (Step 3)
  @JsonKey(name: 'organization_type')
  String get organizationType;
  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  String? get siret;
  @override
  String? get industry;
  @override
  @JsonKey(name: 'employee_count')
  String? get employeeCount;
  @override
  String get address;
  @override
  String get city;
  @override
  @JsonKey(name: 'postal_code')
  String get postalCode;
  @override
  String get country;
  @override // Usage Mode (Step 4)
  @JsonKey(name: 'usage_mode')
  String get usageMode;
  @override
  @JsonKey(name: 'team_emails')
  String? get teamEmails;
  @override
  @JsonKey(name: 'default_budget')
  double? get defaultBudget;
  @override // Terms (Step 5)
  @JsonKey(name: 'accept_terms')
  bool get acceptTerms;
  @override
  @JsonKey(name: 'accept_business_terms')
  bool get acceptBusinessTerms;
  @override
  @JsonKey(ignore: true)
  _$$BusinessRegisterDtoImplCopyWith<_$BusinessRegisterDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BusinessRegisterResponseDto _$BusinessRegisterResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _BusinessRegisterResponseDto.fromJson(json);
}

/// @nodoc
mixin _$BusinessRegisterResponseDto {
  UserDto get user => throw _privateConstructorUsedError;
  OrganizationDto? get organization => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'invitations_sent')
  int get invitationsSent => throw _privateConstructorUsedError;
  @JsonKey(name: 'invited_emails')
  List<String>? get invitedEmails => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessRegisterResponseDtoCopyWith<BusinessRegisterResponseDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessRegisterResponseDtoCopyWith<$Res> {
  factory $BusinessRegisterResponseDtoCopyWith(
          BusinessRegisterResponseDto value,
          $Res Function(BusinessRegisterResponseDto) then) =
      _$BusinessRegisterResponseDtoCopyWithImpl<$Res,
          BusinessRegisterResponseDto>;
  @useResult
  $Res call(
      {UserDto user,
      OrganizationDto? organization,
      String token,
      @JsonKey(name: 'invitations_sent') int invitationsSent,
      @JsonKey(name: 'invited_emails') List<String>? invitedEmails});

  $UserDtoCopyWith<$Res> get user;
  $OrganizationDtoCopyWith<$Res>? get organization;
}

/// @nodoc
class _$BusinessRegisterResponseDtoCopyWithImpl<$Res,
        $Val extends BusinessRegisterResponseDto>
    implements $BusinessRegisterResponseDtoCopyWith<$Res> {
  _$BusinessRegisterResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? organization = freezed,
    Object? token = null,
    Object? invitationsSent = null,
    Object? invitedEmails = freezed,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserDto,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as OrganizationDto?,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      invitationsSent: null == invitationsSent
          ? _value.invitationsSent
          : invitationsSent // ignore: cast_nullable_to_non_nullable
              as int,
      invitedEmails: freezed == invitedEmails
          ? _value.invitedEmails
          : invitedEmails // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<$Res> get user {
    return $UserDtoCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizationDtoCopyWith<$Res>? get organization {
    if (_value.organization == null) {
      return null;
    }

    return $OrganizationDtoCopyWith<$Res>(_value.organization!, (value) {
      return _then(_value.copyWith(organization: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BusinessRegisterResponseDtoImplCopyWith<$Res>
    implements $BusinessRegisterResponseDtoCopyWith<$Res> {
  factory _$$BusinessRegisterResponseDtoImplCopyWith(
          _$BusinessRegisterResponseDtoImpl value,
          $Res Function(_$BusinessRegisterResponseDtoImpl) then) =
      __$$BusinessRegisterResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserDto user,
      OrganizationDto? organization,
      String token,
      @JsonKey(name: 'invitations_sent') int invitationsSent,
      @JsonKey(name: 'invited_emails') List<String>? invitedEmails});

  @override
  $UserDtoCopyWith<$Res> get user;
  @override
  $OrganizationDtoCopyWith<$Res>? get organization;
}

/// @nodoc
class __$$BusinessRegisterResponseDtoImplCopyWithImpl<$Res>
    extends _$BusinessRegisterResponseDtoCopyWithImpl<$Res,
        _$BusinessRegisterResponseDtoImpl>
    implements _$$BusinessRegisterResponseDtoImplCopyWith<$Res> {
  __$$BusinessRegisterResponseDtoImplCopyWithImpl(
      _$BusinessRegisterResponseDtoImpl _value,
      $Res Function(_$BusinessRegisterResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? organization = freezed,
    Object? token = null,
    Object? invitationsSent = null,
    Object? invitedEmails = freezed,
  }) {
    return _then(_$BusinessRegisterResponseDtoImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserDto,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as OrganizationDto?,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      invitationsSent: null == invitationsSent
          ? _value.invitationsSent
          : invitationsSent // ignore: cast_nullable_to_non_nullable
              as int,
      invitedEmails: freezed == invitedEmails
          ? _value._invitedEmails
          : invitedEmails // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessRegisterResponseDtoImpl
    implements _BusinessRegisterResponseDto {
  const _$BusinessRegisterResponseDtoImpl(
      {required this.user,
      this.organization,
      required this.token,
      @JsonKey(name: 'invitations_sent') this.invitationsSent = 0,
      @JsonKey(name: 'invited_emails') final List<String>? invitedEmails})
      : _invitedEmails = invitedEmails;

  factory _$BusinessRegisterResponseDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$BusinessRegisterResponseDtoImplFromJson(json);

  @override
  final UserDto user;
  @override
  final OrganizationDto? organization;
  @override
  final String token;
  @override
  @JsonKey(name: 'invitations_sent')
  final int invitationsSent;
  final List<String>? _invitedEmails;
  @override
  @JsonKey(name: 'invited_emails')
  List<String>? get invitedEmails {
    final value = _invitedEmails;
    if (value == null) return null;
    if (_invitedEmails is EqualUnmodifiableListView) return _invitedEmails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'BusinessRegisterResponseDto(user: $user, organization: $organization, token: $token, invitationsSent: $invitationsSent, invitedEmails: $invitedEmails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessRegisterResponseDtoImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.invitationsSent, invitationsSent) ||
                other.invitationsSent == invitationsSent) &&
            const DeepCollectionEquality()
                .equals(other._invitedEmails, _invitedEmails));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user, organization, token,
      invitationsSent, const DeepCollectionEquality().hash(_invitedEmails));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessRegisterResponseDtoImplCopyWith<_$BusinessRegisterResponseDtoImpl>
      get copyWith => __$$BusinessRegisterResponseDtoImplCopyWithImpl<
          _$BusinessRegisterResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessRegisterResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _BusinessRegisterResponseDto
    implements BusinessRegisterResponseDto {
  const factory _BusinessRegisterResponseDto(
          {required final UserDto user,
          final OrganizationDto? organization,
          required final String token,
          @JsonKey(name: 'invitations_sent') final int invitationsSent,
          @JsonKey(name: 'invited_emails') final List<String>? invitedEmails}) =
      _$BusinessRegisterResponseDtoImpl;

  factory _BusinessRegisterResponseDto.fromJson(Map<String, dynamic> json) =
      _$BusinessRegisterResponseDtoImpl.fromJson;

  @override
  UserDto get user;
  @override
  OrganizationDto? get organization;
  @override
  String get token;
  @override
  @JsonKey(name: 'invitations_sent')
  int get invitationsSent;
  @override
  @JsonKey(name: 'invited_emails')
  List<String>? get invitedEmails;
  @override
  @JsonKey(ignore: true)
  _$$BusinessRegisterResponseDtoImplCopyWith<_$BusinessRegisterResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

OrganizationDto _$OrganizationDtoFromJson(Map<String, dynamic> json) {
  return _OrganizationDto.fromJson(json);
}

/// @nodoc
mixin _$OrganizationDto {
  int get id => throw _privateConstructorUsedError;
  String get uuid =>
      throw _privateConstructorUsedError; // API returns "name" not "organization_name"
  String get name => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  String? get siret => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city =>
      throw _privateConstructorUsedError; // API returns "zipCode" not "postal_code"
  String? get zipCode => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get industry => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee_count')
  String? get employeeCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'isActive')
  bool? get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'isVerified')
  bool? get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  String? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizationDtoCopyWith<OrganizationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationDtoCopyWith<$Res> {
  factory $OrganizationDtoCopyWith(
          OrganizationDto value, $Res Function(OrganizationDto) then) =
      _$OrganizationDtoCopyWithImpl<$Res, OrganizationDto>;
  @useResult
  $Res call(
      {int id,
      String uuid,
      String name,
      String? slug,
      String? siret,
      String? address,
      String? city,
      String? zipCode,
      String? country,
      String? industry,
      @JsonKey(name: 'employee_count') String? employeeCount,
      @JsonKey(name: 'isActive') bool? isActive,
      @JsonKey(name: 'isVerified') bool? isVerified,
      @JsonKey(name: 'createdAt') String? createdAt});
}

/// @nodoc
class _$OrganizationDtoCopyWithImpl<$Res, $Val extends OrganizationDto>
    implements $OrganizationDtoCopyWith<$Res> {
  _$OrganizationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? name = null,
    Object? slug = freezed,
    Object? siret = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? zipCode = freezed,
    Object? country = freezed,
    Object? industry = freezed,
    Object? employeeCount = freezed,
    Object? isActive = freezed,
    Object? isVerified = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      siret: freezed == siret
          ? _value.siret
          : siret // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      industry: freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeCount: freezed == employeeCount
          ? _value.employeeCount
          : employeeCount // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationDtoImplCopyWith<$Res>
    implements $OrganizationDtoCopyWith<$Res> {
  factory _$$OrganizationDtoImplCopyWith(_$OrganizationDtoImpl value,
          $Res Function(_$OrganizationDtoImpl) then) =
      __$$OrganizationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String uuid,
      String name,
      String? slug,
      String? siret,
      String? address,
      String? city,
      String? zipCode,
      String? country,
      String? industry,
      @JsonKey(name: 'employee_count') String? employeeCount,
      @JsonKey(name: 'isActive') bool? isActive,
      @JsonKey(name: 'isVerified') bool? isVerified,
      @JsonKey(name: 'createdAt') String? createdAt});
}

/// @nodoc
class __$$OrganizationDtoImplCopyWithImpl<$Res>
    extends _$OrganizationDtoCopyWithImpl<$Res, _$OrganizationDtoImpl>
    implements _$$OrganizationDtoImplCopyWith<$Res> {
  __$$OrganizationDtoImplCopyWithImpl(
      _$OrganizationDtoImpl _value, $Res Function(_$OrganizationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? name = null,
    Object? slug = freezed,
    Object? siret = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? zipCode = freezed,
    Object? country = freezed,
    Object? industry = freezed,
    Object? employeeCount = freezed,
    Object? isActive = freezed,
    Object? isVerified = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$OrganizationDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      siret: freezed == siret
          ? _value.siret
          : siret // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      industry: freezed == industry
          ? _value.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeCount: freezed == employeeCount
          ? _value.employeeCount
          : employeeCount // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizationDtoImpl implements _OrganizationDto {
  const _$OrganizationDtoImpl(
      {required this.id,
      required this.uuid,
      required this.name,
      this.slug,
      this.siret,
      this.address,
      this.city,
      this.zipCode,
      this.country,
      this.industry,
      @JsonKey(name: 'employee_count') this.employeeCount,
      @JsonKey(name: 'isActive') this.isActive,
      @JsonKey(name: 'isVerified') this.isVerified,
      @JsonKey(name: 'createdAt') this.createdAt});

  factory _$OrganizationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String uuid;
// API returns "name" not "organization_name"
  @override
  final String name;
  @override
  final String? slug;
  @override
  final String? siret;
  @override
  final String? address;
  @override
  final String? city;
// API returns "zipCode" not "postal_code"
  @override
  final String? zipCode;
  @override
  final String? country;
  @override
  final String? industry;
  @override
  @JsonKey(name: 'employee_count')
  final String? employeeCount;
  @override
  @JsonKey(name: 'isActive')
  final bool? isActive;
  @override
  @JsonKey(name: 'isVerified')
  final bool? isVerified;
  @override
  @JsonKey(name: 'createdAt')
  final String? createdAt;

  @override
  String toString() {
    return 'OrganizationDto(id: $id, uuid: $uuid, name: $name, slug: $slug, siret: $siret, address: $address, city: $city, zipCode: $zipCode, country: $country, industry: $industry, employeeCount: $employeeCount, isActive: $isActive, isVerified: $isVerified, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.siret, siret) || other.siret == siret) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.industry, industry) ||
                other.industry == industry) &&
            (identical(other.employeeCount, employeeCount) ||
                other.employeeCount == employeeCount) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      uuid,
      name,
      slug,
      siret,
      address,
      city,
      zipCode,
      country,
      industry,
      employeeCount,
      isActive,
      isVerified,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationDtoImplCopyWith<_$OrganizationDtoImpl> get copyWith =>
      __$$OrganizationDtoImplCopyWithImpl<_$OrganizationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizationDtoImplToJson(
      this,
    );
  }
}

abstract class _OrganizationDto implements OrganizationDto {
  const factory _OrganizationDto(
          {required final int id,
          required final String uuid,
          required final String name,
          final String? slug,
          final String? siret,
          final String? address,
          final String? city,
          final String? zipCode,
          final String? country,
          final String? industry,
          @JsonKey(name: 'employee_count') final String? employeeCount,
          @JsonKey(name: 'isActive') final bool? isActive,
          @JsonKey(name: 'isVerified') final bool? isVerified,
          @JsonKey(name: 'createdAt') final String? createdAt}) =
      _$OrganizationDtoImpl;

  factory _OrganizationDto.fromJson(Map<String, dynamic> json) =
      _$OrganizationDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get uuid;
  @override // API returns "name" not "organization_name"
  String get name;
  @override
  String? get slug;
  @override
  String? get siret;
  @override
  String? get address;
  @override
  String? get city;
  @override // API returns "zipCode" not "postal_code"
  String? get zipCode;
  @override
  String? get country;
  @override
  String? get industry;
  @override
  @JsonKey(name: 'employee_count')
  String? get employeeCount;
  @override
  @JsonKey(name: 'isActive')
  bool? get isActive;
  @override
  @JsonKey(name: 'isVerified')
  bool? get isVerified;
  @override
  @JsonKey(name: 'createdAt')
  String? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationDtoImplCopyWith<_$OrganizationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtpRequestDto _$OtpRequestDtoFromJson(Map<String, dynamic> json) {
  return _OtpRequestDto.fromJson(json);
}

/// @nodoc
mixin _$OtpRequestDto {
  String get email => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpRequestDtoCopyWith<OtpRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpRequestDtoCopyWith<$Res> {
  factory $OtpRequestDtoCopyWith(
          OtpRequestDto value, $Res Function(OtpRequestDto) then) =
      _$OtpRequestDtoCopyWithImpl<$Res, OtpRequestDto>;
  @useResult
  $Res call({String email, String type});
}

/// @nodoc
class _$OtpRequestDtoCopyWithImpl<$Res, $Val extends OtpRequestDto>
    implements $OtpRequestDtoCopyWith<$Res> {
  _$OtpRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpRequestDtoImplCopyWith<$Res>
    implements $OtpRequestDtoCopyWith<$Res> {
  factory _$$OtpRequestDtoImplCopyWith(
          _$OtpRequestDtoImpl value, $Res Function(_$OtpRequestDtoImpl) then) =
      __$$OtpRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String type});
}

/// @nodoc
class __$$OtpRequestDtoImplCopyWithImpl<$Res>
    extends _$OtpRequestDtoCopyWithImpl<$Res, _$OtpRequestDtoImpl>
    implements _$$OtpRequestDtoImplCopyWith<$Res> {
  __$$OtpRequestDtoImplCopyWithImpl(
      _$OtpRequestDtoImpl _value, $Res Function(_$OtpRequestDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? type = null,
  }) {
    return _then(_$OtpRequestDtoImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpRequestDtoImpl implements _OtpRequestDto {
  const _$OtpRequestDtoImpl({required this.email, required this.type});

  factory _$OtpRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpRequestDtoImplFromJson(json);

  @override
  final String email;
  @override
  final String type;

  @override
  String toString() {
    return 'OtpRequestDto(email: $email, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpRequestDtoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpRequestDtoImplCopyWith<_$OtpRequestDtoImpl> get copyWith =>
      __$$OtpRequestDtoImplCopyWithImpl<_$OtpRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _OtpRequestDto implements OtpRequestDto {
  const factory _OtpRequestDto(
      {required final String email,
      required final String type}) = _$OtpRequestDtoImpl;

  factory _OtpRequestDto.fromJson(Map<String, dynamic> json) =
      _$OtpRequestDtoImpl.fromJson;

  @override
  String get email;
  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$OtpRequestDtoImplCopyWith<_$OtpRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OtpVerifyDto _$OtpVerifyDtoFromJson(Map<String, dynamic> json) {
  return _OtpVerifyDto.fromJson(json);
}

/// @nodoc
mixin _$OtpVerifyDto {
  String get email => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtpVerifyDtoCopyWith<OtpVerifyDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpVerifyDtoCopyWith<$Res> {
  factory $OtpVerifyDtoCopyWith(
          OtpVerifyDto value, $Res Function(OtpVerifyDto) then) =
      _$OtpVerifyDtoCopyWithImpl<$Res, OtpVerifyDto>;
  @useResult
  $Res call({String email, String code, String type});
}

/// @nodoc
class _$OtpVerifyDtoCopyWithImpl<$Res, $Val extends OtpVerifyDto>
    implements $OtpVerifyDtoCopyWith<$Res> {
  _$OtpVerifyDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? code = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpVerifyDtoImplCopyWith<$Res>
    implements $OtpVerifyDtoCopyWith<$Res> {
  factory _$$OtpVerifyDtoImplCopyWith(
          _$OtpVerifyDtoImpl value, $Res Function(_$OtpVerifyDtoImpl) then) =
      __$$OtpVerifyDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String code, String type});
}

/// @nodoc
class __$$OtpVerifyDtoImplCopyWithImpl<$Res>
    extends _$OtpVerifyDtoCopyWithImpl<$Res, _$OtpVerifyDtoImpl>
    implements _$$OtpVerifyDtoImplCopyWith<$Res> {
  __$$OtpVerifyDtoImplCopyWithImpl(
      _$OtpVerifyDtoImpl _value, $Res Function(_$OtpVerifyDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? code = null,
    Object? type = null,
  }) {
    return _then(_$OtpVerifyDtoImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpVerifyDtoImpl implements _OtpVerifyDto {
  const _$OtpVerifyDtoImpl(
      {required this.email, required this.code, required this.type});

  factory _$OtpVerifyDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpVerifyDtoImplFromJson(json);

  @override
  final String email;
  @override
  final String code;
  @override
  final String type;

  @override
  String toString() {
    return 'OtpVerifyDto(email: $email, code: $code, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerifyDtoImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, code, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpVerifyDtoImplCopyWith<_$OtpVerifyDtoImpl> get copyWith =>
      __$$OtpVerifyDtoImplCopyWithImpl<_$OtpVerifyDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpVerifyDtoImplToJson(
      this,
    );
  }
}

abstract class _OtpVerifyDto implements OtpVerifyDto {
  const factory _OtpVerifyDto(
      {required final String email,
      required final String code,
      required final String type}) = _$OtpVerifyDtoImpl;

  factory _OtpVerifyDto.fromJson(Map<String, dynamic> json) =
      _$OtpVerifyDtoImpl.fromJson;

  @override
  String get email;
  @override
  String get code;
  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$OtpVerifyDtoImplCopyWith<_$OtpVerifyDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerRegisterDto _$CustomerRegisterDtoFromJson(Map<String, dynamic> json) {
  return _CustomerRegisterDto.fromJson(json);
}

/// @nodoc
mixin _$CustomerRegisterDto {
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'password_confirmation')
  String get passwordConfirmation => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'accept_terms')
  bool get acceptTerms => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerRegisterDtoCopyWith<CustomerRegisterDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerRegisterDtoCopyWith<$Res> {
  factory $CustomerRegisterDtoCopyWith(
          CustomerRegisterDto value, $Res Function(CustomerRegisterDto) then) =
      _$CustomerRegisterDtoCopyWithImpl<$Res, CustomerRegisterDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String email,
      String password,
      @JsonKey(name: 'password_confirmation') String passwordConfirmation,
      String? phone,
      @JsonKey(name: 'accept_terms') bool acceptTerms});
}

/// @nodoc
class _$CustomerRegisterDtoCopyWithImpl<$Res, $Val extends CustomerRegisterDto>
    implements $CustomerRegisterDtoCopyWith<$Res> {
  _$CustomerRegisterDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? password = null,
    Object? passwordConfirmation = null,
    Object? phone = freezed,
    Object? acceptTerms = null,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordConfirmation: null == passwordConfirmation
          ? _value.passwordConfirmation
          : passwordConfirmation // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptTerms: null == acceptTerms
          ? _value.acceptTerms
          : acceptTerms // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomerRegisterDtoImplCopyWith<$Res>
    implements $CustomerRegisterDtoCopyWith<$Res> {
  factory _$$CustomerRegisterDtoImplCopyWith(_$CustomerRegisterDtoImpl value,
          $Res Function(_$CustomerRegisterDtoImpl) then) =
      __$$CustomerRegisterDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      String email,
      String password,
      @JsonKey(name: 'password_confirmation') String passwordConfirmation,
      String? phone,
      @JsonKey(name: 'accept_terms') bool acceptTerms});
}

/// @nodoc
class __$$CustomerRegisterDtoImplCopyWithImpl<$Res>
    extends _$CustomerRegisterDtoCopyWithImpl<$Res, _$CustomerRegisterDtoImpl>
    implements _$$CustomerRegisterDtoImplCopyWith<$Res> {
  __$$CustomerRegisterDtoImplCopyWithImpl(_$CustomerRegisterDtoImpl _value,
      $Res Function(_$CustomerRegisterDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? email = null,
    Object? password = null,
    Object? passwordConfirmation = null,
    Object? phone = freezed,
    Object? acceptTerms = null,
  }) {
    return _then(_$CustomerRegisterDtoImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      passwordConfirmation: null == passwordConfirmation
          ? _value.passwordConfirmation
          : passwordConfirmation // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptTerms: null == acceptTerms
          ? _value.acceptTerms
          : acceptTerms // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerRegisterDtoImpl implements _CustomerRegisterDto {
  const _$CustomerRegisterDtoImpl(
      {@JsonKey(name: 'first_name') required this.firstName,
      @JsonKey(name: 'last_name') required this.lastName,
      required this.email,
      required this.password,
      @JsonKey(name: 'password_confirmation')
      required this.passwordConfirmation,
      this.phone,
      @JsonKey(name: 'accept_terms') required this.acceptTerms});

  factory _$CustomerRegisterDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerRegisterDtoImplFromJson(json);

  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  final String email;
  @override
  final String password;
  @override
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'accept_terms')
  final bool acceptTerms;

  @override
  String toString() {
    return 'CustomerRegisterDto(firstName: $firstName, lastName: $lastName, email: $email, password: $password, passwordConfirmation: $passwordConfirmation, phone: $phone, acceptTerms: $acceptTerms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerRegisterDtoImpl &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.passwordConfirmation, passwordConfirmation) ||
                other.passwordConfirmation == passwordConfirmation) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.acceptTerms, acceptTerms) ||
                other.acceptTerms == acceptTerms));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName, email,
      password, passwordConfirmation, phone, acceptTerms);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerRegisterDtoImplCopyWith<_$CustomerRegisterDtoImpl> get copyWith =>
      __$$CustomerRegisterDtoImplCopyWithImpl<_$CustomerRegisterDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerRegisterDtoImplToJson(
      this,
    );
  }
}

abstract class _CustomerRegisterDto implements CustomerRegisterDto {
  const factory _CustomerRegisterDto(
          {@JsonKey(name: 'first_name') required final String firstName,
          @JsonKey(name: 'last_name') required final String lastName,
          required final String email,
          required final String password,
          @JsonKey(name: 'password_confirmation')
          required final String passwordConfirmation,
          final String? phone,
          @JsonKey(name: 'accept_terms') required final bool acceptTerms}) =
      _$CustomerRegisterDtoImpl;

  factory _CustomerRegisterDto.fromJson(Map<String, dynamic> json) =
      _$CustomerRegisterDtoImpl.fromJson;

  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  String get email;
  @override
  String get password;
  @override
  @JsonKey(name: 'password_confirmation')
  String get passwordConfirmation;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'accept_terms')
  bool get acceptTerms;
  @override
  @JsonKey(ignore: true)
  _$$CustomerRegisterDtoImplCopyWith<_$CustomerRegisterDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerRegisterResponseDto _$CustomerRegisterResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _CustomerRegisterResponseDto.fromJson(json);
}

/// @nodoc
mixin _$CustomerRegisterResponseDto {
  UserDto get user => throw _privateConstructorUsedError;
  String get token => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_verification_required')
  bool get emailVerificationRequired => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomerRegisterResponseDtoCopyWith<CustomerRegisterResponseDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerRegisterResponseDtoCopyWith<$Res> {
  factory $CustomerRegisterResponseDtoCopyWith(
          CustomerRegisterResponseDto value,
          $Res Function(CustomerRegisterResponseDto) then) =
      _$CustomerRegisterResponseDtoCopyWithImpl<$Res,
          CustomerRegisterResponseDto>;
  @useResult
  $Res call(
      {UserDto user,
      String token,
      @JsonKey(name: 'email_verification_required')
      bool emailVerificationRequired});

  $UserDtoCopyWith<$Res> get user;
}

/// @nodoc
class _$CustomerRegisterResponseDtoCopyWithImpl<$Res,
        $Val extends CustomerRegisterResponseDto>
    implements $CustomerRegisterResponseDtoCopyWith<$Res> {
  _$CustomerRegisterResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? token = null,
    Object? emailVerificationRequired = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserDto,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerificationRequired: null == emailVerificationRequired
          ? _value.emailVerificationRequired
          : emailVerificationRequired // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<$Res> get user {
    return $UserDtoCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CustomerRegisterResponseDtoImplCopyWith<$Res>
    implements $CustomerRegisterResponseDtoCopyWith<$Res> {
  factory _$$CustomerRegisterResponseDtoImplCopyWith(
          _$CustomerRegisterResponseDtoImpl value,
          $Res Function(_$CustomerRegisterResponseDtoImpl) then) =
      __$$CustomerRegisterResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserDto user,
      String token,
      @JsonKey(name: 'email_verification_required')
      bool emailVerificationRequired});

  @override
  $UserDtoCopyWith<$Res> get user;
}

/// @nodoc
class __$$CustomerRegisterResponseDtoImplCopyWithImpl<$Res>
    extends _$CustomerRegisterResponseDtoCopyWithImpl<$Res,
        _$CustomerRegisterResponseDtoImpl>
    implements _$$CustomerRegisterResponseDtoImplCopyWith<$Res> {
  __$$CustomerRegisterResponseDtoImplCopyWithImpl(
      _$CustomerRegisterResponseDtoImpl _value,
      $Res Function(_$CustomerRegisterResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? token = null,
    Object? emailVerificationRequired = null,
  }) {
    return _then(_$CustomerRegisterResponseDtoImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserDto,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerificationRequired: null == emailVerificationRequired
          ? _value.emailVerificationRequired
          : emailVerificationRequired // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerRegisterResponseDtoImpl
    implements _CustomerRegisterResponseDto {
  const _$CustomerRegisterResponseDtoImpl(
      {required this.user,
      required this.token,
      @JsonKey(name: 'email_verification_required')
      this.emailVerificationRequired = true});

  factory _$CustomerRegisterResponseDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CustomerRegisterResponseDtoImplFromJson(json);

  @override
  final UserDto user;
  @override
  final String token;
  @override
  @JsonKey(name: 'email_verification_required')
  final bool emailVerificationRequired;

  @override
  String toString() {
    return 'CustomerRegisterResponseDto(user: $user, token: $token, emailVerificationRequired: $emailVerificationRequired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerRegisterResponseDtoImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.emailVerificationRequired,
                    emailVerificationRequired) ||
                other.emailVerificationRequired == emailVerificationRequired));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, user, token, emailVerificationRequired);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerRegisterResponseDtoImplCopyWith<_$CustomerRegisterResponseDtoImpl>
      get copyWith => __$$CustomerRegisterResponseDtoImplCopyWithImpl<
          _$CustomerRegisterResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerRegisterResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _CustomerRegisterResponseDto
    implements CustomerRegisterResponseDto {
  const factory _CustomerRegisterResponseDto(
          {required final UserDto user,
          required final String token,
          @JsonKey(name: 'email_verification_required')
          final bool emailVerificationRequired}) =
      _$CustomerRegisterResponseDtoImpl;

  factory _CustomerRegisterResponseDto.fromJson(Map<String, dynamic> json) =
      _$CustomerRegisterResponseDtoImpl.fromJson;

  @override
  UserDto get user;
  @override
  String get token;
  @override
  @JsonKey(name: 'email_verification_required')
  bool get emailVerificationRequired;
  @override
  @JsonKey(ignore: true)
  _$$CustomerRegisterResponseDtoImplCopyWith<_$CustomerRegisterResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
