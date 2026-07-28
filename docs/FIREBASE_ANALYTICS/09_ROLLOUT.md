# Étape 9 — Rollout & dashboards

Objectif : passer de "ça marche en debug" à "ça produit de la valeur business en prod" sans casser les KPIs existants.

## 9.1 Phasage release

| Phase | Contenu | Durée | Critère de passage |
|---|---|---|---|
| **Phase 1 — Foundations** | Étapes 1 → 4 + consent gate (étape 7) | 3-4 j | Build prod stable, consent + screen_view OK |
| **Phase 2 — Funnel booking** | Étape 6 partie Auth/Events/Booking + étape 8 | 2-3 j | Funnel `begin_checkout → purchase` validé en DebugView |
| **Phase 3 — Engagement** | Étape 6 partie Search/Favoris/Petit Boo/Hibons | 2-3 j | Tous events de 5.3 visibles GA4 |
| **Phase 4 — Dashboards** | Création dashboards GA4 + BigQuery export | 1-2 j | Dashboards partagés produit/marketing |

Phases 1+2 d'abord en **production "silencieuse"** : code en prod, mais on attend 7 jours avant d'utiliser les chiffres, le temps de stabiliser.

## 9.2 Dashboards GA4 — à créer

### Dashboard "Funnel réservation" (priorité 1)

Source : Explore → Funnel exploration

Étapes :

1. `event_viewed` (event_uuid set)
2. `begin_checkout`
3. `add_payment_info`
4. `purchase`

Segments :

- Nouveau vs récurrent
- Par `user_role`
- Par `home_city_slug` (top 5)

KPI cibles à valider avec produit : taux de conversion étape par étape, abandon par catégorie d'event.

### Dashboard "Acquisition & activation"

- DAU / MAU
- Taux d'activation = % users qui font ≥ 1 `event_viewed` dans les 7 jours après signup
- Sources via `traffic_source` GA4 (auto-rempli depuis deep links / install referrers)

### Dashboard "Petit Boo"

- # users actifs Petit Boo / total DAU
- Top `tool_name` utilisés
- Taux de `petitboo_quota_reached` (signal upsell)
- Conversion `petitboo_tool_used: searchEvents` → `event_viewed` → `purchase`

### Dashboard "Hibons"

- Distribution `hibons_rank`
- # `hibons_earned` par `source`
- Corrélation rang ↔ rétention 30j

## 9.3 Audiences GA4

Créer dans Admin → Audiences :

- **Abandonneurs paiement** : `begin_checkout` ET NOT `purchase` dans les 24h. → réutilisable pour ciblage push OneSignal (via export Firebase).
- **Premium engagés** : `user_role = member` ET ≥ 3 `event_viewed` / 7j.
- **Power users Petit Boo** : ≥ 5 `petitboo_message_sent` / 30j.

## 9.4 Export BigQuery (optionnel mais recommandé)

Firebase → Project Settings → Integrations → BigQuery → Link.

Avantages :

- Conserver les events bruts au-delà des 14 mois GA4.
- Croiser avec les données backend Laravel (bookings, users) sur le `user_id` partagé.
- Construire des dashboards Metabase / Looker Studio avancés.

Coût : ~quelques € / mois tant qu'on est sous le free tier BigQuery. À monitorer.

## 9.5 Coordination équipes

### Avant déploiement Phase 1

- [ ] **Produit / Marketing** : signoff sur le catalogue d'events (étape 5).
- [ ] **Légal / DPO** : signoff sur politique de confidentialité + texte du consent gate.
- [ ] **Support** : briefer sur le toggle Profil > Confidentialité (FAQ ticket #X).
- [ ] **App Store / Play Store** : mettre à jour les fiches "Privacy" / "Data safety" pour mentionner Firebase Analytics.

### Après chaque phase

- Communication interne (Slack #produit) : « Phase X live, voici les premiers chiffres après 7j ».
- Revue avec PM : qu'est-ce qui manque, qu'est-ce qui est bruité.

## 9.6 Critères de succès post-rollout (J+30)

| Métrique | Seuil |
|---|---|
| Taux opt-in consent | ≥ 60% (sinon revoir UX du gate, étape 7) |
| % users avec `user_id` set (parmi loggés) | ≥ 95% |
| Events droppés par Firebase (logcat warning) | ~ 0 |
| Couverture funnel : `purchase` non-orphelin (les 4 étapes précédentes présentes) | ≥ 80% |
| Crashes liés à analytics (Crashlytics quand activé) | 0 |

## 9.7 Maintenance continue

- **Revue mensuelle du catalogue** : retirer les events morts, ajouter ceux qui manquent.
- **Quota events custom** : surveiller (500 max). Si on s'en approche, fusionner via param `subtype` plutôt que de créer N events.
- **Versionner le catalogue** : `analytics_event.dart` a un commentaire de version en tête, bump à chaque changement. Permet de retracer l'origine d'une régression de mesure.

## Critères de sortie

- [ ] 4 phases livrées.
- [ ] Dashboards 9.2 créés et partagés.
- [ ] Audiences 9.3 actives.
- [ ] Export BigQuery branché (ou décision documentée de ne pas le faire).
- [ ] Politique confidentialité + fiches stores à jour.
- [ ] Rituel de revue mensuelle planifié.
