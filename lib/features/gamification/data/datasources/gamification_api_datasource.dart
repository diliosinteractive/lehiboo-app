import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../models/hibons_api_dto.dart';

final gamificationApiDataSourceProvider = Provider<GamificationApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return GamificationApiDataSource(dio);
});

class GamificationApiDataSource {
  final Dio _dio;

  GamificationApiDataSource(this._dio);

  Future<WalletResponseDto> getWallet() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/wallet');
    final response = await _dio.get('/mobile/hibons/wallet');
    final payload = ApiResponseHandler.extractObject(response.data);
    return WalletResponseDto.fromJson(payload);
  }

  Future<DailyClaimResponseDto> claimDailyReward() async {
    debugPrint('🎮 GamificationAPI: POST /mobile/hibons/daily');
    final response = await _dio.post('/mobile/hibons/daily');
    final raw = response.data;
    final payload = ApiResponseHandler.extractObject(raw);
    return DailyClaimResponseDto.fromJson({
      'message': (raw is Map<String, dynamic> ? raw['message'] : null) ?? '',
      ...payload,
    });
  }

  Future<WheelConfigResponseDto> getWheelConfig() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/wheel/config');
    final response = await _dio.get('/mobile/hibons/wheel/config');
    final payload = ApiResponseHandler.extractObject(response.data);
    return WheelConfigResponseDto.fromJson(payload);
  }

  Future<WheelSpinResponseDto> spinWheel() async {
    debugPrint('🎮 GamificationAPI: POST /mobile/hibons/wheel');
    final response = await _dio.post('/mobile/hibons/wheel');
    final payload = ApiResponseHandler.extractObject(response.data);
    return WheelSpinResponseDto.fromJson(payload);
  }

  Future<List<TransactionDto>> getTransactions({
    String? type,
    int? page,
    int? perPage,
  }) async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/transactions');

    final queryParams = <String, dynamic>{};
    if (type != null) queryParams['type'] = type;
    if (page != null) queryParams['page'] = page;
    if (perPage != null) queryParams['per_page'] = perPage;

    final response = await _dio.get(
      '/mobile/hibons/transactions',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final list = ApiResponseHandler.extractList(response.data);
    return list.map((item) => TransactionDto.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<List<HibonPackageDto>> getPackages() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/packages');
    final response = await _dio.get('/mobile/hibons/packages');

    final list = ApiResponseHandler.extractList(response.data);
    return list.map((item) => HibonPackageDto.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<PurchaseResponseDto> createPurchase({required String packageId}) async {
    debugPrint('🎮 GamificationAPI: POST /mobile/hibons/purchase');
    final response = await _dio.post(
      '/mobile/hibons/purchase',
      data: {'package_id': packageId},
    );
    final payload = ApiResponseHandler.extractObject(response.data);
    return PurchaseResponseDto.fromJson(payload);
  }

  Future<void> confirmPurchase({required String paymentIntentId}) async {
    debugPrint('🎮 GamificationAPI: POST /mobile/hibons/purchase/confirm');
    await _dio.post(
      '/mobile/hibons/purchase/confirm',
      data: {'payment_intent_id': paymentIntentId},
    );
  }

  Future<void> unlockChatMessages() async {
    debugPrint('🎮 GamificationAPI: POST /mobile/chat/unlock');
    await _dio.post('/mobile/chat/unlock');
  }

  Future<List<AchievementDto>> getAchievements() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/achievements');
    final response = await _dio.get('/mobile/hibons/achievements');

    try {
      final list = ApiResponseHandler.extractList(response.data);
      return list.map((item) => AchievementDto.fromJson(item as Map<String, dynamic>)).toList();
    } on ApiFormatException {
      return [];
    }
  }

  Future<List<ChallengeDto>> getChallenges() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/challenges');
    final response = await _dio.get('/mobile/hibons/challenges');

    try {
      final list = ApiResponseHandler.extractList(response.data);
      return list.map((item) => ChallengeDto.fromJson(item as Map<String, dynamic>)).toList();
    } on ApiFormatException {
      return [];
    }
  }
}
