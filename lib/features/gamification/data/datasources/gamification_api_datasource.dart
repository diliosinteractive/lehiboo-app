import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../models/badge_dto.dart';
import '../models/hibons_api_dto.dart';

final gamificationApiDataSourceProvider = Provider<GamificationApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return GamificationApiDataSource(dio);
});

/// Levée quand un endpoint d'achat Hibons renvoie 404 (feature désactivée v1).
class HibonsPurchaseDisabledException implements Exception {
  const HibonsPurchaseDisabledException();
  @override
  String toString() => 'HibonsPurchaseDisabledException: feature disabled';
}

class GamificationApiDataSource {
  final Dio _dio;

  GamificationApiDataSource(this._dio);

  Future<WalletResponseDto> getWallet() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/wallet');
    final response = await _dio.get('/mobile/hibons/wallet');
    final payload = ApiResponseHandler.extractObject(response.data);
    return WalletResponseDto.fromJson(payload);
  }

  Future<BalanceResponseDto> getBalance() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/balance');
    final response = await _dio.get('/mobile/hibons/balance');
    final payload = ApiResponseHandler.extractObject(response.data);
    return BalanceResponseDto.fromJson(payload);
  }

  Future<List<ActionsCatalogEntryDto>> getActionsCatalog() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/actions-catalog');
    final response = await _dio.get('/mobile/hibons/actions-catalog');
    final list = ApiResponseHandler.extractList(response.data);
    return list
        .map((item) =>
            ActionsCatalogEntryDto.fromJson(item as Map<String, dynamic>))
        .toList();
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

  Future<TransactionsListResponseDto> getTransactions({
    String? type,
    String? pillar,
    int? page,
    int? perPage,
  }) async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/transactions');

    final queryParams = <String, dynamic>{};
    if (type != null) queryParams['type'] = type;
    if (pillar != null) queryParams['pillar'] = pillar;
    if (page != null) queryParams['page'] = page;
    if (perPage != null) queryParams['per_page'] = perPage;

    final response = await _dio.get(
      '/mobile/hibons/transactions',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final list = ApiResponseHandler.extractList(response.data);
    final items = list
        .map((item) => TransactionDto.fromJson(item as Map<String, dynamic>))
        .toList();

    // Le `meta` est à la racine de la réponse — `extractList` ne l'expose pas.
    final raw = response.data;
    final metaRaw = raw is Map<String, dynamic> ? raw['meta'] : null;
    final meta = metaRaw is Map<String, dynamic> ? metaRaw : const <String, dynamic>{};

    final earningsByPillarRaw = meta['earnings_by_pillar'];
    final earningsByPillar = earningsByPillarRaw is List
        ? earningsByPillarRaw
            .whereType<Map<String, dynamic>>()
            .map(EarningsByPillarEntryDto.fromJson)
            .toList()
        : const <EarningsByPillarEntryDto>[];

    return TransactionsListResponseDto(
      items: items,
      currentBalance: (meta['current_balance'] as num?)?.toInt() ?? 0,
      lifetimeEarned: (meta['lifetime_earned'] as num?)?.toInt() ?? 0,
      earningsByPillar: earningsByPillar,
    );
  }

  Future<List<HibonPackageDto>> getPackages() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/packages');
    try {
      final response = await _dio.get('/mobile/hibons/packages');
      final list = ApiResponseHandler.extractList(response.data);
      return list.map((item) => HibonPackageDto.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        debugPrint('🎮 GamificationAPI: hibons purchase disabled (404)');
        return const [];
      }
      rethrow;
    }
  }

  Future<PurchaseResponseDto> createPurchase({required String packageId}) async {
    debugPrint('🎮 GamificationAPI: POST /mobile/hibons/purchase');
    try {
      final response = await _dio.post(
        '/mobile/hibons/purchase',
        data: {'package_id': packageId},
      );
      final payload = ApiResponseHandler.extractObject(response.data);
      return PurchaseResponseDto.fromJson(payload);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        debugPrint('🎮 GamificationAPI: hibons purchase disabled (404)');
        throw const HibonsPurchaseDisabledException();
      }
      rethrow;
    }
  }

  Future<void> confirmPurchase({required String paymentIntentId}) async {
    debugPrint('🎮 GamificationAPI: POST /mobile/hibons/purchase/confirm');
    try {
      await _dio.post(
        '/mobile/hibons/purchase/confirm',
        data: {'payment_intent_id': paymentIntentId},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        debugPrint('🎮 GamificationAPI: hibons purchase disabled (404)');
        throw const HibonsPurchaseDisabledException();
      }
      rethrow;
    }
  }

  Future<void> unlockChatMessages() async {
    debugPrint('🎮 GamificationAPI: POST /mobile/chat/unlock');
    await _dio.post('/mobile/chat/unlock');
  }

  Future<BadgesResponseDto> getBadges() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/badges');
    final response = await _dio.get('/mobile/badges');

    final list = ApiResponseHandler.extractList(response.data);
    final items = list
        .map((item) => BadgeDto.fromJson(item as Map<String, dynamic>))
        .toList();

    final raw = response.data;
    final metaRaw = raw is Map<String, dynamic> ? raw['meta'] : null;
    final meta = metaRaw is Map<String, dynamic>
        ? BadgesMetaDto.fromJson(metaRaw)
        : const BadgesMetaDto(
            lifetimeEarned: 0,
            currentRank: 'curieux',
            currentRankLabel: 'Curieux',
            total: 0,
            unlocked: 0,
            locked: 0,
          );

    return BadgesResponseDto(items: items, meta: meta);
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

  /// Heartbeat session : crédite l'user après 3 min en foreground (1×/jour).
  /// Tolère 422 (too_short / already_today) en renvoyant `awarded: false`.
  Future<HibonsRewardResponseDto> sendSessionHeartbeat(DateTime sessionStartedAt) async {
    debugPrint('🎮 GamificationAPI: POST /mobile/hibons/session-heartbeat');
    try {
      final response = await _dio.post(
        '/mobile/hibons/session-heartbeat',
        data: {'session_started_at': sessionStartedAt.toUtc().toIso8601String()},
      );
      final payload = ApiResponseHandler.extractObject(response.data);
      return HibonsRewardResponseDto.fromJson(payload);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final raw = e.response?.data;
        final payload = raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>
            ? raw['data'] as Map<String, dynamic>
            : <String, dynamic>{};
        return HibonsRewardResponseDto.fromJson(payload);
      }
      rethrow;
    }
  }

  /// Track-view sur une catégorie. Crédite 20 H à la 1ère exploration (cap 5/jour).
  Future<HibonsRewardResponseDto> trackCategoryView(String slug) async {
    debugPrint('🎮 GamificationAPI: POST /categories/$slug/track-view');
    try {
      final response = await _dio.post('/categories/$slug/track-view');
      final payload = ApiResponseHandler.extractObject(response.data);
      return HibonsRewardResponseDto.fromJson(payload);
    } on DioException {
      // Tolérer silencieusement (analytics best-effort)
      return const HibonsRewardResponseDto();
    }
  }

  /// Track-share sur un event. Crédite 10 H par event (cap 2/sem).
  /// channel ∈ {whatsapp, facebook, twitter, native, email, link, other}.
  Future<HibonsRewardResponseDto> trackEventShare(String slug, String channel) async {
    debugPrint('🎮 GamificationAPI: POST /events/$slug/track-share (channel: $channel)');
    try {
      final response = await _dio.post(
        '/events/$slug/track-share',
        data: {'channel': channel},
      );
      final payload = ApiResponseHandler.extractObject(response.data);
      return HibonsRewardResponseDto.fromJson(payload);
    } on DioException {
      return const HibonsRewardResponseDto();
    }
  }
}
