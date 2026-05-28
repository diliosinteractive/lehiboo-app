# Audit — Axe 09 UI/UX & accessibilité

Date : 2026-05-28 · Branche : `main` · Auditeur : Claude (+ agent exploration) · Plan : [09-ui-ux-accessibilite.md](../plans/09-ui-ux-accessibilite.md)

## Synthèse
- **État global : 🟠 Majeur** — l'**accessibilité est le point faible** : quasi aucune sémantique (**8 occurrences `Semantics` pour 184 fichiers UI**, 346 éléments cliquables non labellisés), **aucune gestion du text scaling**, tap targets < 48 dp, contraste insuffisant sur le gris. L'UX a de bonnes briques (HbButton, RefreshIndicator, protection double-tap) mais souffre d'**incohérence** (boutons bruts, 2 systèmes de toast) et d'**états d'erreur silencieux**.
- Constats : **0 🔴 · 7 🟠 P1 · 8 🟡 P2 · 5 🟢 P3**
- **Top 3 actions** :
  1. Campagne a11y : `Semantics`/`tooltip` sur les boutons icônes, `ExcludeSemantics` sur les images décoratives.
  2. Gérer le **text scaling** (layouts flex au lieu de hauteurs fixes) — critique sur les billets.
  3. `PopScope` sur les écrans de paiement + corriger le contraste de la nav bar.

> Réconciliation : les 2 « P0 » de l'agent (textScaler, PopScope paiement) → **🟠 P1** (gaps sérieux, pas crash/sécurité). Le swallow d'erreur `event_list` recoupe [04](04-reseau-api-donnees-audit.md)/[03](03-state-management-riverpod-audit.md).

## Chiffres a11y
| Métrique | Valeur |
|----------|-------:|
| `Semantics`/`semanticLabel` | **8** (7 fichiers) |
| `excludeFromSemantics` | **0** |
| Éléments cliquables (IconButton/InkWell/GestureDetector) | **131 + 65 + 150 = 346** |
| `tooltip:` sur IconButton | 25 (~19 %) |
| Hauteurs/largeurs en dur | **1146** (184 fichiers) |
| `textScaleFactor`/`textScaler` | **0** |
| `SafeArea` / `RefreshIndicator` / `PopScope` | 44 / 29 / **1** |
| Boutons bruts (Elevated/Text/Outlined) hors `HbButton` | **194 + 241** (100 fichiers) |

---

## Constats détaillés

