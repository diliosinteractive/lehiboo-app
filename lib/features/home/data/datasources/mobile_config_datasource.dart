import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
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
  /// Falls back to [MobileAppConfig.defaultConfig] on any error.
  Future<MobileAppConfig> getConfig() async {
    try {
      final response = await _dio.get('/mobile/config');
      final payload = ApiResponseHandler.extractObject(response.data);
      return MobileAppConfig.fromJson(payload);
    } catch (e) {
      debugPrint('MobileConfig error: ${ApiResponseHandler.extractError(e)}');
      return MobileAppConfig.defaultConfig();
    }
  }
}
