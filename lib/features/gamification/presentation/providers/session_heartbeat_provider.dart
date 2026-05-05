import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/gamification_api_datasource.dart';

/// Clé SharedPrefs : dernière date (yyyy-MM-dd) à laquelle le heartbeat
/// a été crédité. Reset implicite quand on franchit minuit local.
const _kLastHeartbeatDateKey = 'hibons.heartbeat.last_date';

/// Délai requis avant que le serveur accepte le heartbeat (3 min).
const _kHeartbeatDelay = Duration(minutes: 3);

final sessionHeartbeatProvider =
    StateNotifierProvider<SessionHeartbeatNotifier, void>((ref) {
  return SessionHeartbeatNotifier(ref);
});

/// Observe le lifecycle, démarre un Timer de 3 min à chaque foreground et
/// envoie le heartbeat 1×/jour au passage des 3 min, à condition que l'user
/// soit authentifié.
class SessionHeartbeatNotifier extends StateNotifier<void>
    with WidgetsBindingObserver {
  final Ref _ref;
  Timer? _timer;
  DateTime? _sessionStartedAt;
  bool _registered = false;

  SessionHeartbeatNotifier(this._ref) : super(null) {
    WidgetsBinding.instance.addObserver(this);
    _registered = true;
    // Premier foreground (au cold start)
    _onForeground();
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
    _sessionStartedAt = DateTime.now().toUtc();
    _timer?.cancel();
    _timer = Timer(_kHeartbeatDelay, _sendHeartbeat);
  }

  void _onBackground() {
    _timer?.cancel();
  }

  Future<void> _sendHeartbeat() async {
    if (_sessionStartedAt == null) return;
    if (!_ref.read(isAuthenticatedProvider)) return;

    // Skip si déjà crédité aujourd'hui (évite un round-trip inutile).
    final prefs = await SharedPreferences.getInstance();
    final lastDate = prefs.getString(_kLastHeartbeatDateKey);
    final today = _todayLocalKey();
    if (lastDate == today) return;

    final api = _ref.read(gamificationApiDataSourceProvider);
    try {
      final result = await api.sendSessionHeartbeat(_sessionStartedAt!);
      if (result.awarded) {
        await prefs.setString(_kLastHeartbeatDateKey, today);
        // Plan 05 : la balance est mise à jour par HibonsUpdateInterceptor
        // (enveloppe `hibons_update` à la racine). Pas d'invalidation manuelle.
      } else if (result.reason == 'already_today') {
        // Le serveur sait que c'est déjà fait — synchroniser le cache local.
        await prefs.setString(_kLastHeartbeatDateKey, today);
      }
    } catch (_) {
      // Best-effort : silencieux en cas d'erreur réseau.
    }
  }

  String _todayLocalKey() {
    final now = DateTime.now();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '${now.year}-$m-$d';
  }
}