### 🟠 P1 — Majeurs
| # | Constat | Fichier:ligne | Reco | Effort |
|---|---------|---------------|------|--------|
| P1-1 | **Sémantique a11y quasi absente** : 8 `Semantics` pour 346 cliquables ; icônes favori/partage/filtre/nav annoncées « bouton » sans contexte par TalkBack/VoiceOver. | favorite_button.dart:274, main_scaffold.dart:171, event_hero_gallery.dart:69 | `Semantics(label:…, button:true)`/`tooltip:` sur les boutons icônes. | L |
| P1-2 | **Aucune gestion du text scaling** : 1146 hauteurs fixes, 0 `textScaler`. À ×2 (réglage a11y courant) le texte déborde/se coupe — **grave sur les billets**. | main_scaffold.dart:170, home_categories_section.dart:74, ticket_detail_screen.dart | Layouts flex / `MediaQuery.textScalerOf`. | L |
| P1-3 | **Images décoratives non exclues** : 99 images, 0 `excludeFromSemantics` → TalkBack lit des URLs/labels vides. | event_card.dart, countdown_event_card.dart | `ExcludeSemantics` (décoratives) / `Semantics(image:true, label:altText)` (informatives). | M |
| P1-4 | **Tap targets < 48 dp** : `FavoriteButton` à 32/36 dp (WCAG 2.5.5 / Material). | event_card.dart:134, countdown_event_card.dart:309,688 | `containerSize ≥ 48`. | S |
| P1-5 | **`PopScope` absent des flows de paiement** : back Android pendant un paiement Stripe (`_isLoading`) détruit le state sans annulation. | checkout_screen.dart:139, order_cart_screen.dart, booking_payment_screen.dart:24 | `PopScope(canPop: !_isLoading)`. | S |
| P1-6 | **Contraste insuffisant** : `Colors.grey` (~#9E9E9E) à `fontSize:10` sur blanc dans la nav bar ≈ 2.5:1 (< 4.5:1 AA). | main_scaffold.dart:189, event_sticky_booking_bar.dart:237 | `HbColors.grey500` minimum. | M |
| P1-7 | **Sections home silencieuses sur erreur** : ~18 sections retournent `SizedBox.shrink()` en erreur → contenu « disparu » sans retry, indistinct du vide. | home_categories_section.dart:91, event_stories.dart:166 (… 18 fichiers) | Distinguer vide vs erreur (retry discret sur les sections principales). | M |

> Google Fonts chargées au runtime (204 usages) → risque de décalage visuel offline ([typography.dart:12](../../../lib/core/themes/typography.dart#L12)) ; `event_list` swallow les erreurs (→ état vide au lieu d'erreur). À traiter avec [04](04-reseau-api-donnees-audit.md).

### 🟡 P2 — Cohérence & robustesse
| # | Constat | Fichier:ligne |
|---|---------|---------------|
| P2-1 | Nav bar custom (`InkWell`) sans rôle « onglet »/état sélectionné a11y. | main_scaffold.dart:171-198 |
| P2-2 | **194+241 boutons bruts** contournent `HbButton` (couleurs/styles en dur) → incohérence visuelle. | favorites_screen.dart:146, checkout_screen.dart:650 |
| P2-3 | Formulaires multi-steps sans `FocusNode` chaîné/`FocusTraversalGroup` (ordre clavier aléatoire). | checkout_screen.dart, customer_register_screen.dart |
| P2-4 | Tablette/paysage : 1 seul breakpoint (`FavoritesScreen` 600 dp) ; pas de `setPreferredOrientations` → Row fixes débordent en paysage. | favorites_screen.dart:20 |
| P2-5 | **2 systèmes de feedback** : `SnackBar` (211 occ., 50 fichiers) vs `PetitBooToast` — pas de règle d'usage. | bookings_list_screen.dart, favorite_button.dart:139 |
| P2-6 | `SafeArea` sur 44/~60 écrans ; manquant sur certains Scaffold sans AppBar. | event_list_screen.dart |
| P2-7 | Troncature manquante sur des champs dynamiques (prix sticky bar, nom organisateur). | event_sticky_booking_bar.dart:267 |
| P2-8 | `resizeToAvoidBottomInset` jamais posé explicitement → vérifier que les boutons ne passent pas sous le clavier (checkout, chat). | checkout_screen.dart:140, petit_boo_chat_screen.dart |

### 🟢 P3 — Mineurs
- `loading: SizedBox.shrink()` sur 2 sections home (saut de layout — préférer skeleton).
- Luminosité billet 0.9 vs QR 1.0 (préférer 1.0 pour le scan) — ticket_detail_screen.dart:69.
- `darkTheme` déclaré mais `ThemeMode.light` forcé (confus — recoupe [02](02-qualite-code-conventions-audit.md) Q10).
- `debugPrint` de params API dans `event_list_screen` (recoupe [11](11-observabilite-crash-analytics-audit.md)).

---

## Points conformes (✅)
- **`HbButton`** (primary/secondary/tertiary) avec `isLoading` + désactivation — bien fait (mais sous-utilisé).
- **Protection double-tap** correcte sur checkout/order_cart (`onPressed: _isLoading ? null : …`).
- **`HeroSlidesCarousel`** : `VisibilityDetector` + `Semantics(image:true, label:altText)` — **modèle a11y à répliquer**.
- **`RefreshIndicator`** sur ~20 écrans listes ; **`FavoritesScreen`** breakpoint tablette 600 dp (modèle responsive).
- **`screen_brightness`** restauré dans un `finally` (robuste) ; **`PopScope`** sur le consent gate.
- États loading/error/vide présents sur les écrans majeurs (favorites, alerts, home feed) avec retry localisé.

## Annexes
- Source : agent code-explorer (75 outils, ~396 s). Réconciliations de gravité appliquées (2× P0→P1).
