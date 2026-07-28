# Étape 3 — Android App Links

> Objectif : déclarer que l'app `com.dilios.lehibooexperience` traite les URLs `https://lehiboo.com/events/*` sans afficher de "chooser".

---

## 1. Pré-requis : SHA-256 du keystore

Le fichier `assetlinks.json` côté serveur contient l'empreinte SHA-256 de la clé qui signe l'APK/AAB. Sans correspondance exacte, Android refuse la vérification.

### Récupérer le SHA-256 de la clé Release

Sur le poste qui détient le keystore prod :

```bash
keytool -list -v -keystore /chemin/vers/lehiboo-release.jks -alias <alias>
# Cherche la ligne :
#   SHA256: AA:BB:CC:DD:...:99
```

### Si la signature passe par Google Play App Signing (recommandé)

Google Play re-signe les apps uploadées. Dans ce cas, c'est la **clé Google** qui compte, pas la clé locale.

1. Google Play Console > sélectionner l'app
2. **Setup > App Integrity > App signing** (ou "Intégrité de l'application")
3. Section **App signing key certificate** > copier le **SHA-256 certificate fingerprint**

Pour le **debug**, ajouter aussi le SHA-256 de `~/.android/debug.keystore` (alias `androiddebugkey`, password `android`) :

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

→ Tous les SHA-256 (debug + release + upload) doivent figurer dans `assetlinks.json`.

---

## 2. Modification de `AndroidManifest.xml`

Fichier : [android/app/src/main/AndroidManifest.xml](../../android/app/src/main/AndroidManifest.xml)

Ajouter un **second `intent-filter`** sur `MainActivity` (ne pas remplacer celui de `MAIN/LAUNCHER`) :

```xml
<activity
    android:name=".MainActivity"
    android:exported="true"
    android:launchMode="singleTop"
    ...>

    <!-- Intent filter existant (ne PAS supprimer) -->
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>

    <!-- NOUVEAU : App Links vers lehiboo.com -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" />
        <data android:host="lehiboo.com" />
        <data android:host="www.lehiboo.com" />
        <data android:pathPrefix="/events/" />
    </intent-filter>

    <!-- Si lehiboo.fr est utilisé en prod, ajouter un second bloc identique
         avec android:host="lehiboo.fr" et "www.lehiboo.fr". On ne peut PAS
         mélanger plusieurs domaines dans un seul intent-filter avec
         autoVerify="true" — il faut un bloc par domaine. -->
</activity>
```

**Points clés** :
- `android:autoVerify="true"` → Android vérifie automatiquement `assetlinks.json` à l'install
- `pathPrefix="/events/"` → ne capture **que** les URLs event, pas toute la racine
- `launchMode="singleTop"` est déjà OK (évite de créer plusieurs instances de l'activité)

---

## 3. Bonus : custom scheme (optionnel, non requis)

Si on veut supporter aussi `lehiboo://event/{slug}` pour des cas internes (push notifications custom, etc.), ajouter un troisième filter **séparé** (les schemes custom ne peuvent pas être dans un filter `autoVerify`) :

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="lehiboo" android:host="event" />
</intent-filter>
```

→ Décision : **on ne le fait pas dans cette itération**. App Links HTTPS suffit.

---

## 4. Vérification post-install

Une fois l'app installée avec le nouveau manifest **et** `assetlinks.json` publié :

```bash
adb shell pm get-app-links com.dilios.lehibooexperience
```

Sortie attendue :

```
com.dilios.lehibooexperience:
    ID: <uuid>
    Signatures: [<SHA>]
    Domain verification state:
      lehiboo.com: verified
      www.lehiboo.com: verified
```

Si `verified` → OK. Si `legacy_failure` ou `system_configured` → vérifier :
1. `assetlinks.json` est bien accessible en HTTPS sans redirect (`curl -I https://lehiboo.com/.well-known/assetlinks.json`)
2. SHA-256 du fichier matche celui de l'APK installé : `apksigner verify --print-certs app-release.apk`
3. Forcer une re-vérification : `adb shell pm verify-app-links --re-verify com.dilios.lehibooexperience`

---

## 5. Test rapide

```bash
# Lance l'app via l'URL — simule un clic depuis Gmail/Chrome
adb shell am start -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "https://lehiboo.com/events/un-vrai-slug"
```

Comportement attendu :
- App s'ouvre directement sur le détail event
- Aucun chooser "Ouvrir avec…" n'apparaît

Si un chooser apparaît : la vérification a échoué (cf. §4) → l'OS ne sait pas que `lehiboo.com` appartient à l'app.

---

## 6. Différence avec custom URL scheme

| App Links HTTPS (ce qu'on fait) | Deep Links classique / custom scheme |
|---------------------------------|--------------------------------------|
| URL = vraie page web | URL custom `lehiboo://...` |
| Vérification cryptographique via `assetlinks.json` | Aucune vérification |
| Pas de chooser | Chooser possible si plusieurs apps déclarent le scheme |
| Fallback web naturel si app absente | Erreur "page non trouvée" si app absente |
| Sécurisé (un site malveillant ne peut pas voler le scheme) | Vulnérable au spoofing |

---

## 7. Checklist

- [ ] SHA-256 release (et Google Play App Signing si applicable) récupéré
- [ ] SHA-256 debug récupéré (pour tests locaux)
- [ ] `AndroidManifest.xml` mis à jour avec le `intent-filter` HTTPS
- [ ] `assetlinks.json` publié (étape 05) avec les SHA corrects
- [ ] `adb shell pm get-app-links` retourne `verified`
- [ ] Test `adb shell am start` ouvre l'app directement
- [ ] Test depuis Gmail (envoie-toi un mail avec le lien et clique)

---

## 8. Pièges connus

| Symptôme | Cause | Fix |
|----------|-------|-----|
| Chooser "Ouvrir avec…" apparaît | Vérification échouée | `assetlinks.json` accessible ? SHA correct ? Re-verify avec adb |
| Lien ouvre Chrome, pas l'app | Idem | Idem |
| Marche en debug, pas en release | SHA Release ≠ SHA debug | Ajouter le SHA du Play Signing dans `assetlinks.json` |
| Marche pas du tout après update Android | Bug Android 12+ : `pm verify` n'est pas re-déclenché à l'update | `adb shell pm verify-app-links --re-verify <pkg>` |
| URL `https://lehiboo.com/foo` ouvre aussi l'app | Le `pathPrefix` est trop large | Vérifier qu'on a bien `pathPrefix="/events/"` (avec le `/` final) |
| `autoVerify` ignoré | Plusieurs hosts dans le même filter avec autoVerify | Splitter en plusieurs blocs (un par domaine) |
