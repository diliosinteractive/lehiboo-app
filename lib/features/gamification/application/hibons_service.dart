import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/hibons_api_dto.dart';
import '../data/models/hibons_update.dart';
import '../presentation/providers/gamification_provider.dart';

/// Événement de franchissement de rang émis quand `hibons_update.rank_changed`.
class RankUpEvent {
  final String rank;
  final String rankLabel;

  const RankUpEvent({required this.rank, required this.rankLabel});
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
  final _deltaController = StreamController<HibonsUpdate>.broadcast();
  final _rankUpController = StreamController<RankUpEvent>.broadcast();

  Stream<HibonsUpdate> get deltaStream => _deltaController.stream;
  Stream<RankUpEvent> get rankUpStream => _rankUpController.stream;

  void attach(ProviderContainer container) {
    debugPrint('🪙 HibonsService: attached to ProviderContainer');
    _container = container;
  }

  void detach() {
    _container = null;
  }

  /// Lit l'enveloppe `hibons_update` à la racine d'une réponse JSON et
  /// applique l'update au state global. No-op si l'enveloppe est absente.
  ///
  /// Si [silent] est vrai, le state est mis à jour mais aucune animation
  /// (snackbar, overlay rank-up) n'est déclenchée — utile pour les routes
  /// qui ont déjà leur propre UI de célébration (roue, daily reward).
  void handleEnvelope(Map<String, dynamic> raw, {bool silent = false}) {
    final envelope = raw['hibons_update'];
    if (envelope is! Map<String, dynamic>) return;

    HibonsUpdateDto dto;
    try {
      dto = HibonsUpdateDto.fromJson(envelope);
    } catch (e, st) {
      debugPrint('🪙 HibonsService: failed to parse hibons_update envelope: $e\n$st');
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
    );

    debugPrint(
      '🪙 HibonsService: parsed update delta=${update.delta} balance=${update.newBalance} rankChanged=${update.rankChanged}',
    );

    // Mise à jour du state Riverpod
    final container = _container;
    if (container != null) {
      try {
        container
            .read(gamificationNotifierProvider.notifier)
            .applyUpdate(update);
      } catch (e) {
        debugPrint('🪙 HibonsService: applyUpdate failed: $e');
      }
    } else {
      debugPrint('🪙 HibonsService: container not attached — skipping state update');
    }

    if (silent) {
      debugPrint('🪙 HibonsService: silent mode — state updated, no animation');
      return;
    }

    // Émission des événements pour les animations
    if (update.delta != 0) {
      debugPrint('🪙 HibonsService: emitting delta on stream (delta=${update.delta})');
      _deltaController.add(update);
    }
    if (update.rankChanged && update.newRank != null && update.newRankLabel != null) {
      _rankUpController.add(RankUpEvent(
        rank: update.newRank!,
        rankLabel: update.newRankLabel!,
      ));
    }
  }

  @visibleForTesting
  void disposeForTest() {
    _deltaController.close();
    _rankUpController.close();
  }
}
