import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<AuthResult> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  });

  Future<AuthResult> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> forgotPassword(String email);

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<bool> refreshTokenIfNeeded();

  Future<HbUser?> getCurrentUser();

  Future<bool> isAuthenticated();
}

class AuthResult {
  final HbUser user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  AuthResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError('authRepositoryProvider not initialized');
});
