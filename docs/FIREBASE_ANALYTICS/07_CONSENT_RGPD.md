# Étape 7 — Consentement RGPD & ATT iOS

Objectif : ne **rien** collecter avant que l'utilisateur ait dit oui. Sans ça, l'app est non conforme RGPD côté UE et risque un rejet sur l'App Store (ATT iOS).

## 7.1 Architecture du consent

```
Boot app
  └─ Firebase.initializeApp
  └─ analytics.setCollectionEnabled(false)   ← bloqué par défaut
  └─ Charger consent stocké (shared_prefs)
      ├─ granted   → setCollectionEnabled(true) + (iOS) requestTrackingAuthorization
      ├─ denied    → reste en NoopAnalyticsService
      └─ unknown   → afficher consent gate au 1er launch utile
```

## 7.2 Stockage du choix

Clé `shared_preferences` :

| Clé | Type | Valeurs |
|---|---|---|
| `analytics_consent_status` | String | `granted`, `denied`, `unknown` (défaut) |
| `analytics_consent_decided_at` | int (epoch ms) | timestamp de la décision |
| `analytics_consent_version` | int | version du texte de consent, pour re-prompter si la politique change |

Ne **pas** mettre dans `flutter_secure_storage` : aucune sensibilité, et ça doit survivre à un reset auth.

## 7.3 Consent gate — quand l'afficher

3 options, à arbitrer produit :

| Option | Timing | Pour | Contre |
|---|---|---|---|
| **A — Onboarding** | 1er launch, avant d'arriver sur la home | Conforme strict, fait disparaître la friction ensuite | Bloque la découverte de l'app |
| **B — Soft prompt après N sessions** | Au 2e ou 3e launch via bottom sheet | Moins de friction, opt-in volontaire | Pas de collecte pour les nouveaux users sur N premières sessions |
| **C — Inline** | Affiché en bandeau persistant en haut tant qu'`unknown` | Léger | Mauvaise UX si bandeau trop long |

**Recommandation : option A**, avec un texte court (1 phrase + 2 boutons "Accepter"/"Refuser" + lien politique).

## 7.4 Modal de consent — UX

- Titre court : « Aider à améliorer Le Hiboo ? »
- Corps : 2-3 lignes sur ce qu'on mesure (« usage anonyme de l'app pour améliorer les fonctionnalités »).
- Boutons équivalents visuellement (**pas de dark pattern** — exigence CNIL).
- Lien vers la politique de confidentialité.
- Pas de "X" pour fermer sans choisir → forcer la décision ou différer (mais persister `unknown`).

## 7.5 Réglages utilisateur — opt-out à tout moment

Écran Profil → Confidentialité (à créer si absent) :

- Toggle « Statistiques d'usage anonymes ».
- Au toggle off : `analytics.setCollectionEnabled(false)` + sauvegarder `denied` + remplacer le service par `NoopAnalyticsService` côté provider (override dynamique via `StateProvider<bool>`).
- Au toggle on : inverse.

⚠️ `setCollectionEnabled(false)` désactive la collecte mais **ne supprime pas** les events déjà envoyés. Pour la suppression, fournir un lien vers la procédure RGPD (DPO ou form contact).

## 7.6 iOS — App Tracking Transparency

Indispensable dès iOS 14.5. **Sans ATT acceptée → pas d'IDFA → certaines fonctionnalités GA4 (audiences cross-app, attribution Ads) sont limitées**. Analytics fonctionne quand même en mode "modeled".

### Étapes

1. Ajouter `app_tracking_transparency: ^2.0.6` dans [pubspec.yaml](../../pubspec.yaml).
2. Ajouter `NSUserTrackingUsageDescription` dans [ios/Runner/Info.plist](../../ios/Runner/Info.plist) :
   ```xml
   <key>NSUserTrackingUsageDescription</key>
   <string>Nous utilisons ces données de manière anonyme pour améliorer l'application.</string>
   ```
   Apple exige un texte centré sur le bénéfice utilisateur. Bannir « pour la pub ».
3. Appeler `AppTrackingTransparency.requestTrackingAuthorization()` **après** l'acceptation du consent maison et **après** un délai (au moins 1s post-launch ou sur action utilisateur). Apple recommande de ne pas l'appeler avant que l'app soit visible.
4. Mapper la réponse `TrackingStatus` vers la user property `ios_att_status` (`authorized`, `denied`, `restricted`, `notDetermined`).

### Lien avec Firebase

Si ATT est `denied`, Firebase n'aura pas accès à l'IDFA → GA4 utilise des estimations modélisées. **C'est OK**, ne pas désactiver Analytics pour autant.

## 7.7 Android — Consent Mode (Google)

Sur Android, pas d'ATT. Le consent maison suffit pour bloquer/débloquer la collecte via `setCollectionEnabled`.

Optionnel mais propre : implémenter le **Google Consent Mode v2** via `setConsent` :

```dart
await FirebaseAnalytics.instance.setConsent(
  adStorageConsentGranted: false,        // jamais granted, on ne fait pas de pub
  analyticsStorageConsentGranted: granted,
  adUserDataConsentGranted: false,
  adPersonalizationSignalsConsentGranted: false,
);
```

À appeler **avant** le premier event si on veut être strict.

## 7.8 Re-prompt sur changement de politique

Si on modifie la politique de confidentialité, incrémenter `analytics_consent_version` côté code. Au boot, si la version stockée est antérieure → afficher à nouveau le consent gate.

## Critères de sortie

- [ ] Consent gate affichée au 1er launch (option A).
- [ ] Toggle dans Profil > Confidentialité fonctionnel (on/off réversible).
- [ ] `NSUserTrackingUsageDescription` en place, prompt ATT s'affiche post-consent.
- [ ] Vérification manuelle : si `denied`, **aucun** event dans DebugView après 5 min d'usage.
- [ ] Politique de confidentialité publique alignée (cf. [01_PREREQUISITES.md](01_PREREQUISITES.md)).
