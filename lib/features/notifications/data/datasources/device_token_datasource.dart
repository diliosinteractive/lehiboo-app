import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';

final deviceTokenDataSourceProvider = Provider<DeviceTokenDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return DeviceTokenDataSource(dio);
});

/// Result of device token registration
class DeviceTokenResult {
  final String uuid;
  final String platform;
  final String? deviceName;
  final bool isActive;

  DeviceTokenResult({
    required this.uuid,
    required this.platform,
    this.deviceName,
    required this.isActive,
  });

  factory DeviceTokenResult.fromJson(Map<String, dynamic> json) {
    return DeviceTokenResult(
      uuid: json['uuid'] ?? '',
      platform: json['platform'] ?? '',
      deviceName: json['device_name'],
      isActive: json['is_active'] ?? true,
    );
  }
}

/// Device token data for listing
class DeviceTokenData {
  final String uuid;
  final String platform;
  final String? deviceName;
  final String? appVersion;
  final bool isActive;
  final DateTime? lastUsedAt;
  final DateTime createdAt;

  DeviceTokenData({
    required this.uuid,
    required this.platform,
    this.deviceName,
    this.appVersion,
    required this.isActive,
    this.lastUsedAt,
    required this.createdAt,
  });

  factory DeviceTokenData.fromJson(Map<String, dynamic> json) {
    return DeviceTokenData(
      uuid: json['uuid'] ?? '',
      platform: json['platform'] ?? '',
      deviceName: json['device_name'],
      appVersion: json['app_version'],
      isActive: json['is_active'] ?? true,
      lastUsedAt: json['last_used_at'] != null
          ? DateTime.parse(json['last_used_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}

/// Data source for device token API operations
class DeviceTokenDataSource {
  final Dio _dio;

  DeviceTokenDataSource(this._dio);

  /// Register a new device token for push notifications
  ///
  /// [token] - FCM/APNs token
  /// [platform] - 'android', 'ios', or 'web'
  /// [deviceId] - Unique device identifier
  /// [deviceName] - Human readable device name
  /// [appVersion] - Current app version
  Future<DeviceTokenResult> registerToken({
    required String token,
    required String platform,
    String? deviceId,
    String? deviceName,
    String? appVersion,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/device-tokens',
        data: {
          'token': token,
          'platform': platform,
          if (deviceId != null) 'device_id': deviceId,
          if (deviceName != null) 'device_name': deviceName,
          if (appVersion != null) 'app_version': appVersion,
        },
      );

      final data = response.data;
      if (data['success'] == true && data['data'] != null) {
        debugPrint('Device token registered successfully');
        return DeviceTokenResult.fromJson(data['data']);
      }

      throw Exception(data['message'] ?? 'Failed to register device token');
    } catch (e) {
      debugPrint('Failed to register device token: $e');
      rethrow;
    }
  }

  /// Unregister a device token by its value
  ///
  /// Call this when user logs out to stop receiving notifications
  Future<bool> unregisterToken(String token) async {
    try {
      final response = await _dio.delete(
        '/auth/device-tokens',
        data: {'token': token},
      );

      return response.data['success'] == true;
    } catch (e) {
      debugPrint('Failed to unregister device token: $e');
      return false;
    }
  }

  /// Unregister a device token by UUID
  Future<bool> unregisterTokenByUuid(String uuid) async {
    try {
      final response = await _dio.delete('/auth/device-tokens/$uuid');
      return response.data['success'] == true;
    } catch (e) {
      debugPrint('Failed to unregister device token: $e');
      return false;
    }
  }

  /// List all device tokens for the current user
  Future<List<DeviceTokenData>> listTokens() async {
    try {
      final response = await _dio.get('/auth/device-tokens');

      final data = response.data;
      if (data['success'] == true && data['data'] != null) {
        return (data['data'] as List)
            .map((item) => DeviceTokenData.fromJson(item))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Failed to list device tokens: $e');
      return [];
    }
  }

  /// Unregister all device tokens for the current user
  ///
  /// Call this when user wants to log out from all devices
  Future<bool> unregisterAllTokens() async {
    try {
      final response = await _dio.delete('/auth/device-tokens/all');
      return response.data['success'] == true;
    } catch (e) {
      debugPrint('Failed to unregister all device tokens: $e');
      return false;
    }
  }
}
