import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/dio_client.dart';
import '../constants/app_constants.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  // Use the shared singleton instance to ensure consistency with JwtAuthInterceptor
  final FlutterSecureStorage _storage = SharedSecureStorage.instance;

  // Auth Tokens
  Future<void> saveAccessToken(String token) async {
    if (kDebugMode) {
      debugPrint('🔐 SecureStorageService: Saving access token (length=${token.length})');
    }
    await _storage.write(key: AppConstants.keyAuthToken, value: token);
    // Verify the token was saved correctly
    if (kDebugMode) {
      final saved = await _storage.read(key: AppConstants.keyAuthToken);
      debugPrint('🔐 SecureStorageService: Token saved and verified: ${saved != null && saved.isNotEmpty}');
    }
  }

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: AppConstants.keyAuthToken);
    if (kDebugMode) {
      debugPrint('🔐 SecureStorageService: Reading access token: hasToken=${token != null && token.isNotEmpty}');
    }
    return token;
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppConstants.keyRefreshToken, value: token);
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

  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: 'user_email', value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: 'user_email');
  }

  Future<void> saveUserDisplayName(String name) async {
    await _storage.write(key: 'user_display_name', value: name);
  }

  Future<String?> getUserDisplayName() async {
    return await _storage.read(key: 'user_display_name');
  }

  Future<void> saveUserFirstName(String name) async {
    await _storage.write(key: 'user_first_name', value: name);
  }

  Future<String?> getUserFirstName() async {
    return await _storage.read(key: 'user_first_name');
  }

  Future<void> saveUserLastName(String name) async {
    await _storage.write(key: 'user_last_name', value: name);
  }

  Future<String?> getUserLastName() async {
    return await _storage.read(key: 'user_last_name');
  }

  // Clear all auth data
  Future<void> clearAuthData() async {
    await _storage.delete(key: AppConstants.keyAuthToken);
    await _storage.delete(key: AppConstants.keyRefreshToken);
    await _storage.delete(key: AppConstants.keyUserId);
    await _storage.delete(key: AppConstants.keyUserRole);
    await _storage.delete(key: 'user_email');
    await _storage.delete(key: 'user_display_name');
    await _storage.delete(key: 'user_first_name');
    await _storage.delete(key: 'user_last_name');
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
