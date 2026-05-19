import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/shared_preferences_provider.dart';
import 'analytics_event.dart';
import 'analytics_provider.dart';
import 'analytics_service.dart';

/// Statut du consentement utilisateur à la collecte analytics.
enum AnalyticsConsentStatus {
  /// L'utilisateur n'a pas encore choisi → consent gate à afficher.
  unknown,

  /// L'utilisateur a accepté → `setCollectionEnabled(true)`.
  granted,

  /// L'utilisateur a refusé → `setCollectionEnabled(false)`, NoopAnalytics
  /// peut être substitué côté provider override si besoin.
  denied,
}

/// État persistant du consentement.
class AnalyticsConsentState {
  final AnalyticsConsentStatus status;

  /// Timestamp epoch ms de la décision (utile pour audit RGPD).
  final int? decidedAt;

  /// Version du texte de consent au moment de la décision. Permet de
  /// re-prompter si la politique change (la logique de re-prompt n'est pas
  /// encore implémentée — extension future, cf. [currentVersion]).
  final int? version;

  const AnalyticsConsentState({
    this.status = AnalyticsConsentStatus.unknown,
    this.decidedAt,
    this.version,
  });

  bool get isDecided => status != AnalyticsConsentStatus.unknown;
  bool get isGranted => status == AnalyticsConsentStatus.granted;
}

/// Notifier du consentement. Hydraté au boot via [hydrate] (provider).
/// Les mutations [grant]/[deny]/[reset] persistent et notifient le service
/// analytics dans la foulée.
class AnalyticsConsentNotifier extends StateNotifier<AnalyticsConsentState> {
  AnalyticsConsentNotifier(this._prefs, this._analytics)
      : super(_readFromPrefs(_prefs));

  final SharedPreferences _prefs;
  final AnalyticsService _analytics;

  /// Version courante du texte de consent. À bumper si la politique change ;
  /// la logique de re-prompt comparant cette valeur à `version` stockée n'est
  /// pas encore implémentée (extension future, cf. doc étape 7).
  static const int currentVersion = 1;

  static const String _statusKey = 'analytics_consent_status';
  static const String _decidedAtKey = 'analytics_consent_decided_at';
  static const String _versionKey = 'analytics_consent_version';

  static AnalyticsConsentState _readFromPrefs(SharedPreferences prefs) {
    final raw = prefs.getString(_statusKey);
    final status = switch (raw) {
      'granted' => AnalyticsConsentStatus.granted,
      'denied' => AnalyticsConsentStatus.denied,
      _ => AnalyticsConsentStatus.unknown,
    };
    return AnalyticsConsentState(
      status: status,
      decidedAt: prefs.getInt(_decidedAtKey),
      version: prefs.getInt(_versionKey),
    );
  }

  Future<void> grant() => _persist(AnalyticsConsentStatus.granted);
  Future<void> deny() => _persist(AnalyticsConsentStatus.denied);

  /// Remise à zéro (pour debug / tests). Le toggle Settings utilise
  /// [grant]/[deny] directement, pas [reset].
  Future<void> reset() async {
    await _prefs.remove(_statusKey);
    await _prefs.remove(_decidedAtKey);
    await _prefs.remove(_versionKey);
    state = const AnalyticsConsentState();
    await _analytics.setCollectionEnabled(false);
    await _analytics.setUserProperty(
      AnalyticsUserProperty.notifConsent,
      null,
    );
  }

  Future<void> _persist(AnalyticsConsentStatus status) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _prefs.setString(_statusKey, status.name);
    await _prefs.setInt(_decidedAtKey, now);
    await _prefs.setInt(_versionKey, currentVersion);
    state = AnalyticsConsentState(
      status: status,
      decidedAt: now,
      version: currentVersion,
    );
    await _analytics.setCollectionEnabled(
      status == AnalyticsConsentStatus.granted,
    );
    await _analytics.setUserProperty(
      AnalyticsUserProperty.notifConsent,
      status.name,
    );
  }
}

/// Provider Riverpod du consentement.
final analyticsConsentProvider = StateNotifierProvider<
    AnalyticsConsentNotifier, AnalyticsConsentState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final analytics = ref.watch(analyticsServiceProvider);
  return AnalyticsConsentNotifier(prefs, analytics);
});

/// Lecture éager du statut au boot (avant la construction du provider tree).
/// Utilisée par `main.dart` pour appliquer `setCollectionEnabled` dès le
/// `Firebase.initializeApp`, sans dépendre de Riverpod.
AnalyticsConsentStatus readConsentStatusFromPrefs(SharedPreferences prefs) {
  return AnalyticsConsentNotifier._readFromPrefs(prefs).status;
}
