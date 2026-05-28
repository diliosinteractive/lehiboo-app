# Audit — Axe 02 Qualité du code & conventions

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude (+ agent exploration) · Plan : [02-qualite-code-conventions.md](../plans/02-qualite-code-conventions.md)

## Synthèse
- **État global : 🟠 Majeur** — conventions de base saines (nommage, Clean Archi, Freezed, go_router, `HbColors` adopté à 1385 endroits), mais forte **dette de maintenabilité** : **god widgets > 2000 lignes**, **lint sous-exploité** (`flutter analyze` = **1171 issues** non bloquantes, `flutter_lints` 3.0 obsolète, `riverpod_lint`/`custom_lint` **non activés**), logging non discipliné (**~405 `debugPrint`**), et du **code debug en prod** (déjà P0 en [V1](J1-consolidation-vague1.md)).
- Constats : **0 🔴 · 8 🟠 P1 · 17 🟡 P2 · 3 🟢 P3**
- **Top 3 actions** :
  1. Activer un lint moderne (`flutter_lints` 6 + `custom_lint`/`riverpod_lint` configurés + `avoid_print`) et résorber les 1171 issues par lots.
  2. Découper les 3 god widgets (filter_bottom_sheet 3134 l., new_conversation_form 2103 l., airbnb_search_sheet 2099 l.).
  3. Centraliser le logging (`AppLogger`) + supprimer le code debug/legacy (recoupe [V1](J1-consolidation-vague1.md)).

> Réconciliation : les 3 god files « P0 » de l'agent → **🟠 P1** (maintenabilité, pas un risque runtime). Le code debug `pi_fake_12345`/`RETIRER avant prod` est déjà traité en P0 [V1 (axe 14)](14-paiement-realtime-push-audit.md) → ici cross-référencé. Comptage `catch(_){}` : **36 strictement vides** ([audit 11](11-observabilite-crash-analytics-audit.md)) à **82 en incluant les quasi-vides** (cet axe).

---

## 1. Mesure lint (baseline)
- **`flutter analyze` (Flutter 3.32.5) = 1171 issues**, exit 0 (non bloquant). Dominantes : `deprecated_member_use` (`withOpacity` → `withValues` en masse), `invalid_annotation_target` (JsonKey/freezed), `curly_braces_in_flow_control_structures`, `prefer_const_constructors`.
- **`analysis_options.yaml` quasi vide** : `flutter_lints` 3.0 inclus, `avoid_print` commenté/désactivé, **aucune section `custom_lint:`** → `riverpod_lint` (en dev_deps) **n'est pas actif** (explique que les anti-patterns Riverpod de l'[audit 03](03-state-management-riverpod-audit.md) ne sont pas signalés).

## 2. God files (top)
| Fichier | Lignes | Note |
|---------|-------:|------|
| [filter_bottom_sheet.dart](../../../lib/features/search/presentation/widgets/filter_bottom_sheet.dart) | **3134** | 24 `build()` inline |
| [new_conversation_form.dart](../../../lib/features/messages/presentation/widgets/new_conversation_form.dart) | **2103** | 6 classes + sheets inline |
| [airbnb_search_sheet.dart](../../../lib/features/search/presentation/widgets/airbnb_search_sheet.dart) | **2099** | accordéons Où/Quand/Quoi inline |
| [event_detail_screen.dart](../../../lib/features/events/presentation/screens/event_detail_screen.dart) | **1633** | + 78 magic dims |
| [order_cart_screen.dart](../../../lib/features/booking/presentation/screens/order_cart_screen.dart) | **1255** | + code debug |
| [conversations_list_screen.dart](../../../lib/features/messages/presentation/screens/conversations_list_screen.dart) | **1140** | `ignore_for_file` |
| [app_router.dart](../../../lib/routes/app_router.dart) | **977** | router monolithique |
| [event_dto.dart](../../../lib/features/events/data/models/event_dto.dart) | **784** | ~50 champs |

---

## 3. Constats détaillés

