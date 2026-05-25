import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Reporting centralisé des erreurs **non-fatales** vers Firebase Crashlytics.
///
/// Les crashs non gérés sont déjà capturés par les handlers globaux câblés dans
/// `main.dart` (`FlutterError.onError` / `PlatformDispatcher.onError`). Ce helper
/// sert aux erreurs qu'on **attrape** et gère proprement (on affiche un message
/// à l'utilisateur) mais sur lesquelles on veut quand même de la visibilité —
/// ex: un paiement qui échoue derrière « Une erreur est survenue ».
///
/// Chaque appel est best-effort : un échec du reporting (Firebase non
/// initialisé, collecte désactivée, …) est silencieusement avalé pour ne jamais
/// casser le flux utilisateur. En debug, l'erreur est aussi loggée en console.
class CrashReporter {
  CrashReporter._();

  /// Enregistre une erreur gérée (non-fatale) dans Crashlytics.
  ///
  /// [reason] est un libellé court affiché en tête de l'issue Crashlytics
  /// (ex: « Order checkout failed »). [context] est attaché comme informations
  /// de diagnostic (ex: `{'step': 'confirmOrder', 'order_uuid': uuid}`) ;
  /// les valeurs `null` sont ignorées.
  static Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
    Map<String, Object?> context = const {},
    bool fatal = false,
  }) async {
    if (kDebugMode) {
      debugPrint('🐛 CrashReporter: ${reason ?? 'error'} → $error');
    }

    try {
      final information = context.entries
          .where((entry) => entry.value != null)
          .map((entry) => '${entry.key}: ${entry.value}')
          .toList(growable: false);

      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: reason,
        information: information,
        fatal: fatal,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🐛 CrashReporter: échec du reporting → $e');
      }
    }
  }
}
