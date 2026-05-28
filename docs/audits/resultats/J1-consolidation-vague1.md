# Jalon J1 — Consolidation Vague 1 (Fondations & risque)

Date : 2026-05-26 · Branche : `main` · Auditeur : Claude
Axes couverts : [05 Sécurité](05-securite-audit.md) · [04 Réseau/API](04-reseau-api-donnees-audit.md) · [01 Architecture](01-architecture-structure-audit.md) · [14 Paiement/Realtime/Push](14-paiement-realtime-push-audit.md)

> **Critère du jalon J1** : tous les 🔴 P0 sécurité & paiement identifiés et ticketés. ✅ Atteint.

---

## 1. État global par axe

| Axe | État | 🔴 P0 | 🟠 P1 | Note clé |
|-----|:----:|:-----:|:-----:|----------|
| 05 Sécurité | 🔴 Critique | 2 | 1 | Secrets exposés (git + binaire) |
| 14 Paiement/Realtime/Push | 🟠 Majeur | 1 | 3 | Paiement simulé encore routé + erreurs debug en prod |
| 04 Réseau/API | 🟠 Majeur | 0 | 7 | Pas de `Failure` unifié, datasources sans try/catch |
| 01 Architecture | 🟠 Majeur | 0 | 8 | Fuite massive de DTO en presentation, pas de usecases |

> Les 2 « P0 UUID » initialement remontés par l'agent architecture ont été **vérifiés latents** (le QR de check-in n'utilise pas `Ticket.id`, la prod construit `Booking.id` depuis l'UUID) → re-classés 🟡 P2. Le « P0 » token-logging réseau a été **vérifié protégé `kDebugMode`** → 🟢.

---

## 2. 🔴 P0 — Actions immédiates (à ticketer aujourd'hui)

| ID | Gravité | Problème | Action | Axe |
|----|---------|----------|--------|-----|
| **J1-P0-1** | 🔴 | **Secrets dans l'historique git** (`.env*` trackés du `first commit` à `e1ac79a`) : `HT_PASSWORD`, `API_KEY`, `GOOGLE_MAPS_API_KEY`, `PUSHER_APP_KEY`. | **Roter tous les secrets** (immédiat) → puis réécrire l'historique (`git filter-repo`/BFG) + force-push coordonné. | [05](05-securite-audit.md#1) |
| **J1-P0-2** | 🔴 | **Secrets actifs embarqués dans le binaire** (`.env*` en assets) : basic auth + `API_KEY` extractibles de l'APK/IPA. | Retirer les secrets serveur du bundle (supprimer le basic auth client / remplacer `API_KEY` statique par un jeton post-auth) + activer `--obfuscate`. | [05](05-securite-audit.md#1) |
| **J1-P0-3** | 🔴 (latent) | **Écran de paiement simulé** (`pi_fake_12345`, carte `readOnly`) **toujours déclaré comme route** `/booking/:activityId/payment`. Non atteint par l'UI actuelle, mais catastrophique si re-câblé/deeplinké : réservations confirmées **non payées**. | Supprimer le flow legacy (écrans + `BookingFlowController` + routes) ou le dé-router ; confirmer qu'aucun deeplink ne mappe `/booking/:activityId`. | [14](14-paiement-realtime-push-audit.md#a-paiement--réservation-stripe) |

## 3. 🟠 P1 — Sprint courant

| ID | Problème | Action | Axe |
|----|----------|--------|-----|
| J1-P1-1 | **Messages d'erreur `[DEBUG …]` affichés aux utilisateurs** dans le checkout réel (`TODO RETIRER avant prod`, 4×). | Restaurer les messages localisés (`order_cart_screen.dart` + vérifier `checkout_screen.dart`). | [14](14-paiement-realtime-push-audit.md) |
| J1-P1-2 | **PII (email) loggée sans `kDebugMode`** → fuite dans logs release. | Gater/supprimer (4 emplacements auth/push). | [05](05-securite-audit.md) |
| J1-P1-3 | **Pas de type `Failure` métier** + datasources sans try/catch → `DioException` brutes jusqu'à l'UI. | `AppFailure` + wrapper `safeCall<T>()`, appliqué aux datasources listés. | [04](04-reseau-api-donnees-audit.md) |
| J1-P1-4 | **Fuite de DTO en presentation** (booking, home, partners, memberships, search) + datasources appelées directement. | Entities + mappers manquants ; appels via repository. | [01](01-architecture-structure-audit.md) |
| J1-P1-5 | `getBookingById(int)` viole la règle UUID ; double DTO booking (`booking_dto.dart` legacy). | Signature UUID + suppression du DTO legacy. | [04](04-reseau-api-donnees-audit.md) |
| J1-P1-6 | Dio Petit Boo sans intercepteurs (sécurité/refresh/timeout) ; `sendTimeout` absent (3 configs). | Factory Dio partagé + `sendTimeout`. | [04](04-reseau-api-donnees-audit.md) |
| J1-P1-7 | `domain/repositories` gamification importe des DTO (inversion de dépendance brisée). | Entities domain Hibons. | [01](01-architecture-structure-audit.md) |

---

## 4. Roadmap de remédiation (lots)

1. **Lot Sécurité (urgent, < 1 sem.)** : rotation secrets → réécriture historique → sortie des secrets du bundle → obfuscation → gating PII logs. *(J1-P0-1, J1-P0-2, J1-P1-2)*
2. **Lot Stabilité paiement (< 1 sem.)** : suppression flow simulé → restauration messages d'erreur → garde de ré-entrée → vérif polling billets `/order-confirmation`. *(J1-P0-3, J1-P1-1, axe 14 A3/A4)*
3. **Lot Robustesse réseau (sprint)** : `AppFailure` + `safeCall` → try/catch datasources → `sendTimeout` → CancelToken typeahead → Dio Petit Boo unifié. *(J1-P1-3, J1-P1-5, J1-P1-6)*
4. **Lot Dette archi (continu)** : entities/mappers manquants → providers repo en domain → dépréciation `lib/data`+`lib/domain` (lint) → migration UUID latents. *(J1-P1-4, J1-P1-7, P2-U1/U2)*

## 5. Quick wins (effort S, impact élevé)
- Restaurer les messages d'erreur prod (retirer `[DEBUG]`). · Gater les logs email. · Ajouter `sendTimeout`. · `if (_isLoading) return;` au checkout. · Supprimer la clé doublon `paymentIntentId`. · Aligner les 2 mappers UUID latents.

## 6. Suite (Vague 2)
Conformément au [plan d'exécution](../plans/PLAN-EXECUTION.md) : **07 Tests · 03 State/Riverpod · 11 Observabilité · 08 Dépendances/Build**.
Pré-requis utile : le **correctif du switch d'environnement** ([main.dart:95-99](../../../lib/main.dart#L95-L99), `development → .env.production`) sera traité en axe 08.
