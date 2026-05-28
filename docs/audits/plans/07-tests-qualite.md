# Plan 07 — Tests & qualité logicielle

Objectif : mesurer la couverture réelle, définir une stratégie de tests réaliste
et prioriser les chemins critiques (paiement, réservation, auth).

## Périmètre
`test/` (12 fichiers existants), `integration_test/` (à créer ?), tout code testable de `lib/`.

## Risques connus (baseline)
- 🔴 **12 fichiers de test pour ~257 000 lignes** → couverture quasi nulle.
- Tests existants ciblent : deeplinks, l10n, booking (flow, cart, participant form), event mapper, search filters, memberships dedup, activity mapper, `widget_test`.
- ❌ Aucun test sur : auth, paiement Stripe, réseau/interceptors, providers Riverpod, realtime, Petit Boo SSE, la majorité des features.

## Checklist
- [ ] **Mesurer la couverture** : `flutter test --coverage` + `lcov`/`genhtml` ; établir le % par feature.
- [ ] **Pyramide de tests** : définir la cible (beaucoup d'unitaires/mappers/providers, quelques widgets, peu d'intégration e2e ciblés).
- [ ] **Chemins critiques d'abord** (P0) :
  - [ ] Réservation complète (`createBooking` → paymentIntent → confirm → tickets), y compris cas gratuit (`confirm-free`) et annulation.
  - [ ] Auth (login/refresh/`forceLogout` 401/logout efface le secure storage).
  - [ ] Mappers Event/Booking : **règle UUID vs id** (non-régression du bug 404).
  - [ ] Couche réseau : intercepteurs (auth header, 401), parsing d'erreur, parsing DTO camelCase/snake_case.
- [ ] **Providers Riverpod** : tester les notifiers avec `ProviderContainer` + overrides (repositories fakes — `FakeBookingRepositoryImpl` existe déjà).
- [ ] **Widget tests** : états loading/empty/error des écrans clés ; composants partagés.
- [ ] **Golden tests** : composants UI stables (cartes event, chips de filtres, message bubbles).
- [ ] **Tests d'intégration** (`integration_test/`) : 2-3 parcours bout-en-bout sur le chemin de réservation et l'auth.
- [ ] **Mocking** : stratégie unifiée (fakes maison déjà présents vs `mocktail`) ; éviter les appels réseau réels.
- [ ] **Déterminisme** : pas de tests flaky (timers, dates → injecter `Clock`/fixer `intl`).
- [ ] **Lien CI** : ces tests doivent tourner dans la CI (plan 13) avec seuil de couverture.
- [ ] **Données de test** : factories/fixtures réutilisables pour DTO/entities.

## Commandes / mesures
```bash
flutter test --coverage
# Rapport HTML
genhtml coverage/lcov.info -o coverage/html

# Couverture par dossier (approximatif)
rg -c "" coverage/lcov.info   # ou parser lcov par feature

# Inventaire des tests existants vs features
fd -e dart . test
fd -t d . lib/features -d 1
```

## Livrable
% de couverture global + par feature, liste priorisée des tests P0 à écrire (chemin réservation/auth/réseau en tête), choix de stack de mocking, cible de couverture à imposer en CI (ex. ratchet : ne jamais descendre).
