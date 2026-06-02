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
| 38 events instrumentés (10 domaines) | ✅ | cf. TRACKING_ACTUEL.md §4 |
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

### 🟠 P1 — Forte valeur, faible effort code : débloque des funnels entiers

| # | Écart | Ce que ça débloque | Effort |
|---|-------|--------------------|--------|
| 5 | **`signup_started` non instrumenté** (déclaré, sans call site) | Mesurer l'abandon **formulaire d'inscription → compte créé**. Aujourd'hui ce décrochage est invisible. | Faible (1 call site dans `register()`) |
| 6 | **`otp_verified` non instrumenté** (idem ; `otp_sent` aussi) | Funnel d'inscription à 4 étapes (form → submit → OTP envoyé → vérifié). Localiser l'échec OTP. | Faible |
| 7 | **`search_no_results` non instrumenté** | Mesurer la **qualité de recherche** : combien de recherches ne renvoient rien (frustration, lacune d'offre par ville). | Faible (à câbler dans SearchScreen quand résultats vides) |

> Ces 3 events sont **déjà déclarés** dans [analytics_event.dart](../../lib/core/analytics/analytics_event.dart)
> — il ne reste qu'à poser les `logEvent`.

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

P1 (code, faible effort — 3 events déjà déclarés)
 5. Câbler signup_started   → register()
 6. Câbler otp_verified     → verifyOtp() / verifyLoginOtp()
 7. Câbler search_no_results → SearchScreen (résultats vides)

P2 (qualité de données)
 8. ATT iOS + set ios_att_status
 9. Poser has_membership au sync auth
10. search_filter_applied (après arbitrage produit)

P3 (nice-to-have)
11. select_content (carrousels home)
12. Localisation du consent gate (l10n)
13. is_voice réel dans petitboo_message_sent
```

> **Le chemin le plus rentable** : P0 (config, sans code) débloque
> l'exploitation des 38 events déjà là, puis P1 (≈ 3 petits `logEvent`)
> débloque le funnel d'inscription et la qualité de recherche.
