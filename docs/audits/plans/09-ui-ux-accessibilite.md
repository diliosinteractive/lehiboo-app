# Plan 09 — UI/UX & accessibilité

Objectif : vérifier la cohérence du design system, la robustesse des états d'écran
et l'accessibilité (a11y) de l'app.

## Périmètre
`lib/core/themes/`, `lib/shared/widgets/`, `lib/core/widgets/`, tous les `screens/` & `widgets/`,
`themes.json` (racine).

## Risques connus / hypothèses
- ⚠️ `darkTheme` défini mais **jamais utilisé** (`themeMode: ThemeMode.light` forcé, [main.dart:360](../../../lib/main.dart#L360)) → soit finir le dark mode, soit retirer le code mort.
- ⚠️ God widgets de formulaire/recherche → UX et maintenabilité (filter_bottom_sheet, airbnb_search_sheet, new_conversation_form).
- ⚠️ App grand public (events, réservation) → exigences a11y (lecteurs d'écran, contraste, dynamic type).

## Checklist
### Design system
- [ ] **Theme centralisé** : couleurs/typo/espacements via `ThemeData`/tokens, pas de valeurs en dur dispersées.
- [ ] **Cohérence** : boutons, cards, inputs, modals homogènes entre features.
- [ ] **Dark mode** : décision claire (compléter et activer le suivi système, ou supprimer `darkTheme`).
- [ ] **Polices** : `google_fonts` (runtime download) vs assets locaux — impact offline/perf.

### États & UX
- [ ] **États systématiques** : loading (shimmer), empty, error (avec retry), success — pour chaque écran data-driven.
- [ ] **Feedback** : SnackBars/toasts (`PetitBooToast`, Hibons SnackBars) cohérents et non bloquants.
- [ ] **Navigation** : back/deeplink cohérents, bottom nav, pas d'écrans orphelins.
- [ ] **Formulaires** : validation claire (`flutter_form_builder`), messages d'erreur localisés, gestion clavier (scroll, `resizeToAvoidBottomInset`).
- [ ] **Responsive** : petits écrans, grands écrans/tablettes, `SafeArea`, notch.

### Accessibilité
- [ ] **Semantics** : `Semantics`/`semanticLabel` sur icônes-boutons, images informatives, éléments custom.
- [ ] **Tap targets** ≥ 48×48 dp.
- [ ] **Contraste** : ratio AA (texte sur orange `#FF601F`, sur images du hero).
- [ ] **Text scaling** : l'UI ne casse pas à `textScaleFactor` élevé (pas de hauteurs fixes qui tronquent).
- [ ] **Focus / ordre de lecture** : ordre logique pour TalkBack/VoiceOver.
- [ ] **QR / billets** : luminosité (`screen_brightness`) et lisibilité ; alternative si scan impossible.
- [ ] **Médias** : sous-titres/alternatives pour stories vidéo si pertinent ; pas d'info uniquement par la couleur.

## Commandes / mesures
```bash
# Couleurs/tailles en dur (hors theme)
rg -n "Color\(0xFF|EdgeInsets\.all\(\d|fontSize: \d" lib/features --glob '!*.g.dart' | wc -l

# Semantics présents ?
rg -n "Semantics\(|semanticLabel|excludeSemantics" lib --glob '!*.g.dart' | wc -l

# Images sans description
rg -n "Image\.|CachedNetworkImage\(|SvgPicture" lib --glob '!*.g.dart' | wc -l

# Usage du dark theme
rg -n "darkTheme|ThemeMode\." lib
```
+ Audit manuel avec TalkBack (Android) / VoiceOver (iOS) et l'Accessibility Inspector ; Flutter `flutter run` + « Toggle accessibility ».

## Livrable
État du design system (tokens vs valeurs en dur), décision dark mode, matrice écran × états (loading/empty/error), rapport a11y (Semantics manquants, contrastes hors AA, tap targets, comportement text scaling).