### 🟠 P1 — Majeurs
| # | Constat | Fichier:ligne | Reco | Effort |
|---|---------|---------------|------|--------|
| Q1 | **3 god widgets > 2000 lignes** (filter_bottom_sheet, new_conversation_form, airbnb_search_sheet) → maintenance très coûteuse. | voir §2 | Découper en sous-widgets par fichier. | L |
| Q2 | **~405 `debugPrint` sans `kDebugMode`** (88 fichiers ; 1 seul gardé) → exécutés en release, exposent potentiellement des données métier ; package `logger` quasi inutilisé (35 occ.). | auth_api_datasource (13), gamification_api_datasource (20), petit_boo_chat_provider (15), push_notification_provider (17) | `AppLogger` central (filtre release). (Recoupe [11](11-observabilite-crash-analytics-audit.md).) | M |
| Q3 | **36–82 `catch(_){}` silencieux** → régressions invisibles. | auth_provider.dart:338-384 (5), api_booking_repository_impl.dart:137,141,291 | `catch (e, st) { logger.e(...) }`. (Recoupe [11](11-observabilite-crash-analytics-audit.md).) | M |
| Q4 | **`flutter_lints` 3.0 obsolète + `custom_lint`/`riverpod_lint` non configurés + `avoid_print` désactivé** → garde-fous manquants. | [analysis_options.yaml](../../../analysis_options.yaml), [pubspec.yaml:116](../../../pubspec.yaml#L116) | Passer à `flutter_lints` ^5/6, activer `custom_lint:` + règles Riverpod + `avoid_print`/`prefer_const_constructors`. | S |
| Q5 | **`FakeActivityRepositoryImpl` overridé dans la branche *real data*** : les composants legacy (`Activity`) sont servis par du fake même en prod. | [main.dart:288](../../../lib/main.dart#L288) | Migrer vers le repo Event réel / clarifier. | M |
| Q6 | **`_parseInt()` dupliqué byte-à-byte** (recoupe la duplication helpers de l'[audit 04](04-reseau-api-donnees-audit.md)). | favorite_list_dto.dart:113-118, favorites_api_datasource.dart:273-278 | Centraliser dans `core/utils`. | S |
| Q7 | **`EventToActivityMapper` : bridge dupliqué sur 8 sites** (coexistence Event/Activity legacy → double maintenance). | [event_to_activity_mapper.dart](../../../lib/features/events/data/mappers/event_to_activity_mapper.dart) | Migrer les widgets vers `Event`. | L |
| Q8 | **Code debug en prod** : `pi_fake_12345` + 2× `RETIRER avant prod`. | booking_payment_screen.dart:116, order_cart_screen.dart:1030,1060 | **Déjà P0 [V1](14-paiement-realtime-push-audit.md)** — supprimer flow legacy + restaurer messages. | S |

### 🟡 P2 — Dette modérée
| # | Constat | Fichier:ligne |
|---|---------|---------------|
| Q9 | **Stubs fonctionnels silencieux** : `similarEventsProvider` retourne toujours `[]` ; `_isAvailableForHome()` toujours `return true` (events complets/annulés peuvent s'afficher). | event_detail_screen.dart:98-103, home_providers.dart:267-272 |
| Q10 | **Dark mode factice** : `darkTheme = lightTheme` + `ThemeMode.light` forcé. | app_theme.dart:120, main.dart:360 |
| Q11 | **4258 dimensions/`EdgeInsets`/`BorderRadius` en dur** (215 fichiers) malgré `HbSpacing`/tokens. | projet |
| Q12 | **539 `Color(0xFF…)` + 581 `Colors.grey.shade*`** hors `HbColors` (≈100/89 fichiers) → bloque tout re-theming/dark. | projet |
| Q13 | **Pattern loading/error inline répété** dans ~63 fichiers (pas de helper `AsyncValue.when` partagé). | projet |
| Q14 | **Code commenté en prod** : sections home (207-224), onglet Partenaires v2 (conversations_list_screen 465-685), `Restaurer:` (order_cart 1032). | divers |
| Q15 | **`domain/models/` vs `domain/entities/`** incohérent (booking, search, onboarding, profile) ; **`controllers/` vs `providers/`** (booking). | voir [audit 01](01-architecture-structure-audit.md) |
| Q16 | **`_buildWebCTASection()` morte** (`// ignore: unused_element`) ; `checkout_screen` champs `_bookingResponse`/`_acceptNewsletter` inutilisés. | home_screen.dart:500, checkout_screen.dart:54-58 |
| Q17 | **`font_awesome_flutter` pour 1 seul usage** (~assets lourds) alors que `phosphor_flutter` est déjà présent. | organizer_social_link_row.dart |
| Q18 | **Classes `State` publiques non préfixées `_`** : `PulseAnimationState`, `ShakeWidgetState`. | pulse_animation.dart:33, spring_button.dart:221 |
| Q19 | **20 TODO/FIXME** dont des stubs (`onTap: () {} // TODO`, latitude hardcodée `// TODO: get from location provider`). | event_detail_screen.dart:524, gamification_dashboard_screen.dart:170 |

### 🟢 P3 — Mineurs
- `mock_gamification_repository.dart` non référencé (supprimable).
- `event_timing_bucket.dart` fonctions pédagogiques stub.
- 1 `print(` résiduel (spring_button).

---

## Points conformes (✅)
- **Nommage Dart respecté** (PascalCase/snake_case/camelCase) — pas de violation systématique.
- **Clean Architecture cohérente** dans la majorité des 23 features ; **Freezed/json_serializable** propres.
- **`HbColors` adopté** (1385 occ., 127 fichiers) — la dette est dans les ~540 couleurs raw restantes.
- **`// ignore` rares dans le code manuel** (~8-10 ; les milliers restants sont dans les fichiers générés, normaux).
- **State manager unique** (Riverpod, pas de mélange) ; **go_router** centralisé ; **l10n** massivement utilisé.

## Annexes
- Source : agent code-explorer (194 outils, ~943 s) + `flutter analyze` (1171 issues) mesuré par l'auditeur. Réconciliations de gravité appliquées (god files P0→P1, code debug renvoyé à V1, comptage catch 36–82).
