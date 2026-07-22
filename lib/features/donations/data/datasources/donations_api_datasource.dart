import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../models/donation_dto.dart';

final donationsApiDataSourceProvider = Provider<DonationsApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return DonationsApiDataSource(dio);
});

/// Appels API pour les dons « seuls » côté mobile (`source = mobile_standalone`).
///
/// Le Bearer token éventuel est attaché automatiquement par `JwtAuthInterceptor`
/// (rattache le don au compte quand l'utilisateur est connecté).
class DonationsApiDataSource {
  final Dio _dio;

  DonationsApiDataSource(this._dio);

  /// `POST /v1/mobile/donations` → crée un don `pending` + PaymentIntent Stripe.
  Future<CreateDonationResponseDto> createDonation({
    required double amount,
    String? email,
    String? name,
    required String locale,
    String sourceScreen = 'settings',
  }) async {
    final payload = <String, dynamic>{
      // Envoyer un entier quand le montant est rond (2 plutôt que 2.0).
      'amount': amount == amount.roundToDouble() ? amount.toInt() : amount,
      'currency': 'EUR',
      if (email != null && email.trim().isNotEmpty) 'email': email.trim(),
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      'meta': {
        'platform': _platform(),
        'locale': locale,
        'app_version': AppConstants.appVersion,
        'source_screen': sourceScreen,
      },
    };

    final response = await _dio.post('/mobile/donations', data: payload);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return CreateDonationResponseDto.fromJson(data);
    }
    throw ApiFormatException('Expected Map response for donation creation', data);
  }

  /// `GET /v1/mobile/donations/{uuid}` → relit un don (polling léger de statut).
  Future<DonationDto> getDonation(String uuid) async {
    final response = await _dio.get('/mobile/donations/$uuid');
    final payload = ApiResponseHandler.extractObject(response.data, unwrapRoot: true);
    return DonationDto.fromJson(payload);
  }

  /// `POST /v1/mobile/donations/{uuid}/confirm-payment` → force la
  /// réconciliation immédiate (le webhook Stripe reste la source de vérité).
  Future<DonationDto> confirmPayment({
    required String uuid,
    required String paymentIntentId,
  }) async {
    final response = await _dio.post(
      '/mobile/donations/$uuid/confirm-payment',
      data: {'payment_intent_id': paymentIntentId},
    );
    final payload = ApiResponseHandler.extractObject(response.data, unwrapRoot: true);
    return DonationDto.fromJson(payload);
  }

  String _platform() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      default:
        return 'mobile';
    }
  }
}
