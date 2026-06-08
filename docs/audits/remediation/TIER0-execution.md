# Plan d'exécution — Remédiation Tier 0 (risque de régression quasi nul)

Date : 2026-05-28 · Branche cible : `fix/audit-tier0` · Source : [SYNTHESE-EXECUTIVE.md](../resultats/SYNTHESE-EXECUTIVE.md) §6 (quick wins)

> **Périmètre** : uniquement les updates **additifs / défensifs / tooling** dont le happy path utilisateur est inchangé. Aucun changement de comportement nominal. 7 tâches, ~½ journée.
> **Hors périmètre** (à traiter séparément) : rotation secrets, réécriture historique, switch d'env, minify/obfuscation, montées de versions, suppression du flow legacy.

---

## 0. Principe & contraintes de validation

⚠️ **Pas de filet de sécurité automatisé** : `flutter test` ne compile pas et il n'y a aucune CI ([07](../resultats/07-tests-qualite-audit.md), [13](../resultats/13-ci-cd-release-audit.md)). De plus **`flutter analyze`/`flutter pub get` sont cassés** dans cet environnement (réclament le SDK 3.44.0). La validation se fait donc par :
1. **`dart analyze`** après chaque tâche → le nombre d'issues ne doit **pas augmenter** (et doit baisser pour T3/T4). *(Ne pas utiliser `flutter analyze` — cassé ; cf. Tier 1 pour la réparation du toolchain.)*
2. **Smoke manuel** ciblé par tâche (cf. colonne « Validation »).
3. **`flutter run` (debug)** une fois à la fin, sur le golden path : démarrage → login → home → ouvrir un event → ouvrir une conversation.

**Règle** : 1 tâche = 1 commit atomique (rollback facile). Commits sans `Co-Authored-By` (cf. CLAUDE.md).

---

## 1. Tâches

### T1 — Dé-tracker les artefacts committés
- **Constat** : [08](../resultats/08-dependances-build-config-audit.md) P2-3. `build_log.txt` (3,8 Mo) et `backend_request_email.txt` **sont trackés** par git, absents du `.gitignore`.
- **Action** :
  ```bash
  git rm --cached build_log.txt backend_request_email.txt
  ```
  Puis ajouter au `.gitignore` :
  ```
  /build_log.txt
  /backend_request_email.txt
  *.log
  ```
- **Risque résiduel** : nul (aucun code touché ; les fichiers restent sur disque localement).
- **Validation** : `git status` montre les fichiers en « deleted (cached) » + ignorés. Build inchangé.
- **Effort** : 2 min.

