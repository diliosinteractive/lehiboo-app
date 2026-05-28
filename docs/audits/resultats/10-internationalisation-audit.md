# Audit — Axe 10 Internationalisation (i18n / l10n)

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude (+ agent exploration) · Plan : [10-internationalisation.md](../plans/10-internationalisation.md)

## Synthèse
- **État global : 🟢 Bon** — le rollout i18n est **quasi-achevé** (26 tranches jusqu'au 2026-05-15) : **parité parfaite des ARB (2052 clés fr = en)**, locale persistée, `Accept-Language` dynamique, `ApiResponseHandler` localisé. Couverture effective sur les écrans actifs **> 97 %**. Les défauts résiduels sont **peu nombreux et superficiels**, sauf le **formatage des prix** (toujours au format français quelle que soit la locale).
- Constats : **0 🔴 · 3 🟠 P1 · 3 🟡 P2 · informatifs**
- **Top 3 actions** :
  1. Centraliser le **formatage des prix** (`NumberFormat.currency` selon locale) — seul défaut à impact large.
  2. Localiser les 3 chaînes FR en dur de `conversation_load_error_view`.
  3. Corriger les 3 `DateFormat('dd/MM…')` hardcodés.

---

## Constats détaillés

### 🟠 P1 — Majeurs
| # | Constat | Fichier:ligne | Reco | Effort |
|---|---------|---------------|------|--------|
| P1-1 | **Formatage des prix non localisé** : partout `toStringAsFixed(2)+'€'` (et un `.replaceAll('.', ',')` forcé) → affiche toujours `25,00€` même en anglais. Touche `Event.priceForDisplay` (très utilisé), checkout, panier, cartes. | event.dart:381-385, cart_summary_section.dart:25, event_ticket_card.dart:269, order_cart_screen.dart:1199, checkout_screen.dart:888 | Helper `context.formatPrice(amount, currency)` via `NumberFormat.currency(locale:…)`. | M |
| P1-2 | **3 chaînes FR en dur dans un widget actif** (`conversation_load_error_view`, monté par 2 écrans messages) → texte français pour les anglophones. Les clés ARB équivalentes existent déjà. | [conversation_load_error_view.dart:22-25](../../../lib/features/messages/presentation/widgets/conversation_load_error_view.dart#L22-L25) | `context.l10n.commonNoInternetTitle` etc. | S |
| P1-3 | **3 `DateFormat('dd/MM…')` hardcodés** sans branche locale (format FR imposé). | notifications_inbox_screen.dart:536, alerts_list_screen.dart:378, hibon_shop_screen.dart:245-246 | `context.appDateFormat(frPattern, enPattern:…)` (helper existant). | S |

### 🟡 P2 — Moyens
| # | Constat | Fichier:ligne | Reco |
|---|---------|---------------|------|
| P2-1 | **Incohérence ICU plural FR/EN** : `membershipInvitationExpiresInHours` et `…ActiveWithExpiryBlurb` ont le pattern `plural` en EN mais pas en FR (fonctionnel mais incohérent). | app_fr.arb:1319,1279 vs app_en.arb:1274,1234 | Aligner FR sur le pattern ICU. |
| P2-2 | **`l10n.yaml` minimal** : pas de `required-resource-attributes` ni `untranslated-messages-file` → moins de garde-fous au build. | [l10n.yaml](../../../l10n.yaml) | Ajouter ces options. |
| P2-3 | **Mock data FR en dur** dans `recommended_section`/`native_ad_card` (actuellement **commentés/inactifs** dans home). | recommended_section.dart:14-31, native_ad_card.dart:36-38 | Localiser/remplacer si réactivés. |

### ⚪ Informatif
- **Messages backend pass-through** : affichés tels que renvoyés (le backend reçoit `Accept-Language`) — **intentionnel** (documenté dans le handoff). À surveiller si le backend ne traduit pas.
- **Métadonnées `@` asymétriques** (248 FR vs 135 EN) : sans impact (template = `app_fr.arb`).
- **Pas de RTL** (fr/en LTR) ; **assets sans texte** → pas de localisation d'asset.
- Risque d'**overflow** des traductions EN sur layouts à largeur fixe → recoupe [audit 09](09-ui-ux-accessibilite-audit.md) (troncature).

---

## Points conformes (✅)
- **Parité ARB parfaite** : `app_fr.arb` = `app_en.arb` = **2052 clés** ; classes générées à 2052 méthodes. Aucune clé manquante.
- **46/48 patterns ICU plural** corrects (pas de concaténation manuelle `count + (singulier/pluriel)`).
- **Sélection de locale** : persistée (`SharedPreferences`), fallback plateforme → FR, `AppLocaleCache` pour accès sans contexte, **testée** (`app_locale_test.dart`).
- **`Accept-Language` dynamique** : `LocaleHeaderInterceptor` ([dio_client.dart:92-97](../../../lib/config/dio_client.dart#L92-L97)) ; en-têtes forcés `fr` supprimés des datasources blog/events.
- **`initializeDateFormatting`** fr_FR + en_US au boot ; helpers `context.appDateFormat`/`appCompactNumberFormat` adoptés largement.
- **`ApiResponseHandler` localisé** (timeout/connexion via clés ARB).
- **Chaînes en dur quasi-nulles** dans le code actif (1 seul fichier fautif) ; widgets partagés/dialogs/SnackBars localisés ; **switch de langue** dans les réglages avec rebuild immédiat.
- **Workflow documenté** ([docs/I18N_MOBILE_ROLLOUT_HANDOFF.md](../../I18N_MOBILE_ROLLOUT_HANDOFF.md)).

## Annexes
- Source : agent code-explorer (180 outils, ~1152 s). Réconciliation : « P0 » (chaîne FR en dur, 1 widget) → P1 (portée limitée).
