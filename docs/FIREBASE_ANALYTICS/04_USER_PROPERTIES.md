# Étape 4 — User ID & user properties

Objectif : enrichir chaque event d'attributs utilisateur pour pouvoir segmenter les rapports GA4 (par rôle, ville, locale, statut d'adhésion…).

## 4.1 `setUserId` — règles

GA4 attend un identifiant **stable, anonyme, non-PII**. On utilise l'**UUID utilisateur backend** (jamais l'email).

À brancher dans [lib/features/auth/presentation/providers/auth_provider.dart](../../lib/features/auth/presentation/providers/auth_provider.dart) :

| Évènement auth | Action |
|---|---|
| Login réussi | `analytics.setUserId(user.id)` |
| Signup terminé | `analytics.setUserId(user.id)` |
| Logout | `analytics.setUserId(null)` puis `_resetUserProperties()` |
| Force logout (401, ligne 239 de `main.dart`) | idem logout |
| Rehydration du token au boot (utilisateur déjà connecté) | `analytics.setUserId(user.id)` |

⚠️ Ne **pas** appeler `setUserId` avant le consentement (cf. [07_CONSENT_RGPD.md](07_CONSENT_RGPD.md)).

## 4.2 Catalogue de user properties

Limites Firebase : **25 user properties max** par projet, nom ≤ 24 chars, valeur ≤ 36 chars. Définir le catalogue **côté console** avant le code (Admin → Custom Definitions → User properties), sinon les valeurs partent mais ne sont pas exploitables dans les rapports.

| Nom | Source | Valeurs |
|---|---|---|
| `user_role` | `user.role` | `visitor`, `member`, `partner`, `admin` |
| `app_locale` | `appLocaleControllerProvider` | `fr`, `en` |
| `env` | `EnvConfig` | `development`, `staging`, `production` (utile si on garde 1 seul projet Firebase — cf. [01_PREREQUISITES.md](01_PREREQUISITES.md)) |
| `has_membership` | `membershipsRepository` | `true`, `false`, `unknown` |
| `home_city_slug` | profil user | slug ville ou `none` |
| `hibons_rank` | `HibonsService` | `bronze`, `silver`, `gold`, `legend` |
| `push_enabled` | `pushNotificationProvider` | `true`, `false` |
| `notif_consent` | shared prefs | `granted`, `denied`, `unknown` (cf. étape 7) |

## 4.3 Où poser les `setUserProperty`

- `user_role`, `home_city_slug`, `has_membership` : dans `auth_provider.dart` après chaque hydration de `user` (login + rehydration).
- `app_locale` : dans `appLocaleControllerProvider` à chaque changement de langue.
- `env` : une seule fois au boot dans `main.dart`, juste après l'override du provider.
- `push_enabled`, `notif_consent` : dans [push_notification_provider.dart](../../lib/features/notifications/presentation/providers/push_notification_provider.dart).
- `hibons_rank` : dans [hibons_service.dart](../../lib/features/gamification/application/hibons_service.dart) au moment du rank-up.

## 4.4 Anonymisation — règles strictes

- **Jamais** d'email, nom, prénom, téléphone, adresse, date de naissance, IBAN en property ni en event param.
- L'UUID backend est OK : non-PII tant qu'il n'est pas joignable à l'identité depuis GA4.
- Pour les coordonnées GPS de recherche (ville, lat/lng), **arrondir** ou utiliser le slug ville plutôt que les coordonnées exactes.

## 4.5 Reset à la déconnexion

Lors d'un logout, ne pas se contenter de `setUserId(null)`. Réinitialiser explicitement chaque user property à une valeur neutre :

```dart
await analytics.setUserId(null);
for (final prop in ['user_role','home_city_slug','has_membership','hibons_rank']) {
  await analytics.setUserProperty(prop, null);
}
```

Sinon la valeur précédente est "collée" au prochain compte qui se connecte sur le même device avant le prochain `setUserProperty`.

## Critères de sortie

- [ ] User properties créées dans la console GA4 (Custom Definitions).
- [ ] `setUserId` branché sur les 4 transitions auth (login, signup, logout, rehydration).
- [ ] Toutes les properties listées en 4.2 sont remplies après login dans DebugView.
- [ ] Logout vide bien le `user_id` et les properties.
