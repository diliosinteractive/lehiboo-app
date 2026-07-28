import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Abstraction au-dessus de [FirebaseAnalytics].
///
/// Toutes les features doivent passer par cette interface via le
/// `analyticsServiceProvider` Riverpod — pas d'accès direct à
/// `FirebaseAnalytics.instance` dans le code applicatif. Permet :
/// - de mocker en tests (override du provider),
/// - de basculer sur [NoopAnalyticsService] si Firebase a échoué à s'init
///   ou si l'utilisateur a refusé le consentement,
/// - de centraliser la sanitization des events.
abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object?>? params});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty(String name, String? value);
  Future<void> setCollectionEnabled(bool enabled);

  /// Crée un **nouvel** observer à attacher à un `Navigator` (GoRouter racine
  /// ou `ShellRoute`).
  ///
  /// Une instance de `NavigatorObserver` ne peut être attachée qu'à **un
  /// seul** `Navigator` à la fois — l'assertion `observer._navigator == null`
  /// dans `NavigatorState.initState` saute sinon. Appeler cette factory à
  /// chaque emplacement où l'on veut tracker les `screen_view` (typiquement :
  /// le root GoRouter ET chaque ShellRoute).
  ///
  /// Retourne un `NavigatorObserver` (parent de `FirebaseAnalyticsObserver`)
  /// pour que `NoopAnalyticsService` puisse renvoyer un observer inerte si
  /// Firebase n'a pas pu s'initialiser.
  NavigatorObserver createObserver();
}

/// Implémentation Firebase. Sanitization défensive + try/catch silencieux :
/// un échec d'envoi ne doit jamais remonter à l'appelant.
class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  // Limites Firebase Analytics (cf. docs officielles) :
  static const _maxEventNameLength = 40;
  static const _maxParamNameLength = 40;
  static const _maxParamStringValueLength = 100;
  static const _maxUserPropertyValueLength = 36;

  // Le defaultNameExtractor retourne settings.name. Si null (modaux/sheets
  // sans RouteSettings.name explicite), aucun screen_view n'est envoyé —
  // c'est le comportement souhaité pour éviter les screen_name parasites.
  //
  // Factory : un NavigatorObserver ne peut être attaché qu'à UN Navigator à
  // la fois (cf. assertion dans NavigatorState.initState). On crée donc une
  // nouvelle instance à chaque appel — root GoRouter et ShellRoute reçoivent
  // chacun la leur.
  @override
  NavigatorObserver createObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Future<void> logEvent(String name, {Map<String, Object?>? params}) async {
    _warn('log event $name to analytics');
    if (name.length > _maxEventNameLength) {
      _warn('event name "$name" exceeds $_maxEventNameLength chars — dropped');
      return;
    }
    try {
      await _analytics.logEvent(
        name: name,
        parameters: _sanitizeParams(params),
      );
    } catch (e) {
      _warn('logEvent($name) failed: $e');
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
    } catch (e) {
      _warn('setUserId failed: $e');
    }
  }

  @override
  Future<void> setUserProperty(String name, String? value) async {
    final truncated = value != null && value.length > _maxUserPropertyValueLength
        ? value.substring(0, _maxUserPropertyValueLength)
        : value;
    try {
      await _analytics.setUserProperty(name: name, value: truncated);
    } catch (e) {
      _warn('setUserProperty($name) failed: $e');
    }
  }

  @override
  Future<void> setCollectionEnabled(bool enabled) async {
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
    } catch (e) {
      _warn('setCollectionEnabled($enabled) failed: $e');
    }
  }

  /// Convertit les valeurs non supportées (DateTime, enum, bool) en chaînes
  /// ou nombres acceptés par Firebase. Drop les params dont le nom dépasse la
  /// limite ou dont la valeur est `null`. Tronque les chaînes trop longues.
  Map<String, Object>? _sanitizeParams(Map<String, Object?>? params) {
    if (params == null || params.isEmpty) return null;
    final out = <String, Object>{};
    for (final entry in params.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key.length > _maxParamNameLength) {
        _warn('param name "$key" exceeds $_maxParamNameLength chars — dropped');
        continue;
      }
      if (value == null) continue;
      final converted = _convertValue(value);
      if (converted == null) continue;
      out[key] = converted;
    }
    return out.isEmpty ? null : out;
  }

  Object? _convertValue(Object value) {
    if (value is num) return value;
    if (value is String) {
      return value.length > _maxParamStringValueLength
          ? value.substring(0, _maxParamStringValueLength)
          : value;
    }
    if (value is bool) return value.toString();
    if (value is DateTime) return value.toIso8601String();
    if (value is Enum) return value.name;
    final str = value.toString();
    return str.length > _maxParamStringValueLength
        ? str.substring(0, _maxParamStringValueLength)
        : str;
  }

  void _warn(String message) {
    if (kDebugMode) debugPrint('[Analytics] $message');
  }
}
