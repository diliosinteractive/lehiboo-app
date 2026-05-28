# Synthèse exécutive — Audit complet Le Hiboo (mobile)

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude
Périmètre : **14 axes transverses + 23 features** · ~593 fichiers source, ~257k lignes, Flutter/Dart + Riverpod + Clean Architecture.

> Document de clôture. Détails par axe dans [resultats/](.) ; pilotage dans [PLAN-EXECUTION.md](../plans/PLAN-EXECUTION.md) ; consolidations de vagues : [J1](J1-consolidation-vague1.md) · [J2](J2-consolidation-vague2.md) · [J3](J3-consolidation-vague3.md).

---

## 1. Verdict global

L'application est **fonctionnellement riche et bien architecturée dans ses fondations** (Clean Architecture, Riverpod maîtrisé, résilience réseau, i18n quasi-complète, deeplinks et permissions natives exemplaires, RGPD conforme). Mais elle porte des **risques bloquants pour une mise en production sereine**, concentrés sur **3 thèmes** :

1. **Sécurité des secrets** (exposition historique + binaire) — 🔴 le plus urgent.
2. **Fiabilité du paiement & filet de sécurité** (code de paiement simulé encore routé, flow réel non testé, tests qui ne compilent pas, aucune CI de validation).
3. **Dette de maintenabilité & observabilité** (god widgets, lint sous-exploité, logging non discipliné, erreurs avalées).

**Bilan chiffré** : **~5 P0** et **~61 P1** sur l'ensemble. Aucune feature n'est critique *isolément* — les risques majeurs sont **transverses** ou concentrés sur **booking**.

| Axe | État | Axe | État |
|-----|:----:|-----|:----:|
| 05 Sécurité | 🔴 Critique | 02 Qualité code | 🟠 Majeur |
| 07 Tests | 🔴 Critique | 06 Performance | 🟠 Majeur |
| 14 Paiement/RT/Push | 🟠 Majeur | 09 UI/UX-a11y | 🟠 Majeur |
| 04 Réseau/API | 🟠 Majeur | 13 CI/CD | 🟠 Majeur |
| 01 Architecture | 🟠 Majeur | 12 Plateforme | 🟢 Bon |
| 03 State/Riverpod | 🟠 Majeur | 10 i18n | 🟢 Bon |
| 11 Observabilité | 🟠 Majeur | 08 Deps/Build | 🟠 Majeur |

---

## 2. Top 10 des risques

| # | Risque | Gravité | Axe |
|---|--------|:-------:|-----|
| 1 | **Secrets exposés** dans l'historique git (du first commit à `e1ac79a`) + **bundlés dans le binaire** (HT_PASSWORD, API_KEY, GOOGLE_MAPS_API_KEY, PUSHER_APP_KEY). | 🔴 | 05 |
| 2 | **Écran de paiement simulé** (`pi_fake_12345`) encore routé → réservations confirmées **non payées** si atteint. | 🔴 | 14 |
| 3 | **`flutter test` ne compile pas** (toolchain : fvm 3.35.7 cassé, pas de `.fvmrc`) → **aucun test, aucune CI possible**. | 🔴 | 07 |
| 4 | **Flow de paiement réel non testé** + messages d'erreur `[DEBUG]` Stripe affichés aux utilisateurs en prod. | 🔴/🟠 | 07/14 |
| 5 | **Aucune CI de validation** (analyze/test/build) sur PR → régressions libres. | 🟠 | 13 |
| 6 | **Observabilité trouée** : CrashReporter dans 1 fichier, userId Crashlytics jamais posé, 36-82 `catch(_){}` vides, refresh token silencieux. | 🟠 | 11 |
| 7 | **Accessibilité très faible** : 8 `Semantics` pour 346 cliquables, aucune gestion du text scaling. | 🟠 | 09 |
| 8 | **Jank** : `setState` plein écran au scroll (home + détail), 56 images non dimensionnées, markers carte reconstruits. | 🟠 | 06 |
| 9 | **Dette de maintenabilité** : 3 god widgets > 2000 l., 1171 issues `analyze`, lint obsolète + `riverpod_lint` non activé. | 🟠 | 02 |
| 10 | **Fuite de DTO en presentation** (~10 features) + couche legacy `Activity`/`lib/data` non dépréciée + signing release → clé debug. | 🟠 | 01/08 |

