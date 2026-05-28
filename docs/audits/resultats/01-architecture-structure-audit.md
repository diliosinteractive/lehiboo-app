# Audit — Axe 01 Architecture & structure

Date : 2026-05-26 · Branche : `main` · Auditeur : Claude (+ agent exploration) · Plan : [01-architecture-structure.md](../plans/01-architecture-structure.md)

## Synthèse
- **État global : 🟠 Majeur** — Clean Architecture **partielle et inégale** : le socle (mappers events, repositories, routing) est sain, mais de nombreuses features **court-circuitent le domaine** (DTO et datasources consommés directement par la presentation) et **aucune feature n'a de couche `usecases/`**.
- Constats : **~30** (🔴 0 · 🟠 8 · 🟡 11 · 🟢 9 + informatifs)
- **Top 3 actions** :
  1. Créer les entities + mappers manquants (organizer, membership, invitation, thematique, blog, event availability) pour stopper la fuite de DTO en presentation.
  2. Déplacer les `*RepositoryProvider` dans le domain (messages) et exposer les appels via repository (booking).
  3. Aligner les mappers UUID résiduels (latents) et documenter/dépréciér la couche legacy `lib/data` + `lib/domain`.

---

## Constats détaillés

### 🟡 P2 — Risques UUID résiduels (vérifiés **latents**, pas actifs)
> Vérification : le `TicketDto` a bien un champ `uuid` ([booking_api_dto.dart:312](../../../lib/features/booking/data/models/booking_api_dto.dart#L312)), mais le check-in/QR utilise `qrCodeData` (= `t.qrCode`), **pas `Ticket.id`** qui n'est envoyé à aucune route API. La prod construit `Booking.id` depuis `response.uuid`. Les deux constats sont donc **latents** (à corriger pour robustesse), pas des bugs 404 actifs.

| # | Constat | Fichier:ligne | Recommandation |
|---|---------|---------------|----------------|
| P2-U1 | **Mapper booking legacy sans fallback UUID** : `id: id.toString()`. Utilisé par `fake_booking_repository_impl` et le chemin `booking_repository_impl` (pas le chemin prod). | [booking_mapper.dart:8](../../../lib/data/mappers/booking_mapper.dart#L8) | `id: dto.uuid ?? dto.id.toString()`. |
| P2-U2 | **UUID non appliqué au mapping `Ticket`** : `id: t.id.toString()` (2×) au lieu de `t.uuid`. Non envoyé à une route API aujourd'hui (QR via `qrCodeData`), mais incohérent. | [api_booking_repository_impl.dart:318,337](../../../lib/features/booking/data/repositories/api_booking_repository_impl.dart#L318) | `id: t.uuid ?? t.id.toString()`. |

### 🟠 P1 — Violations de couches (presentation → data)
| # | Constat | Fichier:ligne | Recommandation |
|---|---------|---------------|----------------|
| P1-1 | **Presentation booking importe la datasource directement** (5 écrans contournent le repository → non testable sans mocker Dio). | checkout_screen.dart:12, booking_detail_screen.dart:19, booking_success_screen.dart:12, order_cart_screen.dart:18, ticket_detail_screen.dart:11 | Exposer via `BookingRepository`. |
| P1-2 | **DTO sans entité consommés en presentation** : `BookingApiDto`, `OrderApiDto`, `OrganizerProfileDto`, `MembershipDto`, `InvitationDto`, `EventDto`/`HomeFeedResponseDto`. | checkout/booking_success/order_success screens ; organizer_profile_providers.dart:4 ; home_providers.dart:13,18 ; membership_state_providers.dart:8 (+ ~9 fichiers memberships) | Créer entities + mappers ; la presentation consomme l'entité. |
| P1-3 | **`domain/repositories` gamification importe 7 DTO data** → inversion de dépendance brisée (domain dépend de data). | [gamification_repository.dart:1-8](../../../lib/features/gamification/domain/repositories/gamification_repository.dart#L1-L8) | Entities domain Hibons ; retirer les DTO de l'interface. |
| P1-4 | **Presentation messages importe l'impl du repository** (15 fichiers) car `messagesRepositoryProvider` est déclaré dans l'impl. | messages_repository_impl.dart:826 | Déplacer le provider dans `messages_repository.dart` (domain), comme blog. |
| P1-5 | `event_detail_screen` importe **datasource events + DTO availability** (provider inline retournant `EventAvailabilityResponseDto`). | [event_detail_screen.dart:19-20,91-95](../../../lib/features/events/presentation/screens/event_detail_screen.dart#L19-L20) | Déplacer dans `event_providers`, entité `EventAvailability`. |
| P1-6 | `event_detail_screen` importe la **datasource reminders** (cross-feature). | event_detail_screen.dart:43 | Passer par `RemindersRepository`-provider. |
| P1-7 | **search/presentation importe des DTO de events/data** (`event_reference_data_dto`, `search_suggestions_dto`). | filter_provider.dart:6-7 ; filter_bottom_sheet.dart:11-12 ; airbnb_search_sheet.dart:15-16 | Entities `EventReferenceData`, `SearchSuggestions`. |
| P1-8 | **events & search presentation importent la datasource gamification** directement. | event_share_sheet.dart:11 ; search_screen.dart:11 | Service/provider gamification de haut niveau. |

### 🟡 P2 — Cohérence & dette structurelle
| # | Constat | Fichier:ligne | Recommandation |
|---|---------|---------------|----------------|
| P2-1 | **`lib/data/` + `lib/domain/` racine (legacy)** coexistent avec les couches par feature ; `Activity`/`Booking` legacy encore très utilisés via `EventToActivityMapper` (bridge). | lib/data/, lib/domain/ | Documenter comme **déprécié**, bloquer les nouveaux imports en lint, planifier la migration. |
| P2-2 | Routing : `name:` partout (✅) mais navigations par **strings littérales**, `go_router_builder` non activé ; `extra` non-sérialisable (incompatible deeplink cold-start). | app_router.dart:49-50 | Adopter `go_router_builder` ; remplacer `extra` par query params. |
| P2-3 | Route `/booking/:activityId` (et sous-routes) reçoit `extra as Activity` (entité legacy) → couplage fort + pas de deeplink. (Recoupe le code mort de paiement, [audit 14](14-paiement-realtime-push-audit.md) A1.) | app_router.dart:653-681 | Migrer vers `CheckoutParams`/`eventUuid`. |
| P2-4 | DI : `_getRealApiOverrides()` couple `main.dart` à tous les repos (ajout repo = modif main) ; `HibonsService.instance.attach(container)` singleton global. | main.dart:210,245-290 | `core/di/app_overrides.dart` ; documenter l'ordre d'init eager. |
| P2-5 | thematiques : `ThematiqueDto` exposé en presentation, **pas d'entity/mapper**. | thematiques_provider.dart:3 | Créer entity + mapper. |
| P2-6 | blog : interface domain importe `BlogPostDto` ; provider/widgets exposent le DTO. | blog_repository.dart:2 ; blog_providers.dart:3 ; blog_post_card.dart:5 | Entity `BlogPost` + mapper. |
| P2-7 | gamification : dossier **`application/` non standard** + singleton `HibonsService` (portée non Riverpod). | gamification/application/ | Intégrer en provider ou documenter le choix. |
| P2-8 | home : `EventDto`/`HomeFeedDataDto` en presentation (home = orchestration sans domain propre). | home_providers.dart:13,18 | Provider reçoit `List<Event>`. |
| P2-9 | checkin : widgets importent `MembershipDto` (cross-feature DTO). | checkin_scan_screen.dart:12 ; organization_picker_sheet.dart:6 ; vendor_memberships_provider.dart:5 | Entité partagée (core/ ou memberships/domain). |

### 🟢 P3 — Mineurs (nommage / squelettes)
- `booking` utilise `controllers/` vs `providers/` ailleurs ; `onboarding`/`profile` utilisent `domain/models` au lieu de `domain/entities`.
- `search` sans data layer propre (vue filtrée d'events) ; `user_questions` sans DTO/entity ; `stories` sans écran propre.
- `messages_realtime_provider` importe `InAppNotificationDto` (cross-feature + DTO en presentation).
- `app_router` importe entités legacy ; `map_view_screen.dart:147` duplique le mapping Event→Activity inline.
- Imports relatifs et `package:` mélangés sans règle.

### ⚪ Informatif
- **Aucun `usecase`** dans toute la codebase — choix assumé (logique dans les providers), mais `booking_flow_controller` (400+ l.) montre le risque de gonflement.
- Guards auth **mixtes** : redirect global (onboarding/OTP/messages) + `GuestGuard` inline (favoris/alertes/profil) — choix UX documenté.
- `FakeActivityRepositoryImpl` inclus même dans `_getRealApiOverrides()` (main.dart:288) — intentionnel pour widgets legacy, invisible en logs prod.

---

## Tableau des couches par feature (extrait des manques)
| Feature | Manque notable |
|---------|----------------|
| home | pas de domain ni repository (DTO en presentation) |
| search | pas de data layer (s'appuie sur events) |
| thematiques | pas d'entity ni repository (DTO → presentation) |
| blog | pas d'entity (DTO jusqu'à presentation) |
| profile | pas de repository, `domain/models` |
| memberships / partners | pas d'entities (DTO en presentation) |
| petit_boo | pas d'entities (DTO jusqu'en presentation — design assumé SSE) |
| **toutes** | aucune couche `usecases/` |

> Features **conformes** (data→domain→presentation sans court-circuit majeur) : alerts, reminders, reviews, stories, trip_plans, checkin, notifications.

## Points conformes (✅)
- Règle UUID respectée dans le mapper principal `event_mapper.dart:151`.
- GoRouter : noms sur toutes les routes, `_AuthRouterRefresh` propre, redirections legacy (`/ai-chat`, `/hibons-shop`) plutôt qu'écrans morts.
- Mappers reviews/stories/events suivent DTO→Entity ; petit_boo impl respecte les interfaces domain.
- gamification/partners/checkin/favorites : interface repo en domain + impl en data.

## Annexes
- Source : agent code-explorer (104 outils, ~464 s). Réconciliations de gravité appliquées (UUID Ticket/booking-mapper conservés en P0 « à vérifier »).
