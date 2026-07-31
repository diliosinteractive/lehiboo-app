import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/dio_client.dart';
import '../constants/app_constants.dart';
import '../network/auth_credential_mutation_coordinator.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  SecureStorageService({
    AuthCredentialMutationCoordinator? credentialMutations,
  }) : _credentialMutations =
            credentialMutations ?? AuthCredentialMutationCoordinator.instance;

  // Use the shared singleton instance to ensure consistency with JwtAuthInterceptor
  final FlutterSecureStorage _storage = SharedSecureStorage.instance;
  final AuthCredentialMutationCoordinator _credentialMutations;

  // Auth Tokens
  Future<void> saveAccessToken(String token) async {
    await _credentialMutations.run(() async {
      if (kDebugMode) {
        debugPrint(
          '🔐 SecureStorageService: Saving access token '
          '(length=${token.length})',
        );
      }
      await _storage.write(key: AppConstants.keyAuthToken, value: token);
      // Verify the token was saved correctly
      if (kDebugMode) {
        final saved = await _storage.read(key: AppConstants.keyAuthToken);
        debugPrint(
          '🔐 SecureStorageService: Token saved and verified: '
          '${saved != null && saved.isNotEmpty}',
        );
      }
    });
  }

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: AppConstants.keyAuthToken);
    if (kDebugMode) {
      debugPrint(
          '🔐 SecureStorageService: Reading access token: hasToken=${token != null && token.isNotEmpty}');
    }
    return token;
  }

  Future<void> saveRefreshToken(String token) async {
    await _credentialMutations.run(
      () => _storage.write(key: AppConstants.keyRefreshToken, value: token),
    );
  }

  /// Persists an access/refresh pair under one shared credential lease.
  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) {
    return _credentialMutations.run(() async {
      await _storage.write(
        key: AppConstants.keyAuthToken,
        value: accessToken,
      );
      await _storage.write(
        key: AppConstants.keyRefreshToken,
        value: refreshToken,
      );
    });
  }

  /// Replaces a refreshed pair only if no login/logout changed the refresh
  /// credential while the network request was in flight.
  Future<bool> replaceAuthTokensIfRefreshMatches({
    required String expectedRefreshToken,
    required String accessToken,
    required String refreshToken,
  }) {
    return _credentialMutations.run(() async {
      final currentRefreshToken = await _storage.read(
        key: AppConstants.keyRefreshToken,
      );
      if (currentRefreshToken != expectedRefreshToken) return false;
      await _storage.write(
        key: AppConstants.keyAuthToken,
        value: accessToken,
      );
      await _storage.write(
        key: AppConstants.keyRefreshToken,
        value: refreshToken,
      );
      return true;
    });
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppConstants.keyRefreshToken);
  }

  Future<void> saveUserId(String id) async {
    await _storage.write(key: AppConstants.keyUserId, value: id);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: AppConstants.keyUserId);
  }

  Future<void> saveUserRole(String role) async {
    await _storage.write(key: AppConstants.keyUserRole, value: role);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: AppConstants.keyUserRole);
  }

  Future<void> saveUserEmail(String? email) async {
    await _writeOrDelete('user_email', email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: 'user_email');
  }

  Future<void> saveUserDisplayName(String? name) async {
    await _writeOrDelete('user_display_name', name);
  }

  Future<String?> getUserDisplayName() async {
    return await _storage.read(key: 'user_display_name');
  }

  Future<void> saveUserFirstName(String? name) async {
    await _writeOrDelete('user_first_name', name);
  }

  Future<String?> getUserFirstName() async {
    return await _storage.read(key: 'user_first_name');
  }

  Future<void> saveUserLastName(String? name) async {
    await _writeOrDelete('user_last_name', name);
  }

  Future<String?> getUserLastName() async {
    return await _storage.read(key: 'user_last_name');
  }

  Future<void> saveUserBirthDate(String? birthDate) async {
    await _writeOrDelete('user_birth_date', birthDate);
  }

  Future<String?> getUserBirthDate() async {
    return await _storage.read(key: 'user_birth_date');
  }

  Future<void> saveUserMembershipCity(String? city) async {
    await _writeOrDelete('user_membership_city', city);
  }

  Future<String?> getUserMembershipCity() async {
    return await _storage.read(key: 'user_membership_city');
  }

  Future<void> saveUserPhone(String? phone) async {
    await _writeOrDelete('user_phone', phone);
  }

  Future<String?> getUserPhone() async {
    return await _storage.read(key: 'user_phone');
  }

  Future<void> saveUserAvatarUrl(String? url) async {
    await _writeOrDelete('user_avatar_url', url);
  }

  Future<String?> getUserAvatarUrl() async {
    return await _storage.read(key: 'user_avatar_url');
  }

  Future<void> saveUserNewsletter(bool? value) async {
    await _writeOrDelete('user_newsletter', value?.toString());
  }

  Future<bool?> getUserNewsletter() async {
    final raw = await _storage.read(key: 'user_newsletter');
    if (raw == null) return null;
    return raw == 'true';
  }

  Future<void> saveUserPushNotificationsEnabled(bool? value) async {
    await _writeOrDelete('user_push_notifications', value?.toString());
  }

  Future<bool?> getUserPushNotificationsEnabled() async {
    final raw = await _storage.read(key: 'user_push_notifications');
    if (raw == null) return null;
    return raw == 'true';
  }

  /// Writes [value] when non-null, deletes the key otherwise.
  /// Mirrors the in-memory entity exactly — clearing a field on the user must
  /// also clear it on disk.
  Future<void> _writeOrDelete(String key, String? value) async {
    if (value == null) {
      await _storage.delete(key: key);
    } else {
      await _storage.write(key: key, value: value);
    }
  }

  // Clear all auth data
  Future<void> clearAuthData() async {
    await _credentialMutations.run(_clearAuthDataUnlocked);
  }

  /// Clears a failed refresh's session only while the refresh credential that
  /// initiated it still owns storage. A late account-A 401 therefore cannot
  /// erase credentials already persisted by account B.
  Future<bool> clearAuthDataIfRefreshMatches(
    String expectedRefreshToken,
  ) {
    return _credentialMutations.run(() async {
      final currentRefreshToken = await _storage.read(
        key: AppConstants.keyRefreshToken,
      );
      if (currentRefreshToken != expectedRefreshToken) return false;
      await _clearAuthDataUnlocked();
      return true;
    });
  }

  Future<void> _clearAuthDataUnlocked() async {
    await _storage.delete(key: AppConstants.keyAuthToken);
    await _storage.delete(key: AppConstants.keyRefreshToken);
    await _storage.delete(key: AppConstants.keyUserId);
    await _storage.delete(key: AppConstants.keyUserRole);
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_display_name');
    await _storage.delete(key: 'user_first_name');
    await _storage.delete(key: 'user_last_name');
    await _storage.delete(key: 'user_birth_date');
    await _storage.delete(key: 'user_membership_city');
    await _storage.delete(key: 'user_phone');
    await _storage.delete(key: 'user_avatar_url');
    await _storage.delete(key: 'user_newsletter');
    await _storage.delete(key: 'user_push_notifications');
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
