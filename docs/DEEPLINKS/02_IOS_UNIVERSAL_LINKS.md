# Étape 2 — Universal Links iOS

> Objectif : déclarer que l'app `com.dilios.lehiboo` est associée au domaine `lehiboo.com` (et éventuellement `lehiboo.fr`).

---

## 1. Pré-requis

- Apple Developer Portal — récupérer le **Team ID** (format `ABCDE12345`, visible en haut à droite du portail ou dans Xcode > Signing & Capabilities).
- Le Bundle ID `com.dilios.lehiboo` doit être enregistré et avoir la capability **Associated Domains** activée (App IDs > Edit > cocher "Associated Domains").

---

## 2. Modification de `Runner.entitlements`

Fichier : [ios/Runner/Runner.entitlements](../../ios/Runner/Runner.entitlements)

Ajouter la clé `com.apple.developer.associated-domains` :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>aps-environment</key>
	<string>development</string>
	<key>com.apple.security.application-groups</key>
	<array>
		<string>group.com.dilios.lehiboo.onesignal</string>
	</array>
	<key>com.apple.developer.associated-domains</key>
	<array>
		<string>applinks:lehiboo.com</string>
		<string>applinks:www.lehiboo.com</string>
		<!-- décommenter si lehiboo.fr est utilisé en prod -->
		<!-- <string>applinks:lehiboo.fr</string> -->
		<!-- <string>applinks:www.lehiboo.fr</string> -->
	</array>
</dict>
</plist>
```

**Notes** :
- Préfixe `applinks:` obligatoire pour Universal Links.
- Ajouter aussi `www.` si le site est servi sur le sous-domaine (très probable).
- Pour le **dev**, on peut ajouter `applinks:dev.lehiboo.com` avec un `?mode=developer` (Apple permet de bypasser le cache AASA depuis iOS 14 — voir §5).

---

## 3. Variante Debug vs Release (optionnel)

Si on veut différencier les environnements pour tester sans toucher la prod, créer `Runner.Debug.entitlements` et `Runner.Release.entitlements` et les référencer dans le `xcconfig` par configuration. Pour cette première itération, **un seul fichier suffit** — on pointe sur la prod et on teste avec un staging URL si besoin.

---

## 4. Vérification Xcode

1. Ouvrir `ios/Runner.xcworkspace` dans Xcode.
2. Sélectionner la cible `Runner` > onglet **Signing & Capabilities**.
3. Vérifier que **Associated Domains** apparaît avec les entrées `applinks:lehiboo.com` etc.
4. Si non visible : `+ Capability` > **Associated Domains** > ajouter manuellement (cela synchronise avec le fichier `.entitlements`).
5. Vérifier que le Bundle ID est `com.dilios.lehiboo` et que le **Team** correspond au compte qui détient l'App ID.

---

## 5. Cache AASA pendant le développement

iOS met le fichier AASA en cache via les serveurs Apple. Pour bypasser pendant le dev :

1. Sur l'appareil : `Réglages > Développeur > Universal Links > Diagnostics` (iOS 14+) — voir l'état du domaine et forcer un retry.
2. Forcer une re-validation : désinstaller/réinstaller l'app **après** que l'AASA soit publié.
3. iOS 14+ : ajouter `?mode=developer` n'est plus nécessaire, le diagnostic intégré suffit.

---

## 6. AASA côté serveur

Le fichier AASA doit être disponible **avant** que le build avec entitlements ne soit installé. Sinon iOS marque le domaine comme "failed" et peut attendre des heures avant de retenter.

→ Spec complète du fichier dans [05_BACKEND_AASA_ASSETLINKS.md](05_BACKEND_AASA_ASSETLINKS.md).

**Validation** :

```bash
# Côté serveur, le fichier doit répondre 200 sans redirect
curl -I https://lehiboo.com/.well-known/apple-app-site-association
# Attendu : Content-Type: application/json (pas application/pkcs7-mime depuis iOS 11)

# Validateur Apple
# https://search.developer.apple.com/appsearch-validation-tool/
```

---

## 7. Test rapide

Une fois entitlements + AASA en place et l'app installée :

1. **Notes Apple** ou **Messages** (Safari ne déclenche pas les UL depuis sa propre barre d'adresse) :
   - Taper `https://lehiboo.com/events/{un-vrai-slug}` dans une note
   - Long-press le lien → option **"Ouvrir dans Le Hiboo"** doit apparaître
   - Tap normal → ouvre directement dans l'app
2. Si "Ouvrir dans Le Hiboo" n'apparaît pas :
   - Vérifier `Réglages > Développeur > Universal Links`
   - Curl l'AASA depuis le device avec un navigateur (doit charger sans erreur)
   - Vérifier la console Xcode pour les logs `swcd` (Shared Web Credentials Daemon)

---

## 8. Checklist

- [ ] Team ID récupéré
- [ ] Capability "Associated Domains" activée sur l'App ID Apple Developer
- [ ] `Runner.entitlements` mis à jour avec `applinks:lehiboo.com`
- [ ] Xcode > Signing & Capabilities affiche "Associated Domains" sans warning
- [ ] AASA publié (étape 05) avant install du build
- [ ] Test sur device physique iOS (le simulateur supporte UL depuis iOS 11 mais c'est moins fiable)
- [ ] Test cold start + warm start

---

## 9. Pièges connus

| Symptôme | Cause | Fix |
|----------|-------|-----|
| Le lien ouvre Safari au lieu de l'app | AASA pas trouvé / mauvais MIME / redirect 301 | Voir 05_BACKEND |
| L'app s'ouvre mais reste sur la home | Listener Flutter pas branché | Voir 04_FLUTTER_INTEGRATION |
| "Universal Links" n'apparaît pas dans Réglages Développeur | App jamais lancée depuis install, ou domain validé OK et caché | Lancer l'app une fois, retry |
| Échec sur TestFlight uniquement | `aps-environment=development` dans entitlements Release | Passer à `production` (autre sujet — cf. diagnostic TestFlight) |
| AASA 200 mais "swcd: not entitled" | Entitlement absent du build signé | Re-archive avec le bon provisioning profile |
