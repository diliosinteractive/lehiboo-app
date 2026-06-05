import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/data/models/business_register_dto.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.authenticated = false,
    this.currentUser,
  });

  final bool authenticated;
  final HbUser? currentUser;
  int logoutCount = 0;
  int clearLocalAuthDataCount = 0;

  Future<T> _unimplemented<T>() {
    return Future<T>.error(UnimplementedError());
  }

  @override
  Future<bool> isAuthenticated() async => authenticated;

  @override
  Future<HbUser?> getCurrentUser() async => currentUser;

  @override
  Future<void> logout() async {
    logoutCount++;
  }

  @override
  Future<void> clearLocalAuthData() async {
    clearLocalAuthDataCount++;
  }

  @override
  Future<void> persistUser(HbUser user) async {}

  @override
  Future<bool> refreshTokenIfNeeded() async => false;

  @override
  Future<bool> checkEmailExists(String email) => _unimplemented();

  @override
  Future<void> forgotPassword(String email) => _unimplemented();

  @override
  Future<LoginOtpResult> login({
    required String email,
    required String password,
  }) =>
      _unimplemented();

  @override
  Future<CustomerRegistrationResult> registerCustomer({
    required String verifiedEmailToken,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? birthDate,
    String? membershipCity,
    required bool acceptTerms,
    bool acceptMarketing = false,
  }) =>
      _unimplemented();

  @override
  Future<RegistrationResult> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String birthDate,
  }) =>
      _unimplemented();

  @override
  Future<BusinessRegistrationResult> registerBusiness({
    required BusinessRegisterDto dto,
  }) =>
      _unimplemented();

  @override
  Future<void> resendOtp({
    required String userId,
    required String email,
    String type = 'register',
  }) =>
      _unimplemented();

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) =>
      _unimplemented();

  @override
  Future<OtpResult> sendOtpCode({
    required String email,
    required String type,
  }) =>
      _unimplemented();

  @override
  Future<AuthResult> verifyLoginOtp({
    required String userId,
    required String email,
    required String otp,
  }) =>
      _unimplemented();

  @override
  Future<AuthResult> verifyOtp({
    required String userId,
    required String email,
    required String otp,
  }) =>
      _unimplemented();

  @override
  Future<OtpVerificationResult> verifyOtpCode({
    required String email,
    required String code,
    required String type,
  }) =>
      _unimplemented();
}
