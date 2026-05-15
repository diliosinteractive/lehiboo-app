import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../domain/entities/user.dart';
import '../../data/models/business_register_dto.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

/// Steps for business registration
enum BusinessRegisterStep {
  personalInfo, // Step 1
  otpVerification, // Step 2
  companyInfo, // Step 3
  usageMode, // Step 4
  terms, // Step 5
}

/// Organization types
enum OrganizationType {
  company,
  association,
  municipality,
}

extension OrganizationTypeExtension on OrganizationType {
  String get value {
    switch (this) {
      case OrganizationType.company:
        return 'company';
      case OrganizationType.association:
        return 'association';
      case OrganizationType.municipality:
        return 'municipality';
    }
  }
}

/// Usage modes
enum UsageMode {
  personal,
  team,
}

extension UsageModeExtension on UsageMode {
  String get value {
    switch (this) {
      case UsageMode.personal:
        return 'personal';
      case UsageMode.team:
        return 'team';
    }
  }
}

/// State for business registration
class BusinessRegisterState {
  // Current step
  final BusinessRegisterStep currentStep;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  // Step 1: Personal Info
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? birthDate;
  final String? membershipCity;
  final String password;
  final String passwordConfirmation;

  // Step 2: OTP Verification
  final bool isOtpVerified;
  final String? verifiedEmailToken;
  final int otpCooldownSeconds;
  final bool isResendingOtp;

  // Step 3: Company Info
  final OrganizationType organizationType;
  final String companyName;
  final String siret;
  final String industry;
  final String employeeCount;
  final String address;
  final String city;
  final String postalCode;
  final String country;

  // Step 4: Usage Mode
  final UsageMode usageMode;
  final String teamEmails;
  final String defaultBudget;

  // Step 5: Terms
  final bool acceptTerms;
  final bool acceptBusinessTerms;

  // Registration result
  final bool isRegistrationComplete;
  final OrganizationInfo? organization;
  final HbUser? authenticatedUser;

  const BusinessRegisterState({
    this.currentStep = BusinessRegisterStep.personalInfo,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    // Step 1
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.birthDate,
    this.membershipCity,
    this.password = '',
    this.passwordConfirmation = '',
    // Step 2
    this.isOtpVerified = false,
    this.verifiedEmailToken,
    this.otpCooldownSeconds = 0,
    this.isResendingOtp = false,
    // Step 3
    this.organizationType = OrganizationType.company,
    this.companyName = '',
    this.siret = '',
    this.industry = '',
    this.employeeCount = '',
    this.address = '',
    this.city = '',
    this.postalCode = '',
    this.country = 'FR',
    // Step 4
    this.usageMode = UsageMode.personal,
    this.teamEmails = '',
    this.defaultBudget = '',
    // Step 5
    this.acceptTerms = false,
    this.acceptBusinessTerms = false,
    // Result
    this.isRegistrationComplete = false,
    this.organization,
    this.authenticatedUser,
  });

  BusinessRegisterState copyWith({
    BusinessRegisterStep? currentStep,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    // Step 1
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? birthDate,
    String? membershipCity,
    String? password,
    String? passwordConfirmation,
    // Step 2
    bool? isOtpVerified,
    String? verifiedEmailToken,
    int? otpCooldownSeconds,
    bool? isResendingOtp,
    // Step 3
    OrganizationType? organizationType,
    String? companyName,
    String? siret,
    String? industry,
    String? employeeCount,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    // Step 4
    UsageMode? usageMode,
    String? teamEmails,
    String? defaultBudget,
    // Step 5
    bool? acceptTerms,
    bool? acceptBusinessTerms,
    // Result
    bool? isRegistrationComplete,
    OrganizationInfo? organization,
    HbUser? authenticatedUser,
  }) {
    return BusinessRegisterState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      // Step 1
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      membershipCity: membershipCity ?? this.membershipCity,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      // Step 2
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      verifiedEmailToken: verifiedEmailToken ?? this.verifiedEmailToken,
      otpCooldownSeconds: otpCooldownSeconds ?? this.otpCooldownSeconds,
      isResendingOtp: isResendingOtp ?? this.isResendingOtp,
      // Step 3
      organizationType: organizationType ?? this.organizationType,
      companyName: companyName ?? this.companyName,
      siret: siret ?? this.siret,
      industry: industry ?? this.industry,
      employeeCount: employeeCount ?? this.employeeCount,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      // Step 4
      usageMode: usageMode ?? this.usageMode,
      teamEmails: teamEmails ?? this.teamEmails,
      defaultBudget: defaultBudget ?? this.defaultBudget,
      // Step 5
      acceptTerms: acceptTerms ?? this.acceptTerms,
      acceptBusinessTerms: acceptBusinessTerms ?? this.acceptBusinessTerms,
      // Result
      isRegistrationComplete:
          isRegistrationComplete ?? this.isRegistrationComplete,
      organization: organization ?? this.organization,
      authenticatedUser: authenticatedUser ?? this.authenticatedUser,
    );
  }

  /// Get the current step index (0-based)
  int get stepIndex => currentStep.index;

  /// Get the total number of steps
  int get totalSteps => BusinessRegisterStep.values.length;

  /// Check if we can go back
  bool get canGoBack => currentStep.index > 0;

  /// Check if we're on the last step
  bool get isLastStep => currentStep == BusinessRegisterStep.terms;
}