### T2 — Gater les `debugPrint` exposant des PII (email)
- **Constat** : [05](../resultats/05-securite-audit.md) #3. `debugPrint` non gardés loguant l'email utilisateur (s'exécutent en release).
- **Fichiers (vérifiés)** :
  - [register_screen.dart:65](../../../lib/features/auth/presentation/screens/register_screen.dart#L65) — `'📱 Result email: ${result?.email}'`
  - [business_register_provider.dart:707](../../../lib/features/auth/presentation/providers/business_register_provider.dart#L707) — `'📱 User authenticated: ${...user.email}'`
- **Action** : **supprimer** ces deux lignes (debug oublié, aucune valeur). Vérifier aussi le payload device-token ([push_notification_provider.dart:279](../../../lib/features/notifications/presentation/providers/push_notification_provider.dart#L279)) → gater par `if (kDebugMode)` ou retirer l'email/identifiants du message.
- **Risque résiduel** : nul (retrait de logs).
- **Validation** : `flutter analyze` OK ; flux register/login fonctionne.
- **Effort** : 10 min.

### T3 — Hisser les `RegExp` en `static final`
- **Constat** : [06](../resultats/06-performance-audit.md) P2-7/P2-8. RegExp recréées à chaque frappe / rebuild.
- **Fichiers (vérifiés)** :
  - [password_strength_indicator.dart:115-143,223-225](../../../lib/features/auth/presentation/widgets/password_strength_indicator.dart#L115-L143) — patterns `[a-z]`, `[A-Z]`, `[0-9]`, `[!@#$%^&*(),.?":{}|<>]` (répétés).
  - [event_detail_screen.dart:1482](../../../lib/features/events/presentation/screens/event_detail_screen.dart#L1482) — `_looksLikeUuid`.
- **Action** : déclarer les patterns en `static final RegExp _xxx = RegExp(...)` au niveau de la classe/State et remplacer les `RegExp(...)` inline par ces champs. **Comportement strictement identique.**
- **Risque résiduel** : nul (mêmes regex, juste mémoïsées).
- **Validation** : `flutter analyze` OK ; champ mot de passe → l'indicateur de force réagit comme avant à la frappe.
- **Effort** : 20 min.

### T4 — Privatiser les classes `State` publiques
- **Constat** : [02](../resultats/02-qualite-code-conventions-audit.md) Q18. Convention Dart : les `State` doivent être privées.
- **Fichiers (vérifiés, aucune référence externe → 0 `GlobalKey<...State>`)** :
  - [pulse_animation.dart:33](../../../lib/shared/widgets/animations/pulse_animation.dart#L33) — `PulseAnimationState` → `_PulseAnimationState`
  - [spring_button.dart:221](../../../lib/shared/widgets/animations/spring_button.dart#L221) — `ShakeWidgetState` → `_ShakeWidgetState`
- **Action** : renommer la classe + le type de retour de `createState()` (`replace_all` dans chaque fichier).
- **Risque résiduel** : nul (vérifié : pas d'usage externe).
- **Validation** : `flutter analyze` OK (1 issue de moins) ; animations pulse/shake (ex. shake du bouton favori) toujours jouées.
- **Effort** : 5 min.

### T5 — Poser le `userId` Crashlytics
- **Constat** : [11](../resultats/11-observabilite-crash-analytics-audit.md) P1-1. Corrélation crash↔user impossible.
- **Emplacement (vérifié)** : `_syncAuthUser(HbUser? user)` — [auth_provider.dart:563-566](../../../lib/features/auth/presentation/providers/auth_provider.dart#L563-L566). `setUserId(user.id)` y est déjà posé ; ajouter l'équivalent Crashlytics au même endroit (user → id, null → vide).
- **Action recommandée** : ajouter une méthode best-effort dans `CrashReporter` (qui respecte déjà la garde `enableCrashlytics`) :
  ```dart
  // crash_reporter.dart
  static Future<void> setUserId(String? id) async {
    try { await FirebaseCrashlytics.instance.setUserIdentifier(id ?? ''); } catch (_) {}
  }
  ```
  puis dans `_syncAuthUser` : `CrashReporter.setUserId(user?.id);`
- **Risque résiduel** : très faible (additif, try/catch). Vérifier que `CrashReporter` est bien gardé par le flag en debug/dev pour ne pas activer Crashlytics hors prod.
- **Validation** : `flutter analyze` OK ; login/logout fonctionne ; (optionnel) le user apparaît dans Crashlytics.
- **Effort** : 15 min.

### T6 — Remonter l'échec de refresh token en non-fatal
- **Constat** : [11](../resultats/11-observabilite-crash-analytics-audit.md) P1-4. Déconnexion silencieuse, invisible en prod.
- **Emplacements** : [dio_client.dart:305-309](../../../lib/config/dio_client.dart#L305-L309) (interceptor) et [auth_repository_impl.dart:170-172](../../../lib/features/auth/data/repositories/auth_repository_impl.dart#L170-L172) (`refreshTokenIfNeeded`).
- **Action** : dans ces `catch`, ajouter `CrashReporter.recordError(e, st, reason: 'token_refresh_failed')` **sans changer le flux** (on garde le `return false` / le force-logout existant). Scope Tier 0 = **uniquement le refresh token** (les 36 autres `catch(_){}` sont un lot séparé).
- **Risque résiduel** : très faible (additif, best-effort).
- **Validation** : `flutter analyze` OK ; comportement de déconnexion sur 401 inchangé.
- **Effort** : 15 min.

### T7 — Localiser `conversation_load_error_view` ⚠️ (nécessite l10n codegen)
- **Constat** : [10](../resultats/10-internationalisation-audit.md) P1-2. 3 chaînes FR en dur dans un widget actif ([conversation_load_error_view.dart:21-30](../../../lib/features/messages/presentation/widgets/conversation_load_error_view.dart#L21-L30)).
- ⚠️ **Correction vs audit** : les clés « titre » n'existent **pas** (seuls `commonConnectionError`, `commonGenericRetryError`, `messagesLoadError` existent). Il faut **ajouter 4 clés** dans `lib/l10n/app_fr.arb` **et** `app_en.arb` :
  - `messagesNoInternetTitle` : « Aucune connexion internet » / « No internet connection »
  - `messagesLoadErrorTitle` : « Impossible de charger la conversation » / « Couldn't load the conversation »
  - `commonCheckConnectionRetry` : « Vérifiez votre connexion puis réessayez. » / « Check your connection and try again. »
  - (réutiliser `messagesLoadError`/`extractError` pour le message non-réseau)
- **Action** : éditer les 2 ARB → `flutter gen-l10n` → remplacer les littéraux par `context.l10n.xxx`.
- **Dépendance toolchain** : `flutter gen-l10n` doit fonctionner (OK avec le PATH 3.32.5 ; sinon **différer cette tâche** après réparation du toolchain).
- **Risque résiduel** : faible (ne change qu'un texte d'erreur ; vérifier la parité des 2 ARB pour ne pas casser la génération).
- **Validation** : `flutter gen-l10n` sans erreur ; ouvrir une conversation hors réseau en EN et FR → textes corrects.
- **Effort** : 30 min.

---

## 2. Séquencement & commits

| Ordre | Tâche | Commit suggéré | Validation |
|:-----:|-------|----------------|:----------:|
| 1 | T1 | `chore: stop tracking build artifacts` | git status |
| 2 | T4 | `refactor: privatize State classes (lint)` | dart analyze |
| 3 | T3 | `perf: hoist RegExp to static final` | dart analyze |
| 4 | T2 | `chore: remove PII from debug logs` | dart analyze |
| 5 | T5 | `feat(observability): set Crashlytics userId` | dart analyze |
| 6 | T6 | `feat(observability): report token refresh failures` | dart analyze |
| 7 | T7 | `i18n: localize conversation load error view` | gen-l10n |

> T1-T6 ne nécessitent que `dart analyze`. **T7 est isolée en dernier** car elle dépend de la génération l10n — peut être différée sans bloquer les autres.

---

## 3. Validation globale (fin de lot)

1. `dart analyze` → le total d'issues a **baissé** (T3/T4) et n'a **pas augmenté** ailleurs (baseline : 1171, cf. [02](../resultats/02-qualite-code-conventions-audit.md)).
2. `flutter run` (debug) → golden path : démarrage → **login/logout** (T2/T5/T6) → home → **champ mot de passe à l'inscription** (T3) → **bouton favori / animation shake** (T4) → **ouvrir une conversation, simuler une erreur réseau** (T7).
3. `git log --oneline` → 7 commits atomiques.

## 4. Rollback
Chaque tâche étant un commit isolé, un `git revert <sha>` annule une tâche sans impacter les autres. Aucune migration de données ni changement de schéma → rollback trivial.

## 5. Definition of Done
- [ ] T1-T6 mergés, `flutter analyze` ≤ baseline (idéalement < 1171).
- [ ] T7 mergé **ou** explicitement différé (si gen-l10n indisponible) avec un ticket.
- [ ] Golden path validé manuellement en debug (aucune régression visible).
- [ ] Aucun secret/PII ajouté aux logs ; aucun changement de comportement nominal.

> **Prochain lot conseillé** après Tier 0 : **Tier 1** (`.fvmrc`=3.38.7 + réparation toolchain → débloque `flutter test`), qui transformera la validation manuelle ci-dessus en validation automatisée.
