# Plan 10 — Internationalisation (i18n / l10n)

Objectif : vérifier la couverture de la localisation, l'absence de chaînes en dur,
et la justesse des formats (dates, devises, pluriels) pour `fr` et `en`.

## Périmètre
`lib/l10n/`, `lib/core/l10n/`, `l10n.yaml`, `lib/l10n/generated/` (≈ 189 Ko fr / 180 Ko en),
`AppLocaleController`/`resolveAppLocale`, doc `docs/I18N_MOBILE_ROLLOUT_HANDOFF.md`.

## Contexte
- Setup officiel Flutter `gen-l10n` (`generate: true`, `app_localizations*.dart` générés).
- Locales supportées : `fr_FR`, `en_US` (dates initialisées pour les deux au boot).
- Un rollout i18n est en cours (handoff doc) → mesurer ce qui reste en dur.

## Risques connus / hypothèses
- ⚠️ Beaucoup de **texte français en dur** dans le code (commentaires ET strings UI), l10n introduite progressivement → couverture partielle.
- ⚠️ Locale forcée par défaut sur le français côté formats (`fr_FR`) — vérifier la cohérence avec la locale UI choisie.

## Checklist
- [ ] **Chaînes en dur** : recenser les `Text('...')`/labels littéraux non passés par `AppLocalizations` (hors logs/clés techniques).
- [ ] **Couverture clés** : parité entre `app_*_fr` et `app_*_en` (aucune clé manquante d'un côté).
- [ ] **Pluriels & genre** : usage d'ICU (`{count, plural, ...}`) là où nécessaire ; pas de concaténation manuelle.
- [ ] **Interpolation** : placeholders nommés, pas de concat de fragments traduits (ordre des mots).
- [ ] **Dates / heures** : `intl` + locale active (pas `fr_FR` codé en dur quand l'UI est en `en`).
- [ ] **Devises / nombres** : formatage prix (`NumberFormat.currency`) localisé ; cohérent avec le backend (centimes ?).
- [ ] **Sélection de langue** : `AppLocaleController` persiste et applique ; `resolveAppLocale` gère fallback plateforme correctement (testé : `app_locale_test.dart` ✅).
- [ ] **Formats régionaux** : pluriels, séparateurs, dates relatives (« il y a 2 j ») localisés.
- [ ] **Assets localisés** : images/textes légaux (`shared/legal/`) disponibles dans les deux langues.
- [ ] **RTL** : non requis (fr/en) — confirmer qu'on n'ajoute pas de complexité inutile, mais pas de layout cassant si ajout futur.
- [ ] **Workflow de traduction** : process pour ajouter une clé (arb → gen) documenté ; pas d'édition des fichiers générés.

## Commandes / mesures
```bash
# Chaînes UI potentiellement en dur (à filtrer manuellement)
rg -n "Text\('|Text\(\"|label: '|hintText: '|title: '" lib/features --glob '!*.g.dart' \
  | rg -v "AppLocalizations|context\.l10n|\.tr\(" | wc -l

# Clés présentes par langue
rg -c "=>" lib/l10n/generated/app_localizations_fr.dart
rg -c "=>" lib/l10n/generated/app_localizations_en.dart

# Locale en dur
rg -n "'fr_FR'|'en_US'|Locale\('fr'|Locale\('en'" lib --glob '!*.g.dart'

# Formatage de prix/dates
rg -n "NumberFormat|DateFormat" lib --glob '!*.g.dart'
```

## Livrable
% de chaînes localisées vs en dur (par feature), liste des clés manquantes/divergentes fr↔en, points de formatage incorrects (date/devise selon locale), checklist de complétion du rollout i18n.
