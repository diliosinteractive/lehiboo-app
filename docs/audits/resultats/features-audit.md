# Audits par feature — Le Hiboo

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude · Gabarit : [GABARIT-audit-feature.md](../plans/GABARIT-audit-feature.md)

> Ce document fournit une **fiche détaillée** pour les 4 features prioritaires (booking, auth, petit_boo, messages) et une **matrice de couverture** pour les 23 features. Les constats détaillés vivent dans les rapports d'axes transverses ([resultats/](.)) ; les fiches **agrègent par feature** + ajoutent les points spécifiques.

---

## Fiche 1 — `booking` (46 fichiers, 12 191 l.) · Verdict : 🟠 **Majeur**

Feature la plus critique (manipule de l'argent). Déjà très couverte transversalement.

| Gravité | Constat | Source |
|---------|---------|--------|
| 🔴 P0 | Écran de paiement **simulé** (`pi_fake_12345`) encore routé (flow legacy mort). | [14](14-paiement-realtime-push-audit.md) A1, [02](02-qualite-code-conventions-audit.md) Q8 |
| 🟠 P1 | Messages d'erreur `[DEBUG]` Stripe affichés à l'utilisateur en prod (flow réel). | [14](14-paiement-realtime-push-audit.md) A2 |
| 🟠 P1 | Presentation appelle la **datasource directement** (5 écrans) + DTO en presentation. | [01](01-architecture-structure-audit.md) P1-1/P1-2 |
| 🟠 P1 | **Double DTO booking** (`booking_dto` legacy vs `booking_api_dto`) + `getBookingById(int)` viole UUID. | [04](04-reseau-api-donnees-audit.md) P1-3/P1-4 |
| 🟠 P1 | **Chemin critique non testé** : le seul test cible le flow mort, pas le paiement réel. | [07](07-tests-qualite-audit.md) P0-1 |
| 🟠 P1 | God screen `order_cart_screen.dart` (1255 l.) + `setState` au scroll (jank). | [02](02-qualite-code-conventions-audit.md), [06](06-performance-audit.md) |
| 🟡 P2 | Pas de garde de ré-entrée au submit ; polling billets à confirmer sur `/order-confirmation`. | [14](14-paiement-realtime-push-audit.md) A3/A4 |
| 🟡 P2 | CrashReporter asymétrique (flow réel instrumenté, legacy non) ; mapper Ticket UUID latent. | [11](11-observabilite-crash-analytics-audit.md), [01](01-architecture-structure-audit.md) P2-U2 |

**Spécifique / ✅** : compensation transactionnelle (`shouldCancelOrderOnError`), timer de réservation synchronisé serveur, invalidation des caches « places restantes » post-achat — **bien conçus**. **Action n°1** : supprimer le flow legacy (résout P0 + plusieurs P1/P2).

---

## Fiche 2 — `auth` (34 fichiers, 11 425 l.) · Verdict : 🟠 **Majeur**

| Gravité | Constat | Source |
|---------|---------|--------|
| 🟠 P1 | **Échec de refresh token silencieux** (déconnexion sans trace/non-fatal). | [11](11-observabilite-crash-analytics-audit.md) P1-4 |
| 🟠 P1 | **5 `catch(_){}` vides** dans `auth_provider` (flow d'authentification). | [11](11-observabilite-crash-analytics-audit.md) P1-3, [02](02-qualite-code-conventions-audit.md) Q3 |
| 🟠 P1 | **Email (PII) loggé** sans `kDebugMode` (register). | [05](05-securite-audit.md) #3 |
| 🟡 P2 | `business_register_provider` volumineux (logique + analytics + nav mêlées). | [03](03-state-management-riverpod-audit.md), [02](02-qualite-code-conventions-audit.md) |
| 🟡 P2 | `setUserIdentifier` Crashlytics jamais posé (corrélation crash↔user). | [11](11-observabilite-crash-analytics-audit.md) P1-1 |

**Spécifique / ✅** : **stockage tokens chiffré** (Keychain/EncryptedSharedPreferences), **`clearAuthData()` complet** au logout, OTP + register customer/business présents, guards auth (redirect + GuestGuard) cohérents ([05](05-securite-audit.md), [01](01-architecture-structure-audit.md) INFO-02). Socle sécurité auth **sain** ; la dette est sur l'observabilité (catch vides, refresh silencieux).

---

## Fiche 3 — `petit_boo` (40 fichiers, 12 522 l.) · Verdict : 🟠 **Majeur**

| Gravité | Constat | Source |
|---------|---------|--------|
| 🟠 P1 | **Dio parallèle sans intercepteurs** (sécurité/refresh/timeout) : un 401 Petit Boo ne force pas le logout. | [04](04-reseau-api-donnees-audit.md) P1-6 |
| 🟡 P2 | **Fuite `http.Client` SSE** (pas de `try/finally`). | [14](14-paiement-realtime-push-audit.md) C1, [04](04-reseau-api-donnees-audit.md) P2-6 |
| 🟡 P2 | **God provider** `petit_boo_chat_provider` (819 l., non-autoDispose par design) : souscription SSE non annulée dans `_initialize()`. | [03](03-state-management-riverpod-audit.md) P2-1 |
| 🟡 P2 | **Pas d'entities** : DTO (ChatMessage, Conversation…) jusqu'en presentation (design assumé SSE). | [01](01-architecture-structure-audit.md) |
| 🟡 P2 | 15 `debugPrint` non gardés. | [02](02-qualite-code-conventions-audit.md) Q2 |

**Spécifique / ✅** : **gestion de quota** (`isLimitReached`, `QuotaDto`, dialog limite) présente ✅ ; architecture **schema-driven** des tool cards (ajout d'outil = 1 entrée de schéma) — élégante et conforme à CLAUDE.md. Risque principal : robustesse réseau du Dio isolé + cycle de vie SSE.

---

## Fiche 4 — `messages` (46 fichiers, 17 010 l.) · Verdict : 🟠 **Majeur**

| Gravité | Constat | Source |
|---------|---------|--------|
| 🟠 P1 | **Concentration de `catch(_){}` vides** : vendor_conversations (6-7), admin_conversations (5) → erreurs realtime invisibles. | [11](11-observabilite-crash-analytics-audit.md) P1-3 |
| 🟠 P1 | **52 `dev.log` non routés vers Crashlytics** (erreurs Pusher visibles seulement en debug). | [11](11-observabilite-crash-analytics-audit.md) P2-2 |
| 🟠 P1 | **God widget `new_conversation_form.dart` (2103 l.)** + `conversations_list_screen` (1140 l., `ignore_for_file`). | [02](02-qualite-code-conventions-audit.md) Q1 |
| 🟠 P1 | **`messagesRepositoryProvider` déclaré dans l'impl** → 15 fichiers presentation importent l'impl. | [01](01-architecture-structure-audit.md) P1-4 |
| 🟡 P2 | Code commenté « onglet Partenaires v2 » (4×) ; `InAppNotificationDto` cross-feature en presentation. | [02](02-qualite-code-conventions-audit.md) Q14, [01](01-architecture-structure-audit.md) P3-7 |

**Spécifique / ✅** : **`dispose()` realtime exemplaire** (5 subscriptions Pusher + close client), **polling de secours** correctement bypassé quand Pusher est actif. La dette est sur l'**observabilité** (catch/dev.log) et la **taille des fichiers**.

---

## Matrice de couverture — 23 features

> P0/P1 = constats rattachables à la feature (via les axes). « Couverture » = profondeur d'audit atteinte. Les petites features (✅ structure conforme) n'ont pas de P0/P1 propres au-delà des constats transverses.

| Feature | Taille | P0 | P1 notables | Réf. axes |
|---------|-------:|:--:|-------------|-----------|
| **events** | 18.5k | 0 | datasource+DTO en presentation, `setState` scroll, parsing main isolate, normalisation pagination 97 l. | 01, 04, 06 |
| **messages** | 17.0k | 0 | catch vides, dev.log, god widget 2103, provider dans impl | 11, 02, 01 |
| **petit_boo** | 12.5k | 0 | Dio sans intercepteurs, SSE leak, god provider | 04, 14, 03 |
| **search** | 12.5k | 0 | **2 god widgets (3134+2099 l.)**, DTO events en presentation, pas de CancelToken typeahead, pagination dans le filtre | 02, 01, 04, 03 |
| **booking** | 12.2k | 1 | paiement simulé, debug en prod, double DTO, non testé | 14, 04, 07, 02 |
| **auth** | 11.4k | 0 | refresh silencieux, catch vides, PII logs | 11, 05 |
| **home** | 8.0k | 0 | `setState` scroll plein écran, DTO en presentation, stub `_isAvailableForHome`, code commenté | 06, 01, 02 |
| **gamification** | 6.1k | 0 | domain importe DTO, singleton `HibonsService` hors Riverpod, dossier `application/` | 01, 03 |
| **reviews** | 5.1k | 0 | `invalid_annotation_target` (analyze) ; structure conforme ✅ | 04, 02 |
| **partners** | 4.0k | 0 | DTO `OrganizerProfile` en presentation, `font_awesome` 1 usage | 01, 02 |
| **memberships** | 3.9k | 0 | DTO en presentation (Membership/Invitation) | 01 |
| **favorites** | 3.9k | 0 | datasources sans try/catch, `_parseInt` dupliqué, commentaire UUID trompeur | 04, 02 |
| **profile** | 3.0k | 0 | pas de repository, `domain/models` | 01 |
| **checkin** | 2.3k | 0 | `MembershipDto` cross-feature ; **flux QR sain** ✅ | 01 |
| **notifications** | 2.2k | 0 | datasources sans try/catch, log email payload | 04, 05 |
| **trip_plans** | 2.1k | 0 | `_parseInt`/dual-key dupliqués ; structure conforme ✅ | 04 |
| **thematiques** | 1.0k | 0 | DTO en presentation, pas d'entity ; `withOpacity`/curly (analyze) | 01, 02 |
| **alerts** | 1.0k | 0 | `createAlert` sans `ApiResponseHandler`, pas de try/catch | 04 |
| **reminders** | 0.9k | 0 | `ListView` non virtualisée, pagination `perPage:50` figée | 06, 04 |
| **blog** | 0.7k | 0 | DTO jusqu'en presentation (pas d'entity) | 01, 02 |
| **user_questions** | 0.7k | 0 | pas de DTO/entity propres | 01 |
| **stories** | 0.4k | 0 | pas d'écran propre (intégré home) ; mappers conformes ✅ | 01, 06 |
| **onboarding** | 0.3k | 0 | `domain/models` ; squelettique | 01 |

**Total P0 rattachés aux features : 1** (booking, paiement simulé). Tous les autres P0 sont **transverses** (sécurité secrets, toolchain tests) — voir [SYNTHESE-EXECUTIVE.md](SYNTHESE-EXECUTIVE.md).

## Verdict global features
- **Aucune feature n'est en état critique isolé** : les risques majeurs sont transverses (sécurité, toolchain) ou concentrés sur **booking** (paiement).
- **Dette structurelle récurrente** : DTO en presentation (≈10 features), god widgets (search/messages), observabilité (auth/messages).
- **Features saines** (structure conforme, pas de dette propre notable) : reviews, trip_plans, checkin, stories, reminders, alerts.
