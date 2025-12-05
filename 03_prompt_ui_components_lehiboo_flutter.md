# 🎨 PROMPT_UI_COMPONENTS_LEHIBOO_FLUTTER.md
# Prompt complet pour générer le Design System & les composants UI Flutter de l'application LeHiboo

> À donner tel quel à **Google Gemini 3 Pro** pour générer un **design system Flutter complet**, cohérent, modulaire et réutilisable dans toute l'application LeHiboo.

---

# 🦉 1. CONTEXTE

LeHiboo est une application mobile Flutter dont l'objectif est d'aider les utilisateurs à **découvrir et réserver des activités locales**.

L'app doit respecter :
- une identité visuelle moderne,
- une UX propre et cohérente,
- des composants réutilisables,
- une architecture soignée et scalable.

Ce prompt demande à Gemini de créer **tout le design system Flutter** et **tous les widgets UI mutualisés**.

---

# 🎨 2. OBJECTIF DU FICHIER

Gemini doit produire :

### ✔️ Un thème Flutter complet (Material 3)
### ✔️ Une `ThemeExtension` appelée **LeHibooTokens**
### ✔️ Tous les composants UI communs (boutons, cards, tags, inputs, headers…)
### ✔️ Des widgets métier LeHiboo (EventCard, CityCard, etc.)
### ✔️ Une architecture claire sous `core/themes` et `core/widgets`

Ces composants seront utilisés par *toutes* les features (home, search, booking, events, partenaires…).

---

# 🎨 3. DESIGN SYSTEM À GÉNÉRER

## 3.1. Palette de couleurs

Gemini doit créer un fichier `colors.dart` contenant :

```dart
class HbColors {
  static const brandPrimary = Color(0xFFFF6B35);
  static const brandSecondary = Color(0xFFFF8C42);
  static const graySoft = Color(0xFFF5F5F7);
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF4B5563);
  static const white = Colors.white;
}
```

Et le thème sombre doit être dérivé logiquement.

---

## 3.2. Typographies

Créer `typography.dart` utilisant Google Fonts :

```dart
final hbTextTheme = TextTheme(
  displayLarge: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold),
  headlineMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
  titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
  bodyLarge: GoogleFonts.inter(fontSize: 16),
  bodyMedium: GoogleFonts.inter(fontSize: 14),
  labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
);
```

---

## 3.3. Spacing (Design Tokens)

Créer une classe `HbSpacing` dans `spacing.dart` :

```dart
class HbSpacing {
  final double xs;
  final double s;
  final double m;
  final double l;
  final double xl;
  final double xxl;

  const HbSpacing({this.xs=4, this.s=8, this.m=12, this.l=16, this.xl=24, this.xxl=32});
}
```

---

## 3.4. ThemeExtension : `LeHibooTokens`

Créer `lehiboo_tokens.dart` contenant :

```dart
class LeHibooTokens extends ThemeExtension<LeHibooTokens> {
  final Color brand;
  final Color brandSecondary;
  final Color graySoft;
  final HbSpacing spacing;
  final double radiusXL;

  const LeHibooTokens({
    required this.brand,
    required this.brandSecondary,
    required this.graySoft,
    required this.spacing,
    required this.radiusXL,
  });

  @override
  LeHibooTokens copyWith({...}) { ... }

  @override
  LeHibooTokens lerp(...) { ... }
}
```

---

## 3.5. Thème Flutter complet

Créer `app_theme.dart` :

- `ThemeData lightTheme`
- `ThemeData darkTheme`
- intégration `hbTextTheme`
- `ThemeExtension<LeHibooTokens>` incluse

Les boutons, cards, inputs… doivent utiliser Material 3.

---

# 🧩 4. COMPOSANTS UI À GENERER (DÉTAILLÉS)

Sous :
```
lib/core/widgets/
```

## 4.1. Boutons (HbButton)

Créer :

### `HbButton.primary()`
- Fond orange brand
- Texte blanc
- Option icône

### `HbButton.secondary()`
- Contour orange
- Texte orange

### `HbButton.tertiary()`
- Transparent
- Texte brand

Tous les boutons doivent :
- gérer l’état disabled,
- gérer la largeur (full ou auto),
- respecter radius = 16.

---

## 4.2. Cards

### `HbCard`
- légère élévation,
- radius 16,
- padding configurable.

### `HbElevatedCard`
- ombre accentuée.

### `HbOutlinedCard`
- bordure fine.

---

## 4.3. SectionHeader
Widget commun utilisé sur Home & Listings.

```dart
SectionHeader({required String title, String? actionLabel, VoidCallback? onAction});
```

Affichage :
- Titre à gauche
- Action "Voir tout" ou autre à droite

---

## 4.4. Tags & Chips

Créer :
- `HbTag(label: "Gratuit")`
- `HbTag.outlined(label)`
- `HbFilterChip`

Styles cohérents avec Material 3.

---

## 4.5. Empty / Error / Loading

Widgets :
- `HbEmptyState(title, message, action)`
- `HbErrorView(title, message, onRetry)`
- `HbShimmer` (wrapper du package shimmer)

---

## 4.6. Inputs

Créer :
- `HbTextField`
- `HbSearchField`
- `HbPhoneField`

Avec :
- décoration Material 3,
- icône leading optionnelle,
- bouton clear optionnel.

---

# 🧬 5. COMPONENTS MÉTIER LEHIBOO

## 5.1. EventCard
Affiche :
- image principale
- titre max 2 lignes
- ville + date
- badge "Gratuit" ou prix
- tags (Famille, Extérieur…)

Supporte :
- `onTap`
- placeholders images

## 5.2. ActivityListItem
Pour listes de résultats.

- image à gauche
- titre & infos à droite
- tags
- CTA flèche

## 5.3. CityCard
- image de la ville
- overlay noir léger
- nom centré
- radius XL

## 5.4. TestimonialCard
- avatar
- nom/prénom
- rôle
- texte témoignage multi-ligne

## 5.5. PartnerLogoStrip
- bande horizontale scrollable
- logos monochromes ou atténués

---

# 📦 6. API D’ACCÈS AU DS

Créer `hb_theme.dart` :

```dart
class HbTheme {
  static LeHibooTokens tokens(BuildContext context) =>
      Theme.of(context).extension<LeHibooTokens>()!;

  static HbSpacing spacing(BuildContext context) =>
      tokens(context).spacing;
}
```

Usage dans l'app :

```dart
final space = HbTheme.spacing(context).l;
final brand = HbTheme.tokens(context).brand;
```

---

# 🧪 7. TESTS À FOURNIR

Gemini doit créer :

### ✔️ tests unitaires
- `lightTheme` et `darkTheme`
- `LeHibooTokens.copyWith()` et `lerp()`

### ✔️ tests widget
- HbButton
- EventCard
- HbTag

---

# 🛠️ 8. LIVRABLE ATTENDU
Gemini doit fournir :

### 🔹 Code Dart complet pour :
- Thèmes Flutter (light/dark)
- ThemeExtension (LeHibooTokens)
- Tous les composants UI listés
- Tous les fichiers nécessaires dans `core/themes/` et `core/widgets/`

### 🔹 Aucun pseudo-code
### 🔹 Style Flutter propre & production-ready

---

# 🎯 OBJECTIF FINAL
Créer un **design system Flutter complet et cohérent**, permettant au reste du projet LeHiboo (Home, Search, Events, Booking…) d'être construit rapidement avec :
- un thème homogène,
- des composants réutilisables,
- une base UI robuste & scalable.

Ce prompt est autonome et doit pouvoir être donné directement à Gemini, qui doit produire **du code Flutter réel**, documenté et modulable.

