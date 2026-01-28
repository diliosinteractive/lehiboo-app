import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../models/hibons_api_dto.dart';

final gamificationApiDataSourceProvider = Provider<GamificationApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return GamificationApiDataSource(dio);
});

class GamificationApiDataSource {
  final Dio _dio;

  GamificationApiDataSource(this._dio);

  /// GET /mobile/hibons/wallet
  /// Récupère le portefeuille complet de l'utilisateur
  Future<WalletResponseDto> getWallet() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/wallet');
    final response = await _dio.get('/mobile/hibons/wallet');

    final data = response.data;
    if (data['data'] != null) {
      return WalletResponseDto.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to load wallet');
  }

  /// POST /mobile/hibons/daily
  /// Réclame la récompense quotidienne
  Future<DailyClaimResponseDto> claimDailyReward() async {
    debugPrint('🎮 GamificationAPI: POST /mobile/hibons/daily');
    final response = await _dio.post('/mobile/hibons/daily');

    final data = response.data;
    if (data['data'] != null) {
      return DailyClaimResponseDto.fromJson({
        'message': data['message'] ?? '',
        ...data['data'],
      });
    }
    throw Exception(data['message'] ?? 'Failed to claim daily reward');
  }

  /// GET /mobile/hibons/wheel/config
  /// Récupère la configuration de la roue
  Future<WheelConfigResponseDto> getWheelConfig() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/wheel/config');
    final response = await _dio.get('/mobile/hibons/wheel/config');

    final data = response.data;
    if (data['data'] != null) {
      return WheelConfigResponseDto.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to load wheel config');
  }

  /// POST /mobile/hibons/wheel
  /// Tourne la roue de la fortune
  Future<WheelSpinResponseDto> spinWheel() async {
    debugPrint('🎮 GamificationAPI: POST /mobile/hibons/wheel');
    final response = await _dio.post('/mobile/hibons/wheel');

    final data = response.data;
    if (data['data'] != null) {
      return WheelSpinResponseDto.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to spin wheel');
  }

  /// GET /mobile/hibons/transactions
  /// Récupère l'historique des transactions
  Future<List<TransactionDto>> getTransactions({
    String? type, // earn, spend, purchase, refund
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

    final data = response.data;
    if (data['data'] != null && data['data'] is List) {
      return (data['data'] as List)
          .map((item) => TransactionDto.fromJson(item))
          .toList();
    }
    throw Exception(data['message'] ?? 'Failed to load transactions');
  }

  /// GET /mobile/hibons/packages
  /// Récupère les packs d'achat disponibles
  Future<List<HibonPackageDto>> getPackages() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/packages');
    final response = await _dio.get('/mobile/hibons/packages');

    final data = response.data;
    if (data['data'] != null && data['data'] is List) {
      return (data['data'] as List)
          .map((item) => HibonPackageDto.fromJson(item))
          .toList();
    }
    throw Exception(data['message'] ?? 'Failed to load packages');
  }

  /// POST /mobile/hibons/purchase
  /// Crée un PaymentIntent pour acheter des hibons
  Future<PurchaseResponseDto> createPurchase({
    required String packageId,
  }) async {
    debugPrint('🎮 GamificationAPI: POST /mobile/hibons/purchase (packageId=$packageId)');
    final response = await _dio.post(
      '/mobile/hibons/purchase',
      data: {'package_id': packageId},
    );

    final data = response.data;
    if (data['data'] != null) {
      return PurchaseResponseDto.fromJson(data['data']);
    }
    throw Exception(data['message'] ?? 'Failed to create purchase');
  }

  /// POST /mobile/hibons/purchase/confirm
  /// Confirme un achat après paiement Stripe
  Future<void> confirmPurchase({
    required String paymentIntentId,
  }) async {
    debugPrint('🎮 GamificationAPI: POST /mobile/hibons/purchase/confirm');
    final response = await _dio.post(
      '/mobile/hibons/purchase/confirm',
      data: {'payment_intent_id': paymentIntentId},
    );

    final data = response.data;
    if (data['message']?.toString().toLowerCase().contains('error') == true) {
      throw Exception(data['message'] ?? 'Failed to confirm purchase');
    }
  }

  /// POST /mobile/chat/unlock
  /// Débloque des messages supplémentaires pour Petit Boo
  Future<void> unlockChatMessages() async {
    debugPrint('🎮 GamificationAPI: POST /mobile/chat/unlock');
    final response = await _dio.post('/mobile/chat/unlock');

    final data = response.data;
    if (data['message']?.toString().toLowerCase().contains('error') == true) {
      throw Exception(data['message'] ?? 'Failed to unlock chat messages');
    }
  }

  /// GET /mobile/hibons/achievements
  /// Récupère les achievements/badges de l'utilisateur
  Future<List<AchievementDto>> getAchievements() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/achievements');
    final response = await _dio.get('/mobile/hibons/achievements');

    final data = response.data;
    if (data['data'] != null && data['data'] is List) {
      return (data['data'] as List)
          .map((item) => AchievementDto.fromJson(item))
          .toList();
    }
    return [];
  }

  /// GET /mobile/hibons/challenges
  /// Récupère les challenges actifs de l'utilisateur
  Future<List<ChallengeDto>> getChallenges() async {
    debugPrint('🎮 GamificationAPI: GET /mobile/hibons/challenges');
    final response = await _dio.get('/mobile/hibons/challenges');

    final data = response.data;
    if (data['data'] != null && data['data'] is List) {
      return (data['data'] as List)
          .map((item) => ChallengeDto.fromJson(item))
          .toList();
    }
    return [];
  }
}
