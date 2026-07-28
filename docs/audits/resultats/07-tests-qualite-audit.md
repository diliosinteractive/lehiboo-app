# Audit — Axe 07 Tests & qualité

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude · Plan : [07-tests-qualite.md](../plans/07-tests-qualite.md)

## Synthèse
- **État global : 🔴 Critique** — non seulement **12 fichiers de test pour 593 fichiers source** (~2 %), 0 golden, aucun `integration_test/`, aucun framework de mock, mais surtout **la suite de tests ne s'exécute pas** dans l'environnement courant (échec de compilation lié au SDK Flutter — voir P0-2). Les chemins critiques (paiement réel `order_cart`, auth, refresh token, realtime) ne sont **pas testés**.
- Constats : **2 🔴 P0 · 3 🟠 P1 · 2 🟡 P2**
- **Top 3 actions** :
  1. **Réparer/épingler le toolchain Flutter** pour que `flutter test` compile (préalable à tout le reste).
  2. Couvrir le **flow de paiement réel** (`order_cart_screen`/`checkout_screen` + `api_booking_repository_impl`) — aujourd'hui non testé alors qu'il manipule de l'argent.
  3. Mettre en place l'outillage : `mocktail`, `integration_test`, seuil de couverture en CI.

---

## 1. Baseline mesurée

| Métrique | Valeur |
|----------|-------:|
| Fichiers de test (`*_test.dart`) | **12** |
| Lignes de code de test | **977** |
| Fichiers source (`lib`, hors générés) | **593** |
| Ratio fichiers testés (approx.) | **~2 %** |
| Tests `testWidgets` | 3 |
| Tests `test()` unitaires | 9 |
| Golden tests | **0** |
| `integration_test/` | **absent** |
| Framework de mock | **aucun** (fakes manuels) |
| Couverture lignes (lcov) | **non mesurable** — `flutter test` ne compile pas (voir P0-2) |
| Toolchain | PATH `flutter 3.32.5` (Dart 3.8.1) ; tests compilés contre **fvm 3.35.7 incohérent** ; pas de `.fvmrc` |

### Tests existants (les 12)
| Fichier | Type | Cible |
|---------|------|-------|
| `test/widget_test.dart` | widget | smoke (probablement template) |
| `test/core/deeplinks/deeplink_router_test.dart` | unit | routage deeplink ✅ |
| `test/core/l10n/app_locale_test.dart` | unit | locale |
| `test/data/repositories/fake_repository_test.dart` | unit | fake repo |
| `test/features/booking/booking_flow_test.dart` | unit | flow booking **legacy** |
| `test/features/booking/cart_summary_section_test.dart` | widget | résumé panier ✅ |
| `test/features/booking/participant_form_card_test.dart` | widget | formulaire participant ✅ |
| `test/features/events/data/mappers/event_mapper_test.dart` | unit | mapper events (règle UUID) ✅ |
| `test/features/memberships/personalized_feed_dedup_test.dart` | unit | dédup feed |
| `test/features/search/widgets/active_filter_chips_provider_test.dart` | unit | filtres |
| `test/features/search/widgets/category_cascade_test.dart` | unit | cascade catégories |
| `test/mappers/activity_mapper_test.dart` | unit | mapper activity legacy |

---

## 2. Constats détaillés

