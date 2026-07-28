# Diagnostic — Partage d'événements cassé en TestFlight (iOS)

> Date : 2026-05-12
> Contexte : Le partage natif fonctionne en build de dev sur Android **et** iOS, mais ne fonctionne plus du tout une fois l'app envoyée sur TestFlight.

---

## TL;DR — Causes probables, classées

| # | Cause | Probabilité | Spécifique TestFlight ? | Effort fix |
|---|-------|-------------|-------------------------|------------|
| 1 | **`Share.share()` + architecture `FlutterSceneDelegate`** : la sheet ne trouve plus de `UIViewController` à présenter en build Release | **Très haute** | Oui (timing scène diffère entre debug et release) | Moyen |
| 2 | **`sharePositionOrigin` manquant sur iPad** → crash de l'`UIActivityViewController` | Haute (si testé sur iPad) | Non, mais souvent découvert en TestFlight | Faible |
| 3 | **API `share_plus` 10.x dépréciée** : code utilise `Share.share(...)` au lieu de `SharePlus.instance.share(ShareParams(...))` | Haute (corrélation directe avec #1) | Indirectement | Faible |
| 4 | **Pas de `PrivacyInfo.xcprivacy`** : Apple peut couper certaines APIs requises par `share_plus` en Release | Moyenne | Oui | Moyen |
| 5 | **URL partagée codée en dur `https://lehiboo.com`** alors que la prod attend `lehiboo.fr` (cf. `.env.production`) → l'utilisateur clique sur un lien mort | Moyenne — *cause perçue* | Indirectement | Faible |
| 6 | **Aucune Universal Link / URL scheme** déclarée côté iOS → le lien partagé ne ré-ouvre jamais l'app | Certaine, mais c'est un autre bug | Non | Élevé |
| 7 | **`aps-environment` = `development`** dans les entitlements (hors sujet partage, mais bloque les notifs push en TestFlight — signal d'un build mal configuré) | Certaine | Oui | Trivial |

---

## 1. Code du partage

### Fichier principal : [lib/features/events/presentation/widgets/detail/event_share_sheet.dart](../lib/features/events/presentation/widgets/detail/event_share_sheet.dart)

```dart
// L25
final url = shareUrl ?? 'https://lehiboo.com/events/${event.slug}';

// L43
await Share.share(text, subject: event.title);
```

Observations :
- Utilise `Share.share(...)` — **API dépréciée** depuis `share_plus` 10.x.
- Aucun `sharePositionOrigin` n'est passé → crash garanti sur iPad.
- Aucun `BuildContext` n'est utilisé pour calculer l'origine.

### Sites d'appel codant en dur le domaine

[lib/features/events/presentation/screens/event_detail_screen.dart:631](../lib/features/events/presentation/screens/event_detail_screen.dart#L631)
```dart
ShareButton(
  event: event,
  shareUrl: 'https://lehiboo.com/events/${event.slug}',
  ...
)
```

[lib/features/events/presentation/screens/event_detail_screen.dart:1174](../lib/features/events/presentation/screens/event_detail_screen.dart#L1174)
```dart
EventGalleryFullscreen.show(
  ...
  shareUrl: 'https://lehiboo.com/events/${event.slug}',
);
```

### Versions clés (`pubspec.yaml`)

| Paquet | Version | Note |
|--------|---------|------|
| `share_plus` | `^10.0.3` | 10.x déprécie `Share.share()` |
| `flutter_dotenv` | `^5.1.0` | Charge `.env.production` en TestFlight |

---

## 2. Cause #1 — `FlutterSceneDelegate` casse la présentation modale en Release

C'est selon nous la cause principale, et celle qui explique pourquoi **ça marche en debug mais pas en TestFlight**.

### Indice trouvé : [ios/Runner/AppDelegate.swift:5-26](../ios/Runner/AppDelegate.swift#L5-L26)

```swift
@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  // Override `window` so any SDK that walks `UIApplication.shared.delegate.window`
  // (notably flutter_stripe's iOS bridge) finds the currently-active key window
  // instead of a stale AppDelegate-owned window. Without this, on iOS 13+ scene
  // apps Stripe presents from a detached UIViewController and PaymentSheet hangs
  // with "view is not in the window hierarchy".
  ...
}
```

Et dans [ios/Runner/Info.plist:49-69](../ios/Runner/Info.plist#L49-L69) :

```xml
<key>UIApplicationSceneManifest</key>
<dict>
  ...
  <key>UISceneDelegateClassName</key>
  <string>FlutterSceneDelegate</string>
  ...
</dict>
```

### Pourquoi c'est probablement le bug

L'app utilise l'architecture **UISceneDelegate / FlutterSceneDelegate**. Sur ce modèle, `UIApplication.shared.delegate.window` peut être `nil` au moment où un plugin natif veut présenter un VC modal.

Le commentaire ci-dessus prouve que l'équipe a **déjà rencontré exactement ce bug** avec Stripe : "PaymentSheet hangs with 'view is not in the window hierarchy'". Un override de `window` a été ajouté pour Stripe.

Mais `share_plus` 10.x utilise sa propre logique pour trouver la `keyWindow` et son `rootViewController` :
- En **debug**, le timing du scene activation laisse souvent le temps à `UIApplication.shared.keyWindow` d'être valide → la sheet s'affiche.
- En **Release / TestFlight**, l'init est plus rapide et plus stricte. La keyWindow peut être `nil`, ou pointer sur un VC détaché (warmup engine) → la sheet ne s'affiche jamais.

Symptôme typique côté utilisateur : **un tap sur "Partager" ne fait rien**.

### Vérification à faire

1. Connecter un iPhone TestFlight au Mac, ouvrir **Console.app**, filtrer sur "lehiboo".
2. Taper sur le bouton partage.
3. Chercher dans les logs : `Attempt to present <UIActivityViewController> ... whose view is not in the window hierarchy` ou similaire.
4. Si oui → cause #1 confirmée.

---

## 3. Cause #2 — Crash iPad par `sharePositionOrigin` manquant

`UIActivityViewController` sur iPad **doit** être présenté en popover. Sans `sharePositionOrigin`, l'app crashe instantanément avec :

```
NSGenericException: Your application has presented a UIActivityViewController (...).
In its current trait environment, the modalPresentationStyle of a UIActivityViewController
with this style is UIModalPresentationPopover. You must provide location information ...
```

Si **au moins un testeur TestFlight est sur iPad**, c'est crash garanti.

`share_plus` 10.x permet de passer `sharePositionOrigin: Rect` à `Share.share(...)`, mais le code actuel ne le fait pas :

[lib/features/events/presentation/widgets/detail/event_share_sheet.dart:43](../lib/features/events/presentation/widgets/detail/event_share_sheet.dart#L43)
```dart
await Share.share(text, subject: event.title);
// ❌ manque sharePositionOrigin
```

---

## 4. Cause #3 — API dépréciée

Depuis `share_plus` 10.0, le pattern recommandé est :

```dart
await SharePlus.instance.share(
  ShareParams(
    text: text,
    subject: event.title,
    sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
  ),
);
```

L'ancienne API `Share.share(...)` reste fonctionnelle mais :
- elle imprime un warning au build,
- elle prend des chemins de code moins testés,
- elle est plus sensible aux bugs de scène iOS.

Migrer vers la nouvelle API règle souvent #1, #2 et #3 en même temps.

---

## 5. Cause #4 — Privacy Manifest manquant

`share_plus` (et plusieurs de ses transitives — `path_provider`, `file_selector`, `cross_file`) déclarent l'usage d'APIs à raison requise par Apple (NSPrivacyAccessedAPICategoryFileTimestamp, UserDefaults, etc.).

Aucun fichier `PrivacyInfo.xcprivacy` n'a été trouvé :

```bash
$ glob ios/**/PrivacyInfo*
No files found
```

Conséquences possibles en TestFlight / App Store :
- Apple peut renvoyer un mail "ITMS-91053" / "ITMS-91056" au moment de l'upload.
- Plus subtil : certaines API renvoient des valeurs par défaut ou échouent silencieusement en Release.

Effet sur le partage : peut faire échouer la création du fichier temporaire pour partager une image (le commit `f8ea0cf` mentionne `path_provider` pour ça), mais ici la version actuelle du `ShareButton` est text-only — donc plus *risque silencieux* qu'erreur dure.

---

## 6. Cause #5 — Domaine `lehiboo.com` codé en dur (≠ env)

`.env.production` ([.env.production:11](../.env.production#L11)) :
```env
WEBSITE_URL=https://lehiboo.fr
```

[lib/config/env_config.dart:25](../lib/config/env_config.dart#L25) :
```dart
static String get websiteUrl => dotenv.env['WEBSITE_URL'] ?? 'https://lehiboo.fr';
```

Mais le code du partage ignore complètement cette config et code en dur **`lehiboo.com`** dans 3 endroits.

Si `lehiboo.com` **n'existe pas / ne redirige pas vers `lehiboo.fr`** :
- l'utilisateur partage un message dont le lien aboutit à un 404 ou un domain parking,
- le destinataire pense que "le partage est cassé".

C'est **techniquement pas** un crash, mais c'est probablement perçu comme "le partage ne fonctionne pas" — surtout si le testeur ouvre le lien après l'avoir envoyé.

### À vérifier rapidement

```bash
curl -I https://lehiboo.com/events/test-slug
curl -I https://lehiboo.fr/events/test-slug
```

Si `lehiboo.com` ne répond pas → cause perçue n°5 confirmée.

---

## 7. Cause #6 — Aucun lien profond configuré

Même si la cause #1 était résolue, **un lien partagé ne rouvrira jamais l'app TestFlight** sur le téléphone du destinataire :

| Plateforme | Statut |
|------------|--------|
| iOS — `CFBundleURLTypes` (custom scheme `lehiboo://`) | ❌ absent ([ios/Runner/Info.plist](../ios/Runner/Info.plist)) |
| iOS — `com.apple.developer.associated-domains` (Universal Links) | ❌ absent ([ios/Runner/Runner.entitlements](../ios/Runner/Runner.entitlements)) |
| iOS — fichier `apple-app-site-association` sur `lehiboo.com/.well-known/` | À vérifier côté serveur |
| Android — intent-filters | ❌ absent ([android/app/src/main/AndroidManifest.xml](../android/app/src/main/AndroidManifest.xml)) |

Conséquence : un destinataire qui clique sur le lien partagé tombe sur le site web, **jamais** sur l'app. C'est probablement pas ce que cherchait l'utilisateur en TestFlight.

---

## 8. Cause #7 — Entitlements iOS en mode `development`

[ios/Runner/Runner.entitlements:5-6](../ios/Runner/Runner.entitlements#L5-L6) :
```xml
<key>aps-environment</key>
<string>development</string>
```

Sans rapport direct avec le partage, mais c'est un **drapeau rouge** : un build TestFlight signé avec `aps-environment=development` peut être rejeté ou avoir des comportements imprévisibles (push notifications cassées, certains plugins qui se comportent différemment selon ce flag).

À passer à `production` pour les builds TestFlight/App Store.

---

## 9. Plan de correction proposé

### Étape 1 — Fix immédiat du partage (résout #1, #2, #3)

Réécrire `ShareButton._handleShare` :

```dart
Future<void> _handleShare(BuildContext context, WidgetRef ref) async {
  HapticFeedback.lightImpact();

  final text = _buildShareText(ref);
  final box = context.findRenderObject() as RenderBox?;
  final origin = box != null
      ? box.localToGlobal(Offset.zero) & box.size
      : null;

  await SharePlus.instance.share(
    ShareParams(
      text: text,
      subject: event.title,
      sharePositionOrigin: origin,
    ),
  );

  await ref.read(gamificationApiDataSourceProvider)
      .trackEventShare(event.slug, 'native');
}
```

Et brancher le `BuildContext` dans `onTap: () => _handleShare(context, ref)`.

### Étape 2 — Centraliser l'URL via `EnvConfig`

Supprimer les 3 codes en dur de `https://lehiboo.com/...`. Remplacer par :

```dart
final url = shareUrl ?? '${EnvConfig.websiteUrl}/events/${event.slug}';
```

### Étape 3 — Corriger les entitlements

[ios/Runner/Runner.entitlements](../ios/Runner/Runner.entitlements) :

```xml
<key>aps-environment</key>
<string>production</string>
```

(en gardant `development` dans un build scheme séparé si besoin.)

### Étape 4 — Ajouter un `PrivacyInfo.xcprivacy`

Fichier `ios/Runner/PrivacyInfo.xcprivacy` à créer avec au minimum les catégories utilisées par `share_plus` / `path_provider` (file timestamp, user defaults, disk space).

### Étape 5 (séparée — autre ticket) — Universal Links

- Déclarer `applinks:lehiboo.fr` (et/ou `.com`) dans `Runner.entitlements`.
- Servir `apple-app-site-association` depuis le domaine.
- Ajouter les intent-filters App Links côté Android.

---

## 10. Comment trancher entre les causes — protocole de test

1. **Build TestFlight d'un iPhone**, brancher sur Mac, ouvrir **Console.app**.
2. Tapper sur "Partager" d'un événement.
3. Observer :
   - **Rien ne s'affiche, aucun log** → cause #1 (scene/window).
   - **Crash immédiat avec log `UIActivityViewController` + iPad** → cause #2.
   - **La sheet s'affiche mais le destinataire dit que le lien est mort** → cause #5.
   - **La sheet s'affiche mais le destinataire ne rouvre pas l'app** → cause #6 (universal links).
4. Le fix de l'**Étape 1** ci-dessus traite simultanément #1, #2, #3 et est donc le premier à tenter.

---

## Annexes

### Versions paquets pertinents
- Flutter SDK : `^3.5.4` ([pubspec.yaml:8](../pubspec.yaml#L8))
- `share_plus` : `^10.0.3`
- `flutter_dotenv` : `^5.1.0`

### Fichiers à modifier (résumé)

| Fichier | Lignes | Action |
|---------|--------|--------|
| [lib/features/events/presentation/widgets/detail/event_share_sheet.dart](../lib/features/events/presentation/widgets/detail/event_share_sheet.dart) | 25, 39-48 | Migrer vers `SharePlus.instance.share(ShareParams(...))`, passer `sharePositionOrigin`, utiliser `EnvConfig.websiteUrl` |
| [lib/features/events/presentation/screens/event_detail_screen.dart](../lib/features/events/presentation/screens/event_detail_screen.dart) | 631, 1174 | Remplacer `https://lehiboo.com` par `EnvConfig.websiteUrl` |
| [ios/Runner/Runner.entitlements](../ios/Runner/Runner.entitlements) | 5-6 | `aps-environment` → `production` pour TestFlight |
| ios/Runner/PrivacyInfo.xcprivacy | (à créer) | Privacy manifest pour `share_plus` |
| [ios/Runner/Info.plist](../ios/Runner/Info.plist) | — | Plus tard : `CFBundleURLTypes` + associated-domains pour deep linking |
