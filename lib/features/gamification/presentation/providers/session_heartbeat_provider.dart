import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/gamification_api_datasource.dart';

/// Clé SharedPrefs : dernière date (yyyy-MM-dd) à laquelle le heartbeat
/// a été crédité. Elle est suffixée par l'identifiant utilisateur pour éviter
/// qu'un compte empêche un autre compte du même appareil d'être crédité.
const _kLastHeartbeatDateKey = 'hibons.heartbeat.last_date';

/// Délai requis avant que le serveur accepte le heartbeat (3 min).
const _kHeartbeatDelay = Duration(minutes: 3);

final sessionHeartbeatProvider =
    StateNotifierProvider<SessionHeartbeatNotifier, void>((ref) {
  final userId = ref.watch(
    authProvider.select(
      (state) => state.isAuthenticated ? state.user?.id : null,
    ),
  );
  return SessionHeartbeatNotifier(ref, userId: userId);
});

/// Observe le lifecycle, démarre un Timer de 3 min à chaque foreground et
/// envoie le heartbeat 1×/jour au passage des 3 min, à condition que l'user
/// soit authentifié.
class SessionHeartbeatNotifier extends StateNotifier<void>
    with WidgetsBindingObserver {
  final Ref _ref;
  final String? _userId;
  Timer? _timer;
  DateTime? _sessionStartedAt;
  bool _registered = false;

  SessionHeartbeatNotifier(this._ref, {required String? userId})
      : _userId = userId,
        super(null) {
    WidgetsBinding.instance.addObserver(this);
    _registered = true;

    // Premier foreground (cold start), ou création d'un nouveau notifier
    // quand un user se connecte/change de compte alors que l'app est ouverte.
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    if (lifecycleState == null || lifecycleState == AppLifecycleState.resumed) {
      _onForeground();
    }
  }

  @override
  void dispose() {
    if (_registered) {
      WidgetsBinding.instance.removeObserver(this);
      _registered = false;
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onForeground();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _onBackground();
    }
  }

  void _onForeground() {
    if (_userId == null) return;

    _sessionStartedAt = DateTime.now().toUtc();
    _timer?.cancel();
    _timer = Timer(_kHeartbeatDelay, _sendHeartbeat);
  }

  void _onBackground() {
    _timer?.cancel();
  }

  Future<void> _sendHeartbeat() async {
    final userId = _userId;
    final sessionStartedAt = _sessionStartedAt;
    if (userId == null || sessionStartedAt == null) return;
    if (!_isCurrentSession(userId)) return;

    // Skip si déjà crédité aujourd'hui (évite un round-trip inutile).
    final prefs = await SharedPreferences.getInstance();
    final heartbeatDateKey = sessionHeartbeatDateKeyForUser(userId);
    final lastDate = prefs.getString(heartbeatDateKey);
    final today = _todayLocalKey();
    if (lastDate == today) return;
    if (!mounted || !_isCurrentSession(userId)) return;

    final api = _ref.read(gamificationApiDataSourceProvider);
    try {
      final result = await api.sendSessionHeartbeat(sessionStartedAt);
      if (result.awarded) {
        await prefs.setString(heartbeatDateKey, today);
        // Plan 05 : la balance est mise à jour par HibonsUpdateInterceptor
        // (enveloppe `hibons_update` à la racine). Pas d'invalidation manuelle.
      } else if (result.reason == 'already_today') {
        // Le serveur sait que c'est déjà fait — synchroniser le cache local.
        await prefs.setString(heartbeatDateKey, today);
      }
    } catch (_) {
      // Best-effort : silencieux en cas d'erreur réseau.
    }
  }

  bool _isCurrentSession(String userId) {
    final authState = _ref.read(authProvider);
    return authState.isAuthenticated && authState.user?.id == userId;
  }

  String _todayLocalKey() {
    final now = DateTime.now();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '${now.year}-$m-$d';
  }
}

@visibleForTesting
String sessionHeartbeatDateKeyForUser(String userId) {
  return '$_kLastHeartbeatDateKey.$userId';
}
