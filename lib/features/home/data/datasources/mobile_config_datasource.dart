import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/mobile_app_config.dart';

final mobileConfigDataSourceProvider = Provider<MobileConfigDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return MobileConfigDataSource(dio);
});

/// Data source for mobile app configuration from Laravel v2 API.
class MobileConfigDataSource {
  final Dio _dio;

  MobileConfigDataSource(this._dio);

  /// Get mobile app configuration.
  ///
  /// Returns hero section, banners, and customizable texts.
  Future<MobileAppConfig> getConfig() async {
    debugPrint('=== MobileConfigDataSource.getConfig ===');

    try {
      final response = await _dio.get('/mobile/config');
      final data = response.data;

      debugPrint('API Response: ${data.toString().substring(0, 100)}...');

      if (data['data'] != null) {
        return MobileAppConfig.fromJson(data['data']);
      }

      // Fallback to default config
      debugPrint('No data in response, using default config');
      return MobileAppConfig.defaultConfig();
    } catch (e, stack) {
      debugPrint('Error fetching mobile config: $e');
      debugPrint('Stack: $stack');
      // Return default config on error
      return MobileAppConfig.defaultConfig();
    }
  }
}
