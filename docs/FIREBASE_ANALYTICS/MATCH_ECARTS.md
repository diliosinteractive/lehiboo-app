# Match Firebase Analytics — ce qui est en place vs ce qui manque

> Analyse d'écart entre **l'état réel du code** (vérifié au 2026-06-02) et **ce
> qu'il faut pour exploiter les funnels** de [ETUDE_FUNNELS_RECOMMANDES.md](ETUDE_FUNNELS_RECOMMANDES.md).
> Les écarts sont classés **par ordre de priorité**.
>
> Sources : [TRACKING_ACTUEL.md](TRACKING_ACTUEL.md) + relecture des call sites.

---

## ✅ Déjà en place (vérifié dans le code)

| Brique | Statut | Preuve |
|--------|--------|--------|
| Abstraction `AnalyticsService` + provider Riverpod | ✅ | [analytics_service.dart](../../lib/core/analytics/analytics_service.dart) |
| Sanitization (troncatures, conversions, try/catch) | ✅ | `FirebaseAnalyticsService` |
| Fallback `NoopAnalyticsService` si Firebase KO | ✅ | [noop_analytics_service.dart](../../lib/core/analytics/noop_analytics_service.dart) |
| **Consent gate RGPD** (modal bloquant 1er launch) | ✅ | [consent_gate_modal.dart](../../lib/core/analytics/widgets/consent_gate_modal.dart), branché dans [main_scaffold.dart:51](../../lib/core/widgets/main_scaffold.dart#L51) |
| Collecte pilotée par le consentement | ✅ | [main.dart:192](../../lib/main.dart#L192) + [analytics_consent.dart](../../lib/core/analytics/analytics_consent.dart) |
| Toggle consentement dans Settings | ✅ | [settings_screen.dart](../../lib/features/profile/presentation/screens/settings_screen.dart) |
| **`screen_view` auto** (observer root + ShellRoute) | ✅ | [app_router.dart:139](../../lib/routes/app_router.dart#L139) + [:238](../../lib/routes/app_router.dart#L238) |
| 42 events instrumentés (10 domaines) | ✅ | cf. TRACKING_ACTUEL.md §4 |
| 7 user properties + `user_id` | ✅ | cf. TRACKING_ACTUEL.md §3 |

> **Bonne nouvelle** : le socle technique est complet. Les écarts ci-dessous
> sont soit de la **config console GA4**, soit des **events d'appoint**, pas une
> refonte.

---

## ❌ Écarts par ordre de priorité

### 🔴 P0 — Bloquant : sans ça, les 38 events existants sont inexploitables

Ces écarts sont **côté console GA4** (à confirmer/réaliser, non vérifiables
depuis le code) mais conditionnent toute l'analyse.

| # | Écart | Impact si absent | Effort |
|---|-------|------------------|--------|
| 1 | **Custom Definitions non déclarées** (`event_uuid`, `category`, `city_slug`, `source`, `is_free`, `step`, `reason`, `tool_name`, `channel`, `has_date_filter`, `quota_type`) + user props (`user_role`, `home_city_slug`, `hibons_rank`, etc.) | Impossible de **segmenter** un funnel par ville / catégorie / source / gratuit-payant. Les params partent mais sont invisibles dans les rapports. | Faible (config) |
| 2 | **Conversions non marquées** (`sign_up`, `search_saved`, `membership_join_completed` ; `purchase` l'est par défaut) | Pas de suivi conversion dans les rapports standard ni l'attribution. | Faible (config) |
| 3 | **Filtre données internes** (`env = production` / exclusion trafic dev) | Les events dev/staging **polluent** les chiffres prod. | Faible (config) |
| 4 | **Les 2 funnels P0 non construits** (Réservation + Découverte→Réservation) | Le KPI n°1 business n'est pas suivi. | Faible (config) |

> ⚠️ À **confirmer côté console** `lehiboo-77c35` : ces 4 points ne sont pas
> vérifiables depuis le repo. S'ils sont déjà faits, P0 est clos.

---

### 🟠 P1 — ✅ RÉSOLU (commit `3af9ed4`)

Les events qui débloquaient le funnel d'inscription et la qualité de recherche
sont **désormais instrumentés** :

| # | Écart | Statut | Débloque |
|---|-------|--------|----------|
| 5 | `signup_started` | ✅ Câblé dans `register()` | Abandon **formulaire d'inscription → compte créé** |
| 6 | `otp_sent` + `otp_verified` | ✅ Câblés (register, login 2FA, resend / verifyOtp, verifyLoginOtp) | Funnel d'inscription 4 étapes + localisation de l'échec OTP |
| 7 | `search_no_results` | ✅ Câblé dans SearchScreen (dédup par filtre) | **Qualité de recherche** (recherches sans résultat) |

> Détail des call sites : [TRACKING_ACTUEL.md](TRACKING_ACTUEL.md) §4.1 et §4.2.
> Ajout de la classe de valeurs `AnalyticsOtpType` (`register`/`login`).
>
> ⚠️ Pensez à déclarer la dimension custom `Type` (param `type`) côté GA4 si ce
> n'est pas déjà fait — elle est partagée avec `notification_opened`.

---

### 🟡 P2 — Qualité de données & analyses secondaires

| # | Écart | Impact | Effort |
|---|-------|--------|--------|
| 8 | **`ios_att_status` jamais posée + aucun prompt ATT** | Sur iOS, sans App Tracking Transparency, GA4 tourne en mode **modelé** (données dégradées, pas d'IDFA). La property est déclarée mais jamais écrite ; aucune implémentation `AppTrackingTransparency` dans `lib/`. | Moyen (plugin ATT + prompt + set property) |
| 9 | **`has_membership` user property jamais posée** | Pas de segmentation membres vs non-membres dans **tous** les funnels. | Faible (set au sync auth, à côté de `user_role`) |
| 10 | **`search_filter_applied` non instrumenté** | Usage des filtres non mesuré (quels filtres servent vraiment). | Moyen (arbitrage produit sur la granularité — `FilterBottomSheet` volumineux) |

---

### 🟢 P3 — Nice-to-have

| # | Écart | Impact | Effort |
|---|-------|--------|--------|
| 11 | **`select_content` non instrumenté** | Pas de mesure des clics sur carrousels/sections de la home (promotion de contenu). | Moyen |
| 12 | **Strings du consent gate hardcodées en FR** | Le consentement n'est pas localisé (EN). Conformité OK mais UX EN dégradée. | Faible (migration l10n, notée dans le code) |
| 13 | **`petitboo_message_sent` : `is_voice` toujours `false`** | On ne distingue pas les messages vocaux des messages texte dans les stats Petit Boo. | Faible (passer le vrai flag depuis VoiceFab) |

---

## Synthèse — ordre d'exécution recommandé

```
P0 (config GA4, à confirmer console)
 1. Déclarer les Custom Definitions (dimensions + user props)
 2. Marquer les conversions (sign_up, search_saved, membership_join_completed)
 3. Activer le filtre env = production
 4. Construire les 2 funnels P0 (Réservation, Découverte→Réservation)

P1 (code) — ✅ FAIT (commit 3af9ed4)
 5. signup_started    → register()                       ✅
 6. otp_sent/verified → register / login 2FA / verifyOtp ✅
 7. search_no_results → SearchScreen (résultats vides)   ✅

P2 (qualité de données)
 8. ATT iOS + set ios_att_status
 9. Poser has_membership au sync auth
10. search_filter_applied (après arbitrage produit)

P3 (nice-to-have)
11. select_content (carrousels home)
12. Localisation du consent gate (l10n)
13. is_voice réel dans petitboo_message_sent
```

> **État actuel** : le P1 (code) est livré — funnel d'inscription et qualité de
> recherche débloqués. Reste le **P0 (config console GA4)** qui rend exploitables
> les 42 events instrumentés, puis le P2/P3.
