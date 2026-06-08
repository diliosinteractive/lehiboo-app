# Plan d'exécution — Remédiation Tier 4 (initiatives architecturales longues)

Date : 2026-05-28 · Format : **epics / chantiers continus** (pas des PR atomiques) · Pré-requis : [Tier 3](TIER3-execution.md) (CI + tests = filet indispensable pour ces refactors larges)

> **Périmètre** : chantiers **structurels** à fort effort et fort risque de régression diffuse, à mener **progressivement** sous couverture de tests/CI. Ce sont des **investissements** (dette long terme), pas des correctifs ponctuels. À planifier en epics avec jalons.
> ⚠️ **Ne pas démarrer sans le filet Tier 3** (CI + tests des chemins critiques) : ces refactors touchent des centaines de fichiers.

---

## Epic 4.A — Montées de versions majeures
- **Constats** : [08](../resultats/08-dependances-build-config-audit.md) P2-2 (~30 deps ≥ 1 majeure de retard).
- **Sous-chantiers (par ordre de priorité/risque)** :
  1. **Sécurité d'abord** : `firebase_*` 3→4/5, `flutter_secure_storage` 9→10, `flutter_stripe` 11→12. (migrations modérées, tester auth/paiement/crash).
  2. **Tooling** : `flutter_lints` 3→6, `build_runner`, `json_serializable`, `freezed` 2→3, `go_router_builder`. (régénérer le code, corriger les breaking changes de génération).
  3. **`flutter_riverpod` 2→3 + `riverpod_generator/annotation/lint`** : **migration la plus lourde** (API providers, codegen) → epic dédié.
  4. **`go_router` 14→17**, `flutter_map` 7→8, `file_picker` 8→11, `geolocator`/`geocoding`/`permission_handler`, `mobile_scanner` 6→7.
- **Risque** : **élevé** — breaking changes en cascade. Une dep à la fois, build + tests + smoke complet entre chaque.
- **Effort** : XL (étalé sur plusieurs sprints). **Dépend du Tier 3.H (tests).**

## Epic 4.B — Élimination de la couche legacy `Activity`
- **Constats** : [01](../resultats/01-architecture-structure-audit.md) P2-1, [02](../resultats/02-qualite-code-conventions-audit.md) Q5/Q7.
- **Sous-chantiers** :
  1. Déprécier `lib/data/` + `lib/domain/` racine (lint bloquant les nouveaux imports).
  2. Migrer les widgets dépendants d'`Activity` vers `Event` directement (home, search, favorites, map, event_list, personalized_feed…) → **supprimer `EventToActivityMapper`** (8 sites).
  3. Retirer `FakeActivityRepositoryImpl` des overrides « real data » une fois la migration faite.
- **Risque** : **élevé** — `Activity`/`Slot` sont très utilisés ; migration progressive feature par feature.
- **Effort** : XL.

## Epic 4.C — Stopper la fuite de DTO en presentation (entities + mappers manquants)
- **Constats** : [01](../resultats/01-architecture-structure-audit.md) P1-2/P1-3/P1-5/P1-7, [02](../resultats/02-qualite-code-conventions-audit.md).
- **Sous-chantiers** : créer entities + mappers pour `OrganizerProfile`, `Membership`, `Invitation`, `Thematique`, `BlogPost`, `EventAvailability`, `EventReferenceData`, `SearchSuggestions`, Hibons (gamification domain) ; déplacer `messagesRepositoryProvider` dans le domain ; exposer les appels via repository (booking, event availability, reminders) au lieu des datasources.
- **Risque** : **modéré-élevé** par feature — chaque migration touche provider + widgets.
- **Effort** : XL (par feature).

## Epic 4.D — Décomposition des god widgets
- **Constats** : [02](../resultats/02-qualite-code-conventions-audit.md) Q1, [06](../resultats/06-performance-audit.md).
- **Sous-chantiers** : découper `filter_bottom_sheet.dart` (3134 l.), `new_conversation_form.dart` (2103 l.), `airbnb_search_sheet.dart` (2099 l.), puis `event_detail_screen` (1633), `order_cart_screen` (1255), `conversations_list_screen` (1140), `app_router` (977 → routes par feature).
- **Risque** : **modéré** — refactor visuel à iso-comportement ; golden tests recommandés (Tier 2.D) pour détecter les régressions visuelles.
- **Effort** : L par fichier.

## Epic 4.E — `HibonsService` → Riverpod-aware
- **Constats** : [03](../resultats/03-state-management-riverpod-audit.md) P2-8, [01](../resultats/01-architecture-structure-audit.md) P2-7.
- **Sous-chantiers** : remplacer le singleton `HibonsService.instance` + `StreamController` non fermé par un `Provider`/Notifier Riverpod scoppé ; idem pour `DioClient.onForceLogout` (intercepteur Riverpod-aware).
- **Risque** : **modéré** — touche l'intercepteur Dio + l'animation Hibons ; tester les notifications de gain Hibons.
- **Effort** : L.

## Epic 4.F — Design system & theming
- **Constats** : [02](../resultats/02-qualite-code-conventions-audit.md) Q10/Q11/Q12, [09](../resultats/09-ui-ux-accessibilite-audit.md) P2-2.
- **Sous-chantiers** :
  1. Migrer les **539 `Color(0xFF…)`** + **581 `Colors.grey.shade*`** vers `HbColors` ; les **4258 dimensions en dur** vers `HbSpacing`/tokens.
  2. Migrer les **194+241 boutons bruts** vers `HbButton`.
  3. **Dark mode** réel (aujourd'hui `darkTheme = lightTheme`) — feature à part entière, **dépend** de la tokenisation des couleurs.
- **Risque** : **élevé en diffus** (changements visuels partout) — faire par écran, revue visuelle/golden.
- **Effort** : XL.

## Epic 4.G — Couverture de tests progressive
- **Constats** : [07](../resultats/07-tests-qualite-audit.md).
- **Sous-chantiers** : après les chemins critiques (Tier 3.H), monter la couverture par feature ; golden tests sur les widgets UI ; relever le seuil CI progressivement (30 % → …).
- **Risque** : nul (additif).
- **Effort** : continu.

---

## Principes d'exécution (epics)
- **Filet d'abord** : ne rien démarrer ici sans CI verte + tests des chemins critiques (Tier 3).
- **Une dep / une feature à la fois** : merges petits, validables, réversibles.
- **Golden tests** pour les refactors visuels (4.D, 4.F).
- **Jalons trimestriels** plutôt que dates fixes ; mesurer la dette résiduelle vs la **baseline** ([SYNTHESE-EXECUTIVE.md](../resultats/SYNTHESE-EXECUTIVE.md) §7) à chaque jalon.

## Definition of Done (par epic, pas global)
- [ ] 4.A : deps sécurité à jour ; Riverpod 3 migré.
- [ ] 4.B : `lib/data`/`lib/domain` legacy supprimés ; plus de `EventToActivityMapper`.
- [ ] 4.C : 0 DTO importé en presentation.
- [ ] 4.D : 0 fichier > ~800 lignes.
- [ ] 4.F : couleurs/dimensions tokenisées ; dark mode décidé (livré ou retiré).
- [ ] 4.G : couverture en hausse continue, seuil CI relevé.