### 🔴 P0
| # | Constat | Recommandation | Effort |
|---|---------|----------------|--------|
| P0-1 | **Chemins critiques non testés.** Le flow de **paiement réel** (`order_cart_screen._submitOrder`, `api_booking_repository_impl`, `confirmOrder`, compensation d'annulation) n'a aucun test. Le `booking_flow_test` existant cible le flow **legacy simulé** (`pi_fake_12345`, code mort — cf. [audit 14](14-paiement-realtime-push-audit.md)). On teste donc le mauvais flow. Idem : intercepteur **401/refresh token**, **realtime**, **SSE**. | Écrire des tests sur le repo de booking réel (création/confirm/annulation avec fakes), la logique de compensation, et l'intercepteur JWT (refresh, force-logout). | L |
| P0-2 | **La suite de tests ne compile pas.** `flutter test --coverage` échoue sur des erreurs **dans le SDK Flutter lui-même** (`fvm 3.35.7` : `SemanticsFlags` / `SemanticsRole.main/navigation/region/searchBox` introuvables dans `dart:ui` → framework/engine désynchronisés). Le `flutter` du PATH est **3.32.5** (Dart 3.8.1), et **aucun `.fvmrc`** n'épingle la version → ambiguïté de toolchain. Les 12 tests échouent à la **compilation** (`+0 -12`), pas en logique. _Peut être spécifique à cette machine, mais bloque tout test/CI tant que non résolu._ | Réparer l'install fvm 3.35.7 (`fvm install --force`) **ou** aligner sur 3.32.5 ; **committer un `.fvmrc`** pinné ; documenter la version requise. | S-M |

### 🟠 P1
| # | Constat | Recommandation | Effort |
|---|---------|----------------|--------|
| P1-1 | **Aucun framework de mock** → impossible de mocker Dio/datasources proprement ; tests limités aux fakes manuels. Aggravé par les violations de couches (presentation appelle la datasource directement, cf. [audit 01](01-architecture-structure-audit.md) P1-1). | Ajouter `mocktail` en dev_dependency ; injecter les repos via providers overridables. | S |
| P1-2 | **Aucun test d'intégration** (`integration_test/` absent) → aucun parcours bout-en-bout vérifié (login → recherche → réservation → billet). | Ajouter `integration_test` + au moins le parcours réservation gratuite et payante (Stripe test mode). | M |
| P1-3 | **Pas de seuil de couverture ni de tests en CI** (CI absente, cf. [plan 13](../plans/13-ci-cd-release.md)) → rien n'empêche la régression. | `flutter test --coverage` en CI + seuil minimal (p.ex. 30 % puis progressif). | M |

### 🟡 P2
| # | Constat | Recommandation |
|---|---------|----------------|
| P2-1 | **0 golden test** alors que l'app est très UI (cartes events, stories, tool cards Petit Boo, timeline trip_plan). Régressions visuelles non détectées. | Golden tests sur les widgets clés (EventCard, tool cards, BookingSummary). |
| P2-2 | Le `booking_flow_test` teste un **flow mort** → faux sentiment de sécurité. | Re-cibler sur le flow réel après suppression du legacy. |

---

## 3. Backlog de tests priorisé (P0 d'abord)
1. **Booking réel** : `api_booking_repository_impl` (create/confirm/cancel), compensation `_cancelActiveOrderIfNeeded`, polling billets.
2. **Réseau** : `JwtAuthInterceptor` (injection token, 401→refresh→retry, force-logout), `ApiResponseHandler` (5 formats), `JsonRetryInterceptor`.
3. **Mappers UUID** : booking/ticket (règle CLAUDE.md), déjà fait pour events ✅.
4. **State** : controllers critiques (aligné sur [audit 03](03-state-management-riverpod-audit.md)).
5. **Parcours intégration** : réservation gratuite + payante (Stripe test).
6. **Golden** : widgets UI à fort trafic.

## Points conformes (✅)
- Tests pertinents existants : `event_mapper_test` (couvre la règle UUID), `deeplink_router_test` (whitelist hosts), widgets booking (cart summary, participant form).
- Usage de fakes (`FakeBookingRepository`, `FakeActivityRepository`) → architecture testable côté repository (quand elle est respectée).

## Annexes
- Comptages : `find test -name '*_test.dart'` (12), `find lib ! -name '*.g.dart' ! -name '*.freezed.dart'` (593).
- Couverture : `flutter test --coverage` (lcov) — voir [J2-consolidation](J2-consolidation-vague2.md) pour le % mesuré.