---

## 3. Consolidé P0 (action immédiate)

| ID | Problème | Lot | Réf. |
|----|----------|-----|------|
| **P0-1** | Secrets dans l'historique git → **roter** + réécrire l'historique (`git filter-repo`). | Sécurité | [05](05-securite-audit.md) |
| **P0-2** | Secrets serveur embarqués dans le binaire → sortir du bundle + obfuscation. | Sécurité | [05](05-securite-audit.md) |
| **P0-3** | Paiement simulé routé → supprimer le flow legacy / dé-router. | Paiement | [14](14-paiement-realtime-push-audit.md) |
| **P0-4** | `flutter test` ne compile pas → `.fvmrc`=3.38.7 + réparer SDK. | Tests/CI | [07](07-tests-qualite-audit.md) |
| **P0-5** | Flow de paiement réel non testé → tests `api_booking_repository_impl` + intercepteur JWT. | Tests/CI | [07](07-tests-qualite-audit.md) |

---

## 4. Dette par thème (61 P1 regroupés)

| Thème | Constats clés | Axes |
|-------|---------------|------|
| **Sécurité/conformité** | PII (email) loggée ; PrivacyInfo.xcprivacy absent ; sur-permission « Always » location ; obfuscation off. | 05, 12, 08 |
| **Paiement/réservation** | messages debug en prod ; pas de garde de ré-entrée ; polling billets à confirmer ; double DTO booking ; `getBookingById(int)`. | 14, 04 |
| **Robustesse réseau** | pas de `Failure` unifié ; datasources sans try/catch ; `sendTimeout` absent ; Dio Petit Boo sans intercepteurs ; pas de CancelToken typeahead. | 04 |
| **Observabilité** | CrashReporter sous-utilisé ; userId Crashlytics ; ~405 `debugPrint` ; 36-82 `catch(_){}` ; refresh silencieux ; `ANALYTICS_ENABLED` ignoré. | 11, 02 |
| **Architecture/dette** | DTO en presentation (~10 features) ; couche legacy `Activity` ; `EventToActivityMapper` × 8 ; provider dans impl (messages) ; singleton `HibonsService`. | 01, 03 |
| **State/perf** | `LeHibooApp.build()` surchargé ; `autoDispose` manquants ; `.value!` non sûrs ; `setState` au scroll ; images non dimensionnées ; markers carte. | 03, 06 |
| **Qualité/livraison** | 1171 issues lint ; lint obsolète + `riverpod_lint` off ; 3 god widgets > 2000 l. ; pas de CI PR ; pas de CI Android ; 3 versions Flutter. | 02, 13, 08 |
| **UX/a11y** | sémantique absente ; text scaling ; tap targets < 48 ; contraste ; `PopScope` paiement ; boutons bruts ; états d'erreur silencieux. | 09 |
| **i18n** | formatage prix non localisé ; 3 dates hardcodées ; 1 widget FR en dur. | 10 |

---

## 5. Roadmap de remédiation (par lot)

| Lot | Contenu | P0/P1 | Effort indicatif |
|-----|---------|-------|------------------|
| **1. Sécurité (urgent)** | Rotation secrets → réécriture historique → sortir secrets du bundle → obfuscation → gater PII logs. | P0-1, P0-2 + sécu | M-L |
| **2. Stabilité paiement** | Supprimer flow simulé → restaurer messages d'erreur → garde ré-entrée → vérifier polling billets. | P0-3 + 14 | M |
| **3. Toolchain & CI** | `.fvmrc`=3.38.7 + réparer SDK → CI PR (analyze+test+build) → CI Android signée → scan OSV. | P0-4 + 13 | M |
| **4. Tests critiques** | Booking réel + intercepteur 401/refresh + mappers UUID ; `mocktail` + `integration_test`. | P0-5 + 07 | L |
| **5. Observabilité** | `setUserIdentifier` ; non-fatals (refresh/paiement/realtime) ; traiter `catch` vides ; `AppLogger` central. | 11 | M |
| **6. Dette archi/state** | Entities+mappers manquants ; providers repo en domain ; déprécier `lib/data` ; `AppInitializer` ; `autoDispose`. | 01, 03 | L (continu) |
| **7. Performance** | AppBar hors scroll ; `memCacheWidth` ; mémo markers ; `const`/RepaintBoundary. | 06 | M |
| **8. Qualité/lint** | Lint moderne + `custom_lint` ; résorber 1171 issues ; découper god widgets. | 02 | L (continu) |
| **9. UX/a11y** | Semantics/tooltip ; text scaling ; tap targets ; contraste ; `PopScope` paiement. | 09 | L |
| **10. Store-readiness** | `PrivacyInfo.xcprivacy` ; réduire permissions iOS ; aligner versions ; formatage prix i18n. | 12, 10 | M |

