import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics_event.dart';
import '../../../core/analytics/analytics_provider.dart';
import '../data/models/hibons_api_dto.dart';
import '../data/models/hibons_update.dart';
import '../presentation/providers/gamification_provider.dart';

/// Événement de franchissement de rang émis quand `hibons_update.rank_changed`.
class RankUpEvent {
  final String rank;
  final String rankLabel;
  final GamificationSessionKey ownerSession;

  const RankUpEvent({
    required this.rank,
    required this.rankLabel,
    required this.ownerSession,
  });
}

/// Opaque owner stamped onto a Dio request before it leaves the app.
///
/// The session key is identity-based, which also rejects an old response after
/// an A -> B -> A account cycle.
class HibonsRequestOwner {
  const HibonsRequestOwner._(this.session);

  final GamificationSessionKey session;
}

class HibonsDeltaEvent {
  const HibonsDeltaEvent({required this.update, required this.ownerSession});

  final HibonsUpdate update;
  final GamificationSessionKey ownerSession;
}

/// Singleton qui fait le pont entre `HibonsUpdateInterceptor` (Dio) et
/// le state Riverpod. Pure-Dart, testable sans Flutter.
///
/// Usage :
/// 1. Au boot, appeler `HibonsService.instance.attach(container)` une fois
///    le `ProviderContainer` construit.
/// 2. L'intercepteur appelle `handleEnvelope(map)` à chaque réponse.
/// 3. `HibonsAnimationCoordinator` souscrit à `deltaStream` et `rankUpStream`
///    pour déclencher toast et overlay rank-up.
class HibonsService {
  HibonsService._internal();

  static final HibonsService instance = HibonsService._internal();

  ProviderContainer? _container;
  final _deltaController = StreamController<HibonsDeltaEvent>.broadcast();
  final _rankUpController = StreamController<RankUpEvent>.broadcast();

  Stream<HibonsDeltaEvent> get deltaStream => _deltaController.stream;
  Stream<RankUpEvent> get rankUpStream => _rankUpController.stream;

  void attach(ProviderContainer container) {
    debugPrint('🪙 HibonsService: attached to ProviderContainer');
    _container = container;
  }

  void detach() {
    _container = null;
  }

  /// Captures the exact authenticated session that initiated an HTTP request.
  /// Returns null for anonymous/unattached requests; such responses are never
  /// allowed to mutate or animate authenticated Hibons state.
  HibonsRequestOwner? captureRequestOwner() {
    final container = _container;
    if (container == null) return null;
    try {
      final session = container.read(gamificationSessionProvider);
      return session == null ? null : HibonsRequestOwner._(session);
    } catch (e) {
      debugPrint('🪙 HibonsService: request owner capture failed: $e');
      return null;
    }
  }

  bool _ownsCurrentSession(
    ProviderContainer container,
    HibonsRequestOwner? owner,
  ) {
    if (owner == null) return false;
    try {
      return identical(
        container.read(gamificationSessionProvider),
        owner.session,
      );
    } catch (_) {
      return false;
    }
  }

  /// Lit l'enveloppe `hibons_update` à la racine d'une réponse JSON et
  /// applique l'update au state global. No-op si l'enveloppe est absente.
  ///
  /// Si [silent] est vrai, le state est mis à jour mais aucune animation
  /// (snackbar, overlay rank-up) n'est déclenchée — utile pour les routes
  /// qui ont déjà leur propre UI de célébration (roue, daily reward).
  void handleEnvelope(
    Map<String, dynamic> raw, {
    required HibonsRequestOwner? owner,
    bool silent = false,
  }) {
    final envelope = raw['hibons_update'];
    if (envelope is! Map<String, dynamic>) return;

    final container = _container;
    final activeOwner = owner;
    if (container == null ||
        activeOwner == null ||
        !_ownsCurrentSession(container, activeOwner)) {
      debugPrint(
        '🪙 HibonsService: stale/unowned envelope ignored',
      );
      return;
    }

    HibonsUpdateDto dto;
    try {
      dto = HibonsUpdateDto.fromJson(envelope);
    } catch (e, st) {
      debugPrint(
          '🪙 HibonsService: failed to parse hibons_update envelope: $e\n$st');
      return;
    }

    final update = HibonsUpdate(
      delta: dto.delta,
      newBalance: dto.newBalance,
      newLifetime: dto.newLifetime,
      lifetimeDelta: dto.lifetimeDelta,
      rankChanged: dto.rankChanged,
      newRank: dto.newRank,
      newRankLabel: dto.newRankLabel,
      animationLabel: dto.animationLabel,
      pillar: dto.pillar,
      source: dto.source,
      rewardMessage: dto.rewardMessage,
    );

    debugPrint(
      '🪙 HibonsService: parsed update delta=${update.delta} balance=${update.newBalance} source=${update.source} rankChanged=${update.rankChanged}',
    );

    // Mise à jour du state Riverpod
    try {
      container
          .read(gamificationNotifierProvider(activeOwner.session).notifier)
          .applyUpdate(
            update,
            ownerSession: activeOwner.session,
          );
    } catch (e) {
      debugPrint('🪙 HibonsService: applyUpdate failed: $e');
    }

    // Riverpod listeners run synchronously when the wallet is published. If
    // one of them ends/replaces the session, do not emit an A animation or
    // analytics event under the newly active identity.
    if (!_ownsCurrentSession(container, activeOwner)) return;

    if (silent) {
      debugPrint('🪙 HibonsService: silent mode — state updated, no animation');
      return;
    }

    // Émission des événements pour les animations
    if (update.delta != 0) {
      debugPrint(
          '🪙 HibonsService: emitting delta on stream (delta=${update.delta})');
      _deltaController.add(HibonsDeltaEvent(
        update: update,
        ownerSession: activeOwner.session,
      ));
    }
    if (update.rankChanged &&
        update.newRank != null &&
        update.newRankLabel != null) {
      _rankUpController.add(RankUpEvent(
        rank: update.newRank!,
        rankLabel: update.newRankLabel!,
        ownerSession: activeOwner.session,
      ));
    }

    // Analytics — `hibons_earned` (delta positif uniquement, on ignore les
    // débits manuels) et `hibons_rank_up`. Lecture du service via le
    // container : `attach()` est appelé au boot avant tout `handleEnvelope`.
    try {
      final analytics = container.read(analyticsServiceProvider);
      if (update.delta > 0) {
        analytics.logEvent(
          AnalyticsEvent.hibonsEarned,
          params: {
            AnalyticsParam.amount: update.delta,
            AnalyticsParam.source: update.source ?? 'unknown',
          },
        );
      }
      if (update.rankChanged && update.newRank != null) {
        analytics.logEvent(
          AnalyticsEvent.hibonsRankUp,
          params: {AnalyticsParam.newRank: update.newRank!},
        );
        // User property pour segmenter sans event scope.
        analytics.setUserProperty(
          AnalyticsUserProperty.hibonsRank,
          update.newRank,
        );
      }
    } catch (e) {
      debugPrint('🪙 HibonsService: analytics logging failed: $e');
    }
  }

  @visibleForTesting
  void disposeForTest() {
    _deltaController.close();
    _rankUpController.close();
  }
}
