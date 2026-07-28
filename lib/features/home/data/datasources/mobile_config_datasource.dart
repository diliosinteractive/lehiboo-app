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
  ///
  /// Errors remain observable to the provider. Presentation consumers use
  /// [MobileAppConfig.defaultConfig] while no server value is available.
  Future<MobileAppConfig> getConfig() async {
    try {
      final response = await _dio.get('/mobile/config');
      final payload = ApiResponseHandler.extractObject(response.data);
      return MobileAppConfig.fromJson(payload);
    } catch (e, stackTrace) {
      debugPrint('MobileConfig error: ${ApiResponseHandler.extractError(e)}');
      Error.throwWithStackTrace(e, stackTrace);
    }
  }
}
