# Plan d'exécution — Remédiation Tier 3 (fort blast radius / décisions / coordination)

Date : 2026-05-28 · Branches : multiples (cf. lots) · Pré-requis : [Tier 1](TIER1-execution.md) (toolchain), idéalement [Tier 2](TIER2-execution.md) (tests/observabilité)

> **Périmètre** : actions à **fort impact** ou **irréversibles/opérationnelles**, nécessitant **coordination d'équipe** ou **décision produit**. Ce sont aussi les plus **urgentes sur le fond** (sécurité, paiement) — « fort impact » ≠ « non prioritaire ». À mener avec préparation et fenêtre dédiée.
> ⚠️ Plusieurs items requièrent une **décision** (marquée 🟦) ou une **coordination** (marquée 🟥 invalide les clones / affecte la prod).

---

## Lot 3.A — Sécurité des secrets 🟥 (le plus urgent au fond)
- **Constats** : [05](../resultats/05-securite-audit.md) #1/#2, [J1](J1-consolidation-vague1.md).
- **Tâches (ordre impératif)** :
  1. **Roter d'abord** TOUS les secrets exposés (l'exposition est déjà effective) : `HT_PASSWORD`, `API_KEY`, `GOOGLE_MAPS_API_KEY` (+ restrictions GCP referrer/bundle), `PUSHER_APP_KEY`. Mettre à jour les variables Xcode Cloud + `.env*` locaux.
  2. **Réécrire l'historique git** (fenêtre coordonnée — invalide tous les clones) :
     ```bash
     git filter-repo --path .env --path .env.development --path .env.production --path .env.staging --invert-paths
     git push --force-with-lease --all
     ```
  3. Prévenir l'équipe de re-cloner.
- **Blast radius** : 🟥 élevé (force-push, re-clone obligatoire ; rotation = coupure si mal séquencée).
- **Validation** : nouveau build avec secrets rotés fonctionne (API, Maps, Pusher) ; `git log -p` ne montre plus de secrets.
- **Effort** : M-L. **Préparation + créneau dédié.**

## Lot 3.B — Sortir les secrets serveur du binaire 🟦
- **Constats** : [05](../resultats/05-securite-audit.md) #2/#5.
- **Tâches** : 🟦 **décider** si le basic auth htaccess est encore requis en prod. Si non → le retirer du client. Si oui → le porter côté infra/CDN. Remplacer l'`API_KEY` statique partagée par un **jeton applicatif émis après auth**. La clé Stripe *publishable* peut rester.
- **Blast radius** : moyen-élevé — change les headers envoyés ; **casse l'API si le backend exige encore ces secrets** → coordination backend obligatoire.
- **Validation** : tous les endpoints répondent sans le basic auth/API_KEY embarqués.
- **Effort** : L (dépend du backend).

## Lot 3.C — Corriger le switch d'environnement 🟦
- **Constats** : [08](../resultats/08-dependances-build-config-audit.md) P1-1.
- **Tâches** : ajouter la branche `'development' => '.env.development'` ; 🟦 **décider du défaut** (proposé : `.env.development` pour le local). Mettre à jour CLAUDE.md.
- **Blast radius** : moyen — change le backend ciblé par un `flutter run` local sans `--dart-define`. **Valider que la CI/TestFlight passent toujours `--dart-define=ENV=…`** (oui, cf. `ci_post_clone.sh`).
- **Validation** : `flutter run` local → charge bien `.env.development` ; builds CI inchangés.
- **Effort** : S (code) + alignement équipe.

## Lot 3.D — CI/CD 🟥
- **Constats** : [13](../resultats/13-ci-cd-release-audit.md) P1-1/P1-2.
- **Tâches** :
  1. `.github/workflows/ci.yml` : `dart format --set-exit-if-changed` + `flutter analyze` + `flutter test --coverage` + build debug (workflow fourni dans [13 §3](../resultats/13-ci-cd-release-audit.md)). Aligné sur Flutter **3.38.7** (`.fvmrc`).
  2. CI Android : build appbundle **signé** (secrets via `${{ secrets.* }}`) + upload Play interne (fastlane/Gradle Play Publisher).
  3. Scan OSV des dépendances.
