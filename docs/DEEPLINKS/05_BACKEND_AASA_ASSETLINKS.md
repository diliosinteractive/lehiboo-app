# Étape 5 — Fichiers backend (AASA + assetlinks.json)

> Owner principal : équipe backend / web. **Cette étape doit être livrée AVANT de publier un build avec entitlements/intent-filter.**

---

## 1. Fichier `apple-app-site-association` (iOS)

### URL de publication

```
https://lehiboo.com/.well-known/apple-app-site-association
```

**Et** si www. est utilisé :

```
https://www.lehiboo.com/.well-known/apple-app-site-association
```

### Contenu

```json
{
  "applinks": {
    "details": [
      {
        "appIDs": ["TEAMID12AB.com.dilios.lehiboo"],
        "components": [
          {
            "/": "/events/*",
            "comment": "Détail d'un event partagé"
          }
        ]
      }
    ]
  }
}
```

**À remplacer** :
- `TEAMID12AB` → vrai Team ID Apple (10 caractères alphanumériques, en MAJUSCULES)
- Le format est `<TEAMID>.<BUNDLE_ID>` séparé par un point

**Si plusieurs apps partagent le domaine** (ex: app `lehiboo` + future `lehiboo-vendor`) : ajouter chaque appID dans le tableau `appIDs`.

### Exigences serveur (critiques)

| Exigence | Détail |
|----------|--------|
| Protocole | **HTTPS uniquement**, certificat valide (pas auto-signé en prod) |
| Méthode | `GET 200` direct, **aucune redirection** (301/302 = échec) |
| `Content-Type` | `application/json` (depuis iOS 11 ; ne pas mettre `application/pkcs7-mime`) |
| Pas de BOM | Le fichier doit être en UTF-8 sans BOM |
| Pas d'auth | `curl https://...` sans token doit retourner le JSON |
| Taille | < 128 Ko |
| Cache | `Cache-Control: max-age=3600` recommandé (Apple cache de toute façon côté serveurs Apple) |

### Validation

```bash
# 1. Réponse directe sans redirect
curl -I https://lehiboo.com/.well-known/apple-app-site-association
# HTTP/2 200
# content-type: application/json

# 2. Contenu valide
curl https://lehiboo.com/.well-known/apple-app-site-association | jq .

# 3. Validator officiel Apple
# https://search.developer.apple.com/appsearch-validation-tool/

# 4. Validator tiers (plus verbeux)
# https://branch.io/resources/aasa-validator/
```

### Nginx — exemple de location

```nginx
location = /.well-known/apple-app-site-association {
    default_type application/json;
    alias /var/www/lehiboo/well-known/apple-app-site-association;
    add_header Cache-Control "public, max-age=3600";
}
```

---

## 2. Fichier `assetlinks.json` (Android)

### URL de publication

```
https://lehiboo.com/.well-known/assetlinks.json
```

**Et** si www. est utilisé :

```
https://www.lehiboo.com/.well-known/assetlinks.json
```

### Contenu

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.dilios.lehibooexperience",
      "sha256_cert_fingerprints": [
        "AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99"
      ]
    }
  }
]
```

**À remplacer** :
- Le SHA-256 doit être celui de la clé qui signe l'APK **distribué** :
  - Si signing manuel : SHA-256 du keystore release local
  - **Si Google Play App Signing** (recommandé) : SHA-256 dans Play Console > App Integrity (cf. [03_ANDROID_APP_LINKS.md](03_ANDROID_APP_LINKS.md))
- Pour les builds debug, ajouter un second objet dans le tableau avec le SHA-256 de `debug.keystore`

### Plusieurs SHA dans le même fichier

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.dilios.lehibooexperience",
      "sha256_cert_fingerprints": [
        "AA:BB:...:99",   // Play Signing (prod)
        "11:22:...:00"    // Upload key
      ]
    }
  }
]
```

Ne pas créer deux objets pour le même `package_name` — utiliser un seul objet avec un tableau de SHA.

### Exigences serveur

Identiques au AASA :
- HTTPS direct, pas de redirect
- `Content-Type: application/json`
- Aucune auth

### Validation

```bash
# 1. Réponse OK
curl -I https://lehiboo.com/.well-known/assetlinks.json

# 2. Validator Google (tester avec l'app installée)
# https://developers.google.com/digital-asset-links/tools/generator

# 3. Vérifier ce que voit Android sur le device
adb shell pm get-app-links com.dilios.lehibooexperience
```

### Nginx — exemple

```nginx
location = /.well-known/assetlinks.json {
    default_type application/json;
    alias /var/www/lehiboo/well-known/assetlinks.json;
    add_header Cache-Control "public, max-age=3600";
}
```

---

## 3. Si plusieurs domaines (lehiboo.com + lehiboo.fr)

Chaque domaine doit servir **son propre** AASA et `assetlinks.json` aux mêmes URLs `/.well-known/...`. Le contenu peut être identique. Ne PAS utiliser de redirect entre `.com` et `.fr` pour ces fichiers — ça casse la vérification iOS.

---

## 4. Pièges de déploiement

| Erreur | Symptôme | Fix |
|--------|----------|-----|
| Fichier servi via Laravel route (pas statique) | iOS reçoit du HTML wrapper / CSRF | Servir le fichier en statique pur, en court-circuitant le framework |
| Redirect `lehiboo.com` → `www.lehiboo.com` | iOS valide via le path final, certains versions cassent | Servir le fichier sur les deux hosts directement |
| `Content-Type: text/plain` | Apple ignore | Forcer `application/json` |
| BOM UTF-8 en début de fichier | JSON parsing fail | Sauver le fichier sans BOM |
| Auth Basic / WAF qui bloque les bots | Apple/Google ne peuvent pas lire | Whitelister `/.well-known/*` |
| `apple-app-site-association.json` (avec `.json`) | Apple ne le trouve pas | **Nom exact** sans extension |

---

## 5. Workflow de déploiement recommandé

1. Backend pousse `apple-app-site-association` et `assetlinks.json` en prod
2. Vérifier les deux fichiers via `curl` + validators
3. Attendre 10 min (cache CDN éventuel)
4. Build mobile avec entitlements/intent-filter et install sur device de test
5. Vérifier `adb shell pm get-app-links` (Android) et Réglages Développeur (iOS)
6. Si OK → merger la PR mobile et lancer release

**Important** : si l'ordre est inversé (build mobile installé avant AASA publié), iOS mémorise un échec pour ce domaine et peut attendre plusieurs heures avant de retenter. La seule solution rapide est de désinstaller/réinstaller l'app après publication de l'AASA.

---

## 6. Checklist

- [ ] AASA généré avec le bon Team ID + Bundle ID
- [ ] AASA accessible sans redirect, MIME `application/json`
- [ ] `assetlinks.json` généré avec les SHA-256 prod (+ debug si besoin)
- [ ] `assetlinks.json` accessible sans redirect, MIME `application/json`
- [ ] Validateurs Apple + Google passent
- [ ] Documenté dans le runbook backend (qui regénère ces fichiers si on change de keystore ou ajoute une 2e app ?)
- [ ] Domaines secondaires (`www.`, `.fr` si applicable) couverts
