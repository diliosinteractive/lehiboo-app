# Plan 02 — Qualité de code & conventions

Objectif : mesurer la dette de qualité (lints, dead code, logs, duplication, god files)
et la conformité aux conventions du `CLAUDE.md`.

## Périmètre
Tout `lib/` **hors fichiers générés** (`*.g.dart`, `*.freezed.dart`, `lib/l10n/generated/`).

## Risques connus (baseline)
- ⚠️ **88 fichiers** contiennent `print`/`debugPrint` (logs non structurés en prod).
- ⚠️ **18** `TODO`/`FIXME`/`HACK`.
- ⚠️ **God widgets** : `filter_bottom_sheet.dart` (107 Ko), `new_conversation_form.dart` (81 Ko), `airbnb_search_sheet.dart` (81 Ko), `event_qa_section.dart` (988 lignes).
- ⚠️ `analysis_options.yaml` minimal (`flutter_lints` seul, aucune règle additionnelle activée) alors que `custom_lint`/`riverpod_lint` sont en dev_dependencies.

## Checklist
- [ ] **`flutter analyze` = 0 erreur/warning** ; recenser et catégoriser les `info`.
- [ ] **`dart run custom_lint`** : exploiter `riverpod_lint` (providers non disposés, mauvais usage de `ref`).
- [ ] **Lints durcis** : envisager d'activer un set strict (ex. `flutter_lints` → règles additionnelles : `prefer_const_constructors`, `avoid_print`, `unawaited_futures`, `prefer_single_quotes`, `require_trailing_commas`).
- [ ] **Logs** : remplacer `print`/`debugPrint` par le `logger` (déjà en dépendance) avec niveaux ; garantir l'absence de logs en release (cf. plan 05 pour données sensibles).
- [ ] **`// ignore` justifiés** : recenser les `// ignore`/`// ignore_for_file` dans le code **non généré** et vérifier qu'ils sont motivés.
- [ ] **Dead code** : widgets/fonctions/fichiers non référencés ; `darkTheme` défini mais `themeMode: ThemeMode.light` forcé ([main.dart:360](../../../lib/main.dart#L360)).
- [ ] **God files** : lister les fichiers > 600 lignes et proposer un découpage (sous-widgets, extensions, parties).
- [ ] **Duplication** : blocs copiés (cartes events, états loading/error, parsing JSON répété — voir les helpers `_parseInt/_parseBool` dupliqués entre DTO).
- [ ] **Conventions `CLAUDE.md`** : PascalCase classes, snake_case fichiers, camelCase membres ; cohérence respectée.
- [ ] **Formatage** : `dart format --set-exit-if-changed` propre.
- [ ] **Commentaires obsolètes / commentés** : code mort en commentaire (ex. bloc `fonts:` dans `pubspec.yaml`).
- [ ] **Gestion des `TODO`** : convertir en tickets, dater, ou supprimer.

## Commandes / mesures
```bash
flutter analyze
dart run custom_lint
dart format --output=none --set-exit-if-changed lib

# Logs non structurés (hors générés)
rg -n "debugPrint\(|(^|[^a-zA-Z.])print\(" lib \
  --glob '!*.g.dart' --glob '!*.freezed.dart' --glob '!**/generated/**'

# Fichiers les plus volumineux (candidats god files)
fd -e dart . lib -x wc -l {} | sort -rn | head -30   # ou: find lib -name '*.dart' -printf '%s %p\n' | sort -rn

# ignore non justifiés (hors générés)
rg -n "// ignore" lib --glob '!*.g.dart' --glob '!*.freezed.dart' --glob '!**/generated/**'

# TODO/FIXME
rg -n "TODO|FIXME|HACK|XXX" lib --glob '!*.g.dart' --glob '!*.freezed.dart'
```

## Livrable
Top 30 des god files avec plan de découpage, plan de migration `print → logger`, liste d'`// ignore` à traiter, proposition de `analysis_options.yaml` durci.
