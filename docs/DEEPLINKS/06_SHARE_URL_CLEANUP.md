# Étape 6 — Nettoyage des URLs de partage hard-codées

> Objectif : garantir que **l'URL partagée matche exactement le format déclaré dans l'AASA / assetlinks.json**. Si le partage envoie `https://lehiboo.fr/events/...` mais que les liens vérifiés sont sur `lehiboo.com`, le deeplink ne se déclenchera pas.

---

## 1. Sites à corriger

Le [diagnostic TestFlight](../DIAGNOSTIC_PARTAGE_EVENT_TESTFLIGHT.md) a déjà identifié les hard-codes :

| Fichier | Ligne | Problème |
|---------|-------|----------|
| [event_share_sheet.dart](../../lib/features/events/presentation/widgets/detail/event_share_sheet.dart) | ~25 | `'https://lehiboo.com/events/${event.slug}'` en fallback |
| [event_detail_screen.dart](../../lib/features/events/presentation/screens/event_detail_screen.dart) | 631 | URL hard-codée passée à `ShareButton` |
| [event_detail_screen.dart](../../lib/features/events/presentation/screens/event_detail_screen.dart) | 1174 | URL hard-codée passée à `EventGalleryFullscreen.show` |

---

## 2. Refactor : tout passe par `EnvConfig.eventShareUrl`

`EnvConfig.eventShareUrl(slug)` existe déjà ([env_config.dart:29](../../lib/config/env_config.dart#L29)). Il faut juste l'utiliser **systématiquement**.

### Avant

```dart
ShareButton(
  event: event,
  shareUrl: 'https://lehiboo.com/events/${event.slug}',
  ...
)
```

### Après

```dart
ShareButton(
  event: event,
  shareUrl: EnvConfig.eventShareUrl(event.slug),
  ...
)
```

### Si `shareUrl` est toujours dérivé du même event, supprimer le paramètre

Le `ShareButton` peut calculer l'URL en interne à partir de l'event. Si aucun callsite n'a besoin d'overrider l'URL, simplifier la signature :

```dart
class ShareButton extends StatelessWidget {
  const ShareButton({super.key, required this.event});
  final Event event;

  // shareUrl supprimé du constructeur — calculé en interne
}
```

Et dans le widget :

```dart
final url = EnvConfig.eventShareUrl(event.slug);
```

---

## 3. Gérer la variante slug vs UUID

Si pour une raison X un event n'a pas de slug (cas dégradé API), `eventShareUrl(null)` n'est pas valide. Garder un fallback explicite :

```dart
static String eventShareUrl(String? slug) {
  if (slug == null || slug.isEmpty) {
    return websiteUrl;  // home, l'utilisateur ouvrira manuellement
  }
  return '$websiteUrl/events/$slug';
}
```

À adapter selon le besoin produit.

---

## 4. Vérifier `.env.production`

Le diagnostic mentionne que `.env.production` pourrait utiliser `WEBSITE_URL=https://lehiboo.fr`.

### Action

1. Ouvrir `.env.production` (et `.env.staging`)
2. Vérifier la valeur de `WEBSITE_URL`
3. Trancher avec l'équipe :
   - Si la prod est `.com` → garder `.com`, supprimer `.fr` partout
   - Si la prod est `.fr` → l'AASA et `assetlinks.json` doivent être sur `.fr` (et ajouter `applinks:lehiboo.fr` dans l'entitlement iOS + un second `intent-filter` Android)
   - Si les deux sont valides → couvrir les deux dans les fichiers backend

**Bloquant** : on ne peut pas finaliser les étapes 02/03/05 tant que ce point n'est pas tranché.

---

## 5. Test du partage

Une fois le refactor fait :

1. Build dev → tap "Partager" sur un event
2. Coller le lien partagé dans un éditeur de texte
3. Vérifier que l'URL est exactement `{WEBSITE_URL_DE_L_ENV}/events/{slug}`
4. Cliquer le lien sur soi-même (envoie un mail / message à toi-même)
5. Le clic doit ouvrir l'app (après que AASA + assetlinks soient déployés)

---

## 6. Bonus — tracker l'origine du clic

Pour mesurer le ROI du partage, ajouter un query param `?utm_source=app_share` à l'URL de partage :

```dart
static String eventShareUrl(String slug) =>
    '$websiteUrl/events/$slug?utm_source=app_share';
```

Le query param ne casse pas le matching deeplink (le path reste `/events/{slug}`). Côté analytics, on peut décoder le param dans `DeeplinkListener._handle` :

```dart
final utmSource = uri.queryParameters['utm_source'];
ref.read(analyticsServiceProvider).logEvent(
  'deeplink_opened',
  params: {
    'source': '…',
    'path': uri.path,
    'utm_source': utmSource,
    'cold_start': coldStart,
  },
);
```

→ On peut ensuite distinguer "lien partagé par un user via l'app" vs "lien partagé sur Instagram" vs "lien dans une newsletter".

---

## 7. Checklist

- [ ] Tous les `'https://lehiboo.com/events/...'` hard-codés remplacés par `EnvConfig.eventShareUrl(...)`
- [ ] `WEBSITE_URL` tranché entre `.com` et `.fr` pour la prod
- [ ] AASA / `assetlinks.json` alignés sur le domaine choisi
- [ ] (Optionnel) `?utm_source=app_share` ajouté
- [ ] Test : URL partagée correspond pixel-perfect au format vérifié OS
