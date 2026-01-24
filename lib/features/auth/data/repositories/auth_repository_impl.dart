import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_datasource.dart';
import '../mappers/auth_mapper.dart';
import '../models/auth_response_dto.dart';
import '../models/business_register_dto.dart';

final authRepositoryImplProvider = Provider<AuthRepository>((ref) {
  final apiDataSource = ref.read(authApiDataSourceProvider);
  final secureStorage = ref.read(secureStorageProvider);
  return AuthRepositoryImpl(apiDataSource, secureStorage);
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _apiDataSource;
  final SecureStorageService _secureStorage;
  HbUser? _cachedUser;

  AuthRepositoryImpl(this._apiDataSource, this._secureStorage);

  @override
  Future<RegistrationResult> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _apiDataSource.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );

    return RegistrationResult(
      pendingVerification: response.pendingVerification,
      userId: response.userId,
      email: response.email,
      message: response.message,
    );
  }

  @override
  Future<AuthResult> verifyOtp({
    required String userId,
    required String email,
    required String otp,
  }) async {
    final response = await _apiDataSource.verifyOtp(
      userId: userId,
      email: email,
      otp: otp,
    );

    return _handleAuthResponse(response);
  }

  @override
  Future<void> resendOtp({
    required String userId,
    required String email,
    String type = 'register',
  }) async {
    await _apiDataSource.resendOtp(
      userId: userId,
      email: email,
      type: type,
    );
  }

  @override
  Future<LoginOtpResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiDataSource.login(
      email: email,
      password: password,
    );

    // If login was successful with direct auth (no OTP required)
    if (!response.requiresOtp && response.authResponse != null) {
      final authResult = await _handleAuthResponse(response.authResponse!);
      return LoginOtpResult(
        requiresOtp: false,
        authResult: authResult,
      );
    }

    return LoginOtpResult(
      requiresOtp: response.requiresOtp,
      userId: response.userId,
      email: response.email,
      message: response.message,
    );
  }

  @override
  Future<AuthResult> verifyLoginOtp({
    required String userId,
    required String email,
    required String otp,
  }) async {
    final response = await _apiDataSource.verifyLoginOtp(
      userId: userId,
      email: email,
      otp: otp,
    );

    return _handleAuthResponse(response);
  }

  @override
  Future<void> logout() async {
    try {
      await _apiDataSource.logout();
    } catch (e) {
      // Ignore network errors during logout
    } finally {
      await _secureStorage.clearAuthData();
      _cachedUser = null;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _apiDataSource.forgotPassword(email);
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await _apiDataSource.resetPassword(
      token: token,
      newPassword: newPassword,
    );
  }

  @override
  Future<bool> refreshTokenIfNeeded() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final tokens = await _apiDataSource.refreshToken(refreshToken);

      await _secureStorage.saveAccessToken(tokens.accessToken);
      await _secureStorage.saveRefreshToken(tokens.refreshToken);

      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _secureStorage.clearAuthData();
        _cachedUser = null;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<HbUser?> getCurrentUser() async {
    if (_cachedUser != null) return _cachedUser;

    final isAuth = await isAuthenticated();
    if (!isAuth) return null;

    // Try to restore from storage
    final userId = await _secureStorage.getUserId();
    final role = await _secureStorage.getUserRole();
    final email = await _secureStorage.getUserEmail();
    final name = await _secureStorage.getUserDisplayName();
    final firstName = await _secureStorage.getUserFirstName();
    final lastName = await _secureStorage.getUserLastName();

    if (userId != null) {
      _cachedUser = HbUser(
        id: userId,
        email: email ?? '',
        displayName: name ?? '',
        firstName: firstName,
        lastName: lastName,
        role: _parseRole(role),
      );
      return _cachedUser;
    }

    return null;
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _secureStorage.isAuthenticated();
  }

  Future<AuthResult> _handleAuthResponse(AuthResponseDto response) async {
    final user = AuthMapper.toUser(response.user);

    // Save tokens securely
    await _secureStorage.saveAccessToken(response.tokens.accessToken);
    await _secureStorage.saveRefreshToken(response.tokens.refreshToken);
    await _secureStorage.saveUserId(user.id);
    await _secureStorage.saveUserRole(user.role.name);
    await _secureStorage.saveUserEmail(user.email);
    await _secureStorage.saveUserDisplayName(user.displayName ?? '');
    if (user.firstName != null) await _secureStorage.saveUserFirstName(user.firstName!);
    if (user.lastName != null) await _secureStorage.saveUserLastName(user.lastName!);

    _cachedUser = user;

    return AuthResult(
      user: user,
      accessToken: response.tokens.accessToken,
      refreshToken: response.tokens.refreshToken,
      expiresIn: response.tokens.expiresIn,
    );
  }

  UserRole _parseRole(String? role) {
    if (role == null) return UserRole.subscriber;
    try {
      return UserRole.values.firstWhere(
        (e) => e.name == role,
        orElse: () => UserRole.subscriber,
      );
    } catch (_) {
      return UserRole.subscriber;
    }
  }

  // ============================================================
  // NEW REGISTRATION METHODS FOR MOBILE APP
  // ============================================================

  @override
  Future<CustomerRegistrationResult> registerCustomer({
    required String verifiedEmailToken,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    required bool acceptTerms,
  }) async {
    final response = await _apiDataSource.registerCustomer(
      verifiedEmailToken: verifiedEmailToken,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      phone: phone,
      acceptTerms: acceptTerms,
    );

    // If we have a token and user, save and return auth result
    AuthResult? authResult;
    if (response.token != null && response.user != null) {
      final user = AuthMapper.toUser(response.user!);
      final tokens = TokensDto(
        accessToken: response.token!,
        refreshToken: response.token!,
      );

      await _secureStorage.saveAccessToken(tokens.accessToken);
      await _secureStorage.saveRefreshToken(tokens.refreshToken);
      await _secureStorage.saveUserId(user.id);
      await _secureStorage.saveUserRole(user.role.name);
      await _secureStorage.saveUserEmail(user.email);
      await _secureStorage.saveUserDisplayName(user.displayName ?? '');
      if (user.firstName != null) await _secureStorage.saveUserFirstName(user.firstName!);
      if (user.lastName != null) await _secureStorage.saveUserLastName(user.lastName!);

      _cachedUser = user;

      authResult = AuthResult(
        user: user,
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
        expiresIn: 604800,
      );
    }

    return CustomerRegistrationResult(
      pendingVerification: response.pendingVerification,
      emailVerificationRequired: response.emailVerificationRequired,
      userId: response.userId,
      email: response.email,
      message: response.message,
      authResult: authResult,
    );
  }

  @override
  Future<BusinessRegistrationResult> registerBusiness({
    required BusinessRegisterDto dto,
  }) async {
    final response = await _apiDataSource.registerBusiness(dto: dto);

    final user = AuthMapper.toUser(response.user);
    final tokens = TokensDto(
      accessToken: response.token,
      refreshToken: response.token,
    );

    // Save auth data
    await _secureStorage.saveAccessToken(tokens.accessToken);
    await _secureStorage.saveRefreshToken(tokens.refreshToken);
    await _secureStorage.saveUserId(user.id);
    await _secureStorage.saveUserRole(user.role.name);
    await _secureStorage.saveUserEmail(user.email);
    await _secureStorage.saveUserDisplayName(user.displayName ?? '');
    if (user.firstName != null) await _secureStorage.saveUserFirstName(user.firstName!);
    if (user.lastName != null) await _secureStorage.saveUserLastName(user.lastName!);

    _cachedUser = user;

    final authResult = AuthResult(
      user: user,
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresIn: 604800,
    );

    OrganizationInfo? orgInfo;
    if (response.organization != null) {
      orgInfo = OrganizationInfo(
        id: response.organization!.id,
        uuid: response.organization!.uuid,
        name: response.organization!.name,
        type: null, // API doesn't return organization_type in response
      );
    }

    return BusinessRegistrationResult(
      authResult: authResult,
      organization: orgInfo,
      invitationsSent: response.invitationsSent,
      invitedEmails: response.invitedEmails,
    );
  }

  @override
  Future<OtpResult> sendOtpCode({
    required String email,
    required String type,
  }) async {
    final response = await _apiDataSource.sendOtpCode(
      email: email,
      type: type,
    );

    return OtpResult(
      success: response.success,
      message: response.message,
      expiresAt: response.expiresAt,
    );
  }

  @override
  Future<OtpVerificationResult> verifyOtpCode({
    required String email,
    required String code,
    required String type,
  }) async {
    final response = await _apiDataSource.verifyOtpCode(
      email: email,
      code: code,
      type: type,
    );

    return OtpVerificationResult(
      success: response.success,
      verified: response.verified,
      message: response.message,
      verifiedEmailToken: response.verifiedEmailToken,
      tokenExpiresInMinutes: response.tokenExpiresInMinutes,
    );
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    return await _apiDataSource.checkEmailExists(email);
  }
}