/// Notifier for business registration
class BusinessRegisterNotifier extends StateNotifier<BusinessRegisterState> {
  final AuthRepository _authRepository;
  Timer? _cooldownTimer;

  BusinessRegisterNotifier(this._authRepository)
      : super(const BusinessRegisterState());

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  // ============================================================
  // Step Navigation
  // ============================================================

  /// Go to next step
  void nextStep() {
    if (!state.isLastStep) {
      final nextIndex = state.currentStep.index + 1;
      state = state.copyWith(
        currentStep: BusinessRegisterStep.values[nextIndex],
        errorMessage: null,
      );
    }
  }

  /// Go to previous step
  void previousStep() {
    if (state.canGoBack) {
      final prevIndex = state.currentStep.index - 1;
      state = state.copyWith(
        currentStep: BusinessRegisterStep.values[prevIndex],
        errorMessage: null,
      );
    }
  }

  /// Go to specific step
  void goToStep(BusinessRegisterStep step) {
    state = state.copyWith(
      currentStep: step,
      errorMessage: null,
    );
  }

  // ============================================================
  // Step 1: Personal Info
  // ============================================================

  void updatePersonalInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? birthDate,
    String? membershipCity,
    String? password,
    String? passwordConfirmation,
  }) {
    state = state.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      birthDate: birthDate,
      membershipCity: membershipCity,
      password: password,
      passwordConfirmation: passwordConfirmation,
      errorMessage: null,
    );
  }

  /// Validate and submit personal info, send OTP
  Future<bool> submitPersonalInfo() async {
    // Validate
    if (!_validatePersonalInfo()) {
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Check if email already exists
      final emailExists = await _authRepository.checkEmailExists(state.email);
      if (emailExists) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: cachedAppLocalizations().authAccountAlreadyExists,
        );
        return false;
      }

      // Send OTP
      final result = await _authRepository.sendOtpCode(
        email: state.email,
        type: 'email_verification',
      );

      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          currentStep: BusinessRegisterStep.otpVerification,
          successMessage: result.message,
        );
        _startCooldown();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseError(e),
      );
      return false;
    }
  }

  bool _validatePersonalInfo() {
    final l10n = cachedAppLocalizations();
    if (state.firstName.trim().length < 2) {
      state = state.copyWith(errorMessage: l10n.authFirstNameMinLength);
      return false;
    }
    if (state.lastName.trim().length < 2) {
      state = state.copyWith(errorMessage: l10n.authLastNameMinLength);
      return false;
    }
    if (!_isValidEmail(state.email)) {
      state = state.copyWith(errorMessage: l10n.authEmailInvalid);
      return false;
    }
    if (state.phone.isNotEmpty && !_isValidPhone(state.phone)) {
      state = state.copyWith(errorMessage: l10n.authPhoneInvalid);
      return false;
    }
    if (!_isValidPassword(state.password)) {
      state = state.copyWith(
        errorMessage: l10n.authPasswordNeedsUppercaseNumberSpecial,
      );
      return false;
    }
    if (state.password != state.passwordConfirmation) {
      state = state.copyWith(errorMessage: l10n.authPasswordsDoNotMatch);
      return false;
    }
    return true;
  }

  // ============================================================
  // Step 2: OTP Verification
  // ============================================================

  /// Verify OTP code
  Future<bool> verifyOtp(String code) async {
    if (code.length != 6) {
      state = state.copyWith(
          errorMessage: cachedAppLocalizations().authOtpIncompleteCode);
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _authRepository.verifyOtpCode(
        email: state.email,
        code: code,
        type: 'email_verification',
      );

      if (result.verified) {
        state = state.copyWith(
          isLoading: false,
          isOtpVerified: true,
          verifiedEmailToken: result.verifiedEmailToken,
          currentStep: BusinessRegisterStep.companyInfo,
          successMessage: cachedAppLocalizations().authOtpEmailVerified,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: cachedAppLocalizations().authVerificationCodeInvalid,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseOtpError(e),
      );
      return false;
    }
  }

  /// Resend OTP code
  Future<bool> resendOtp() async {
    if (state.otpCooldownSeconds > 0 || state.isResendingOtp) {
      return false;
    }

    state = state.copyWith(isResendingOtp: true, errorMessage: null);

    try {
      final result = await _authRepository.sendOtpCode(
        email: state.email,
        type: 'email_verification',
      );

      if (result.success) {
        state = state.copyWith(
          isResendingOtp: false,
          successMessage: cachedAppLocalizations().authOtpResent,
        );
        _startCooldown();
        return true;
      } else {
        state = state.copyWith(
          isResendingOtp: false,
          errorMessage: result.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isResendingOtp: false,
        errorMessage: _parseError(e),
      );
      return false;
    }
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    state = state.copyWith(otpCooldownSeconds: 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.otpCooldownSeconds > 0) {
        state =
            state.copyWith(otpCooldownSeconds: state.otpCooldownSeconds - 1);
      } else {
        timer.cancel();
      }
    });
  }

  // ============================================================
  // Step 3: Company Info
  // ============================================================

  void updateCompanyInfo({
    OrganizationType? organizationType,
    String? companyName,
    String? siret,
    String? industry,
    String? employeeCount,
    String? address,
    String? city,
    String? postalCode,
    String? country,
  }) {
    state = state.copyWith(
      organizationType: organizationType,
      companyName: companyName,
      siret: siret,
      industry: industry,
      employeeCount: employeeCount,
      address: address,
      city: city,
      postalCode: postalCode,
      country: country,
      errorMessage: null,
    );
  }

  bool submitCompanyInfo() {
    if (!_validateCompanyInfo()) {
      return false;
    }
    state = state.copyWith(
      currentStep: BusinessRegisterStep.usageMode,
      errorMessage: null,
    );
    return true;
  }

  bool _validateCompanyInfo() {
    final l10n = cachedAppLocalizations();
    if (state.companyName.trim().length < 2) {
      state = state.copyWith(errorMessage: l10n.authCompanyNameMinLength);
      return false;
    }
    if (state.siret.isNotEmpty && !_isValidSiret(state.siret)) {
      state = state.copyWith(errorMessage: l10n.authSiretMustHave14Digits);
      return false;
    }
    if (state.address.trim().length < 5) {
      state = state.copyWith(errorMessage: l10n.authAddressMinLength);
      return false;
    }
    if (state.city.trim().length < 2) {
      state = state.copyWith(errorMessage: l10n.authCityMinLength);
      return false;
    }
    if (state.postalCode.trim().length < 3 ||
        state.postalCode.trim().length > 10) {
      state = state.copyWith(errorMessage: l10n.authPostalCodeLength);
      return false;
    }
    return true;
  }

  // ============================================================
  // Step 4: Usage Mode
  // ============================================================

  void updateUsageMode({
    UsageMode? usageMode,
    String? teamEmails,
    String? defaultBudget,
  }) {
    state = state.copyWith(
      usageMode: usageMode,
      teamEmails: teamEmails,
      defaultBudget: defaultBudget,
      errorMessage: null,
    );
  }

  bool submitUsageMode() {
    // Team emails validation only if usage mode is team
    if (state.usageMode == UsageMode.team &&
        state.teamEmails.trim().isNotEmpty) {
      final emails = state.teamEmails
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty);
      for (final email in emails) {
        if (!_isValidEmail(email)) {
          state = state.copyWith(
            errorMessage:
                cachedAppLocalizations().authInvalidEmailWithValue(email),
          );
          return false;
        }
      }
    }

    state = state.copyWith(
      currentStep: BusinessRegisterStep.terms,
      errorMessage: null,
    );
    return true;
  }

  // ============================================================
  // Step 5: Terms & Final Submission
  // ============================================================

  void updateTerms({
    bool? acceptTerms,
    bool? acceptBusinessTerms,
  }) {
    state = state.copyWith(
      acceptTerms: acceptTerms,
      acceptBusinessTerms: acceptBusinessTerms,
      errorMessage: null,
    );
  }

  /// Final submission
  Future<bool> submitRegistration() async {
    if (!state.acceptTerms) {
      state = state.copyWith(
        errorMessage: cachedAppLocalizations().authAcceptTermsRequired,
      );
      return false;
    }
    if (!state.acceptBusinessTerms) {
      state = state.copyWith(
        errorMessage: cachedAppLocalizations().authBusinessTermsRequired,
      );
      return false;
    }

    if (state.verifiedEmailToken == null || state.verifiedEmailToken!.isEmpty) {
      state = state.copyWith(
        errorMessage:
            cachedAppLocalizations().authRegisterMissingVerificationToken,
      );
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final dto = BusinessRegisterDto(
        verifiedEmailToken: state.verifiedEmailToken!,
        // Personal
        firstName: state.firstName.trim(),
        lastName: state.lastName.trim(),
        email: state.email.trim(),
        phone: state.phone.trim().isNotEmpty ? state.phone.trim() : null,
        birthDate: state.birthDate,
        membershipCity: state.membershipCity,
        password: state.password,
        passwordConfirmation: state.passwordConfirmation,
        // Company
        organizationType: state.organizationType.value,
        companyName: state.companyName.trim(),
        siret: state.siret.trim().isNotEmpty ? state.siret.trim() : null,
        industry:
            state.industry.trim().isNotEmpty ? state.industry.trim() : null,
        employeeCount: state.employeeCount.trim().isNotEmpty
            ? state.employeeCount.trim()
            : null,
        address: state.address.trim(),
        city: state.city.trim(),
        postalCode: state.postalCode.trim(),
        country: state.country,
        // Usage
        usageMode: state.usageMode.value,
        teamEmails:
            state.teamEmails.trim().isNotEmpty ? state.teamEmails.trim() : null,
        defaultBudget: state.defaultBudget.trim().isNotEmpty
            ? double.tryParse(state.defaultBudget.trim())
            : null,
        // Terms
        acceptTerms: state.acceptTerms,
        acceptBusinessTerms: state.acceptBusinessTerms,
      );

      final result = await _authRepository.registerBusiness(dto: dto);

      state = state.copyWith(
        isLoading: false,
        isRegistrationComplete: true,
        organization: result.organization,
        authenticatedUser: result.authResult.user,
        successMessage: cachedAppLocalizations().authBusinessSuccessTitle,
      );

      debugPrint(
          '📱 Business registration complete: ${result.organization?.name}');
      debugPrint('📱 User authenticated: ${result.authResult.user.email}');
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseError(e),
      );
      return false;
    }
  }

  // ============================================================
  // Utilities
  // ============================================================

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSuccess() {
    state = state.copyWith(successMessage: null);
  }

  void reset() {
    _cooldownTimer?.cancel();
    state = const BusinessRegisterState();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    // French phone number format (loose validation)
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\.]'), '');
    return RegExp(r'^(\+33|0033|0)[1-9]\d{8}$').hasMatch(cleaned);
  }

  bool _isValidPassword(String password) {
    // At least 8 chars, 1 uppercase, 1 digit, 1 symbol
    if (password.length < 8) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) return false;
    return true;
  }

  bool _isValidSiret(String siret) {
    final cleaned = siret.replaceAll(RegExp(r'\s'), '');
    return RegExp(r'^\d{14}$').hasMatch(cleaned);
  }

  String _parseError(dynamic e) {
    final l10n = cachedAppLocalizations();

    if (e is DioException) {
      if (e.type == DioExceptionType.badResponse) {
        final data = e.response?.data;
        if (data != null && data is Map<String, dynamic>) {
          // Handle structured error with details
          final error = data['error'];
          if (error != null &&
              error is Map<String, dynamic> &&
              error['details'] != null) {
            final details = error['details'];
            if (details is Map<String, dynamic>) {
              final firstError = details.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                return firstError.first.toString();
              }
              return firstError.toString();
            }
          }
          // Handle simple error string
          if (error != null && error is String) {
            return error;
          }
          if (data['message'] != null) {
            return data['message'].toString();
          }
          if (data['data'] != null && data['data']['message'] != null) {
            return data['data']['message'].toString();
          }
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return l10n.commonConnectionError;
      }
    }

    final message = e.toString();
    if (message.contains('user_exists')) {
      return l10n.authAccountAlreadyExists;
    } else if (message.contains('network') ||
        message.contains('SocketException')) {
      return l10n.commonConnectionError;
    }

    if (e is Exception) {
      final msg = e.toString().replaceAll('Exception: ', '');
      if (msg.isNotEmpty && !msg.startsWith('http')) return msg;
    }

    return l10n.commonGenericRetryError;
  }

  String _parseOtpError(dynamic e) {
    final l10n = cachedAppLocalizations();
    final message = e.toString();
    if (message.contains('invalid_otp') || message.contains('invalid')) {
      return l10n.authVerificationCodeInvalid;
    } else if (message.contains('expired')) {
      return l10n.authVerificationCodeExpired;
    } else if (message.contains('too_many')) {
      return l10n.authTooManyAttempts;
    }
    return l10n.authVerificationCodeInvalid;
  }
}

/// Provider for business registration
final businessRegisterProvider = StateNotifierProvider.autoDispose<
    BusinessRegisterNotifier, BusinessRegisterState>((ref) {
  final authRepository = ref.watch(authRepositoryImplProvider);
  return BusinessRegisterNotifier(authRepository);
});
