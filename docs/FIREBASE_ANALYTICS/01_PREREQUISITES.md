# Étape 1 — Pré-requis & config native

## 1.1 Audit console Firebase

- Vérifier l'accès au projet **`lehiboo-77c35`** (visible dans `lib/firebase_options.dart`).
- Vérifier que la propriété **Google Analytics 4** est bien liée au projet (Project Settings → Integrations → Google Analytics). Si non liée → l'activer, c'est gratuit et indispensable.
- Vérifier la **data retention** (par défaut 2 mois GA4) → passer à **14 mois** dans GA4 Admin → Data Settings → Data Retention.
- Activer la **suppression de l'IP** côté GA4 (déjà par défaut sur les nouvelles propriétés).

## 1.2 Multi-environnement — décision à prendre

Aujourd'hui, **un seul projet Firebase** sert dev/staging/prod. Conséquence : les events des devs et de la QA polluent les KPIs de prod.

**Option A — recommandée :** créer 2 projets supplémentaires `lehiboo-dev` et `lehiboo-staging`, et générer des `firebase_options.dart` par environnement (via `flutterfire configure --project=...` avec un fichier par flavor, ou un switch dans `main.dart` basé sur `EnvConfig`).

**Option B — minimaliste :** rester sur un seul projet et utiliser une **user property `env`** (`development` / `staging` / `production`) pour filtrer dans les rapports. Plus simple, suffisant si l'usage interne est faible.

→ **À trancher avant l'étape 2.**

## 1.3 iOS — vérifications natives

Fichier : `ios/Runner/GoogleService-Info.plist` ✅ déjà présent.

À vérifier dans `ios/Runner/Info.plist` :

- **`NSUserTrackingUsageDescription`** (clé manquante = crash sur iOS 14+ dès qu'on importe AdSupport, et obligatoire pour l'IDFA si on veut un opt-in ATT propre — voir [07_CONSENT_RGPD.md](07_CONSENT_RGPD.md)).
- `FirebaseAppDelegateProxyEnabled` : laisser à `YES` (défaut). Ne pas désactiver, sinon il faut router manuellement les notifs.
- Minimum iOS : déjà à `15.5` à cause de `mobile_scanner` ([CLAUDE.md](../../CLAUDE.md)), compatible Firebase 11.x.

À vérifier dans `ios/Podfile` :

- `platform :ios, '15.5'` cohérent.
- Lancer `cd ios && pod install` après ajout éventuel d'`app_tracking_transparency`.

## 1.4 Android — vérifications natives

Fichier : `android/app/google-services.json` ✅ déjà présent.

À vérifier :

- `android/build.gradle` : plugin classpath `com.google.gms:google-services` présent.
- `android/app/build.gradle` : `apply plugin: 'com.google.gms.google-services'` en bas du fichier.
- `minSdkVersion` ≥ 21 (déjà le cas, cf. `flutter_launcher_icons` config dans [pubspec.yaml](../../pubspec.yaml)).
- Cleartext autorisé en debug ([CLAUDE.md](../../CLAUDE.md)) — n'impacte pas Analytics, mais bon à savoir.

## 1.5 Politique de confidentialité

À mettre à jour **avant** le rollout en prod (étape 9) :

- Mentionner Firebase Analytics / Google Analytics 4 comme sous-traitant.
- Indiquer la base légale (consentement explicite côté UE).
- Lister les catégories de données collectées (IDFA/AAID si ATT acceptée, événements d'usage, propriétés utilisateur).
- Lien vers la politique Google : <https://policies.google.com/privacy>.

## Critères de sortie de l'étape

- [ ] Décision multi-env actée (option A ou B).
- [ ] Accès console Firebase validé pour les 2-3 développeurs concernés.
- [ ] `NSUserTrackingUsageDescription` ajoutée dans `Info.plist` (texte fr + en).
- [ ] Politique de confidentialité mise à jour (draft validé légal).
- [ ] `flutter clean && flutter pub get && flutter run` builds OK iOS et Android.