- **Blast radius** : moyen — l'activation de checks de PR peut bloquer des merges (effet voulu). Reconstruire les secrets en CI **sans** les committer.
- **Validation** : CI verte sur une PR de test ; build Android signé produit.
- **Effort** : M-L. **Pré-requis : T1.1 (toolchain) + tests compilent.**

## Lot 3.E — Sécuriser le signing release Android
- **Constats** : [08](../resultats/08-dependances-build-config-audit.md) P1-2.
- **Tâches** : faire **échouer** le build release si le keystore manque (ne plus retomber sur la clé debug).
- **Blast radius** : faible-moyen — un build release sans keystore échouera désormais (comportement voulu).
- **Validation** : build release sans keystore → échec explicite ; avec keystore → signé prod.
- **Effort** : S.

## Lot 3.F — Activer minify/R8 + obfuscation
- **Constats** : [08](../resultats/08-dependances-build-config-audit.md) P2-1, [05](../resultats/05-securite-audit.md) #4.
- **Tâches** : `isMinifyEnabled = true` + `isShrinkResources = true` (release) ; `flutter build --obfuscate --split-debug-info=…`.
- **Blast radius** : moyen-élevé — R8 peut casser la réflexion (JSON/plugins) sans bonnes règles ProGuard ; l'obfuscation complique les stacktraces (garder les symboles). **Tester un build release complet de bout en bout.**
- **Validation** : APK release minifié fonctionne (parsing JSON, plugins, paiement, push, scan QR) ; symboles uploadés.
- **Effort** : M.

## Lot 3.G — Supprimer le flow de paiement legacy (code mort) 🟦
- **Constats** : [14](../resultats/14-paiement-realtime-push-audit.md) A1, [02](../resultats/02-qualite-code-conventions-audit.md) Q5, [01](../resultats/01-architecture-structure-audit.md) P2-3.
- **Tâches** : 🟦 **confirmer qu'aucun deeplink ne mappe `/booking/:activityId`**, puis supprimer `BookingPaymentScreen`, `BookingSlotSelectionScreen`, `BookingParticipantScreen`, `BookingConfirmationScreen`, `BookingFlowController` + leurs routes. Retire aussi le `pi_fake_12345`.
- **Blast radius** : moyen — suppression de code routé ; risque si une nav oubliée pointe dessus. Faire après une recherche exhaustive des références.
- **Validation** : recherche `/booking/` → 0 nav vers le flow legacy ; `flutter test`/run OK ; le flow réel `/cart` intact.
- **Effort** : S-M.

## Lot 3.H — Tests des chemins critiques
- **Constats** : [07](../resultats/07-tests-qualite-audit.md) P0-1.
- **Tâches** : ajouter `mocktail` + `integration_test` ; tester `api_booking_repository_impl` (create/confirm/cancel + compensation), `JwtAuthInterceptor` (401→refresh→retry, force-logout), mappers UUID booking/ticket, parcours réservation (gratuite + payante Stripe test).
- **Blast radius** : nul (ajout de tests) — mais **pré-requis : toolchain réparé** (Tier 1).
- **Validation** : suite verte ; couverture mesurable (établir le 1er %).
- **Effort** : L.

---

## Séquencement & dépendances
1. **3.A (sécurité)** dès que possible (urgent au fond) — créneau coordonné.
2. **3.D (CI) + 3.H (tests)** après T1.1 — fondation de validation pour tout le reste.
3. **3.C (env)** + **3.E (signing)** : rapides, à grouper.
4. **3.B (secrets binaire)** + **3.F (minify/obfus)** : nécessitent coordination backend / tests release complets.
5. **3.G (legacy)** : après confirmation d'absence de deeplink.

## Décisions requises (🟦) à acter avant exécution
- Basic auth htaccess en prod : requis ou non ? (3.B)
- Défaut du switch d'env local (3.C).
- Confirmation deeplink `/booking/:activityId` (3.G).

## Definition of Done
- [ ] Secrets rotés + historique réécrit + retirés du bundle.
- [ ] CI PR verte (analyze+test+build) + CI Android signée.
- [ ] Tests critiques (paiement, refresh) verts ; couverture mesurée.
- [ ] Switch d'env corrigé ; signing release sécurisé ; minify/obfuscation actifs.
- [ ] Flow paiement legacy supprimé.

> **Suite** : [Tier 4](TIER4-execution.md) (initiatives architecturales longues : montées de versions, migration legacy, god widgets, design tokens).
