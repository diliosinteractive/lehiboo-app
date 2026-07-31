import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../application/hibons_service.dart';

/// Lit l'enveloppe `hibons_update` injectée à la racine de toute mutation
/// Hibons-modifying par le backend (Plan 05). Coût négligeable :
/// un `is Map` + un lookup, sur chaque réponse.
class HibonsUpdateInterceptor extends Interceptor {
  @visibleForTesting
  static const requestOwnerExtraKey = 'lehiboo.hibons_request_owner';

  /// Routes pour lesquelles l'enveloppe doit mettre à jour le state mais
  /// **sans** déclencher de snackbar — l'écran a déjà sa propre UI de
  /// célébration (dialog roue, animation daily reward, etc.).
  static const _silentPaths = <String>[
    '/mobile/hibons/wheel',
    '/mobile/hibons/daily',
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Keep the first owner when Dio retries/redirects a RequestOptions object.
    // Re-stamping a request after an account switch could incorrectly make an
    // old response look as though it belonged to the new account.
    if (!options.extra.containsKey(requestOwnerExtraKey)) {
      options.extra[requestOwnerExtraKey] =
          HibonsService.instance.captureRequestOwner();
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final envelope = data['hibons_update'];
      if (envelope is Map<String, dynamic>) {
        final path = response.requestOptions.path;
        final silent = _silentPaths.any((p) => path.endsWith(p));
        debugPrint(
          '🪙 HibonsUpdateInterceptor: envelope detected on $path (silent=$silent) → $envelope',
        );
        try {
          final owner = response.requestOptions.extra[requestOwnerExtraKey]
              as HibonsRequestOwner?;
          HibonsService.instance.handleEnvelope(
            data,
            owner: owner,
            silent: silent,
          );
        } catch (e, st) {
          // Best-effort : ne jamais casser une réponse à cause de l'enveloppe.
          debugPrint(
              '🪙 HibonsUpdateInterceptor: handleEnvelope error: $e\n$st');
        }
      } else {
        debugPrint(
          '🪙 HibonsUpdateInterceptor: no envelope on ${response.requestOptions.path}',
        );
      }
    }
    handler.next(response);
  }
}