**Séquence conseillée** : Lots **1→2→3→4** d'abord (sécurité + paiement + débloquer les tests/CI = base de confiance), puis 5-10 en continu.

---

## 6. Quick wins (effort S, impact élevé)

`.fvmrc`=3.38.7 · restaurer messages d'erreur prod (retirer `[DEBUG]`) · gater les logs email · `setUserIdentifier` Crashlytics · non-fatal sur refresh token · `sendTimeout` (×3) · `if (_isLoading) return;` checkout · sécuriser les `.value!` (4 sites) · `authProvider.select((s)=>s.user)` · activer `custom_lint`/`riverpod_lint` + `avoid_print` · retirer permission iOS « Always » · `PopScope` paiement · tap targets favori ≥ 48 · supprimer `build_log.txt`/`backend_request_email.txt` · localiser `conversation_load_error_view`.

---

## 7. Baseline de référence (à re-mesurer aux prochains audits)

> Premier audit → ces chiffres **établissent la baseline**. À comparer lors des prochaines passes pour mesurer la résorption de la dette.

| Métrique | Baseline 2026-05-28 | Cible |
|----------|--------------------:|-------|
| Couverture de tests | **non mesurable** (compile KO) ; 12 fichiers / 593 (~2 %) | compile + ≥ 30 % puis progressif |
| `flutter analyze` | **1171** issues (exit 0) | 0 (avec `--fatal-warnings`) |
| `debugPrint` non gardés | **~405** | 0 (via `AppLogger`) |
| `catch(_){}` vides → quasi-vides | **36 → 82** | 0 non instrumentés |
| `CrashReporter.recordError` | **2** (1 fichier) | hot paths couverts |
| `Semantics` / éléments cliquables | **8 / 346** | labels sur tous les boutons icônes |
| Images sans `memCacheWidth` | **56 / 56** | 0 |
| God files > 2000 / > 800 lignes | **3 / ≥7** | 0 / réduit |
| Deps directes ≥ 1 majeure de retard | **~30** | à jour (sécu d'abord) |
| Versions Flutter divergentes | **3** | 1 (`.fvmrc`=3.38.7) |
| Clés i18n (parité fr/en) | **2052 / 2052** ✅ | maintenir |
| Secrets exposés (git + binaire) | **oui** | 0 (rotés + retirés) |
| CI de validation PR | **absente** | analyze+test+build verts |

---

## 8. Points forts à préserver

- **i18n** quasi-complète (2052 clés, parité parfaite, `Accept-Language` dynamique).
- **Plateforme native** : ATS sécurisé, cleartext cantonné au debug, permissions minimales, **Universal Links/App Links** impeccables.
- **Sécurité du stockage** : tokens chiffrés (Keychain/EncryptedSharedPreferences), `clearAuthData()` complet, deeplinks whitelistés.
- **Résilience réseau** : `ApiResponseHandler`, refresh token via Dio séparé, retry JSON.
- **Paiement réel** : compensation transactionnelle, contexte Crashlytics par étape.
- **RGPD** : consent gate conforme CNIL, opt-in strict.
- **Riverpod** : dispose propre sur toutes les ressources actives (WebSocket/timers/SSE).

---

*Audit réalisé en 4 vagues (J1-J4). 14 rapports d'axes + fiches feature + 4 consolidations disponibles dans [docs/audits/resultats/](.).*
