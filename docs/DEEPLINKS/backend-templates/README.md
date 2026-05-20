# Fichiers backend deeplinks — templates

Ces deux fichiers doivent être publiés en production **avant** que l'app
mobile ne soit installée avec les associated domains / intent-filter.
Sinon iOS/Android cachent un échec de validation pendant plusieurs heures.

---

## `apple-app-site-association`

**À publier sur** :
- `https://lehiboo.com/.well-known/apple-app-site-association`
- `https://www.lehiboo.com/.well-known/apple-app-site-association`

**Remplacer `__TEAM_ID__`** par le Team ID Apple (10 caractères, ex:
`ABCDE12345`). Visible dans Apple Developer Portal en haut à droite ou
dans Xcode > Signing & Capabilities.

**Headers HTTP requis** :
- `Content-Type: application/json`
- Pas de redirect (200 direct)
- Pas d'authentification
- `Cache-Control: public, max-age=3600` recommandé

**Important** : nom de fichier **sans extension** (pas `.json`).

---

## `assetlinks.json`

**À publier sur** :
- `https://lehiboo.com/.well-known/assetlinks.json`
- `https://www.lehiboo.com/.well-known/assetlinks.json`

**Remplacer `__SHA256_PLAY_SIGNING_OR_RELEASE_KEYSTORE__`** par le
SHA-256 du certificat qui signe l'APK distribué :

- **Si Google Play App Signing** (recommandé) : Play Console > Setup >
  App Integrity > App signing key certificate > SHA-256
- **Sinon** : `keytool -list -v -keystore release.jks -alias <alias>`

Pour les builds debug, ajouter le SHA de `~/.android/debug.keystore` dans
le même tableau `sha256_cert_fingerprints`.

**Headers HTTP requis** : identiques au AASA.

---

## Validation

```bash
# iOS
curl -I https://lehiboo.com/.well-known/apple-app-site-association
# → HTTP/2 200, content-type: application/json, pas de Location:

curl https://lehiboo.com/.well-known/apple-app-site-association | jq .
# → JSON valide

# Validator officiel Apple :
# https://search.developer.apple.com/appsearch-validation-tool/

# Android
curl -I https://lehiboo.com/.well-known/assetlinks.json
curl https://lehiboo.com/.well-known/assetlinks.json | jq .

# Sur device après install :
adb shell pm get-app-links com.dilios.lehibooexperience
# → lehiboo.com: verified
```

---

## Exemple Nginx

```nginx
location = /.well-known/apple-app-site-association {
    default_type application/json;
    alias /var/www/lehiboo/well-known/apple-app-site-association;
    add_header Cache-Control "public, max-age=3600";
}

location = /.well-known/assetlinks.json {
    default_type application/json;
    alias /var/www/lehiboo/well-known/assetlinks.json;
    add_header Cache-Control "public, max-age=3600";
}
```

Si Laravel sert ces routes, court-circuiter le framework — un middleware
qui injecte du HTML ou un CSRF token casserait la validation.
