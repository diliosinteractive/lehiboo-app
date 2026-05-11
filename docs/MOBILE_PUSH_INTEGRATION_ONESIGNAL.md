# Spec — Intégration Push Notifications OneSignal (Mobile Flutter)

> Spec d'intégration pour l'app mobile Flutter. Le backend Laravel est déjà migré vers OneSignal (`PUSH_DRIVER=onesignal`). Cette spec décrit ce que l'app mobile doit faire pour recevoir les notifications.

---

## 1. Vue d'ensemble

### 1.1 Architecture cible

```
┌─────────────────────────────────────────────────────────────────┐
│                  APP MOBILE (Flutter)                            │
│                                                                  │
│  onesignal_flutter SDK                                           │
│   ├─ initialize(ONESIGNAL_APP_ID)                                │
│   ├─ requestPermission()                                         │
│   ├─ login(user.uuid)         ← external_user_id                 │
│   ├─ getSubscriptionId()       ← OneSignal Subscription ID       │
│   └─ onClick handler           ← deep linking                    │
└──────────────────┬──────────────────────────────────────────────┘
                   │ HTTPS
                   ▼
┌─────────────────────────────────────────────────────────────────┐
│              BACKEND Laravel (api.lehiboo.com)                   │
│                                                                  │
│  POST /api/v1/device-tokens                                      │
│   { provider: "onesignal", token: <subscription_id>,             │
│     subscription_id: <uuid>, external_user_id: <user.uuid>,      │
│     platform: "ios"|"android", ... }                             │
│                                                                  │
│  → stocké dans device_tokens                                     │
│  → utilisé pour fan-out via OneSignal REST API                  │
└─────────────────────────────────────────────────────────────────┘
                   ▲
                   │
┌─────────────────────────────────────────────────────────────────┐
│              ONESIGNAL (https://api.onesignal.com)               │
│                                                                  │
│  POST /notifications  (depuis le backend)                        │
│   { include_aliases: { external_id: [user.uuid] }, ... }         │
│                                                                  │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### 1.2 Différences vs ancien système FCM

| Aspect | Avant (FCM direct) | Maintenant (OneSignal) |
|---|---|---|
| SDK Flutter | `firebase_messaging` | `onesignal_flutter` |
| Identifiant device | FCM token (~150 chars) | OneSignal Subscription ID (UUID) |
| Ciblage côté backend | Boucle sur les FCM tokens du user | Un appel via `external_user_id` |
| Service worker iOS | Géré par firebase-messaging | Géré par OneSignal SDK |
| Permission | `firebase_messaging.requestPermission()` | `OneSignal.Notifications.requestPermission()` |
| Auto re-registration | Manuel | Géré par le SDK OneSignal |
| Deep linking | Via `RemoteMessage.data` | Via `OSNotificationClickEvent.notification.additionalData` |

### 1.3 Compatibilité ascendante

- **Les tokens FCM existants ne sont pas portables vers OneSignal**. À la première ouverture après update mobile, l'utilisateur recevra une nouvelle demande de permission de notification (transparent si déjà accordée au système OS, mais l'app doit re-register côté OneSignal).
- Le backend continue d'accepter `provider=fcm` pendant la phase de transition pour ne pas casser les anciennes versions de l'app encore en circulation.

---

## 2. Setup SDK OneSignal Flutter

### 2.1 Dépendance

```yaml
# pubspec.yaml
dependencies:
  onesignal_flutter: ^5.5.4  # ou plus récent
```

Retirer `firebase_messaging` du `pubspec.yaml` une fois la migration terminée.

### 2.2 Configuration native

#### iOS

1. Activer **Push Notifications** + **Background Modes > Remote notifications** dans `ios/Runner.xcworkspace` (Signing & Capabilities)
2. Ajouter les **Notification Service Extension** + **Notification Content Extension** comme indiqué par la doc OneSignal Flutter ([guide officiel](https://documentation.onesignal.com/docs/flutter-sdk-setup))
3. Configurer le certificat APNs dans la console OneSignal (App Settings > iOS configuration)

#### Android

1. Côté OneSignal console : configurer Firebase Server Key (OneSignal route via FCM en backend pour Android)
2. `android/app/build.gradle` : `minSdkVersion 21` minimum
3. Pas de fichier `google-services.json` ou plugin Firebase nécessaire

### 2.3 Initialisation

```dart
// main.dart
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Idéalement à charger depuis une config par environnement (.env, --dart-define)
  const oneSignalAppId = String.fromEnvironment('ONESIGNAL_APP_ID');

  OneSignal.initialize(oneSignalAppId);

  // Demande de permission (peut être déclenchée plus tard, par ex. après onboarding)
  await OneSignal.Notifications.requestPermission(true);

  runApp(const MyApp());
}
```

| Environnement | App ID OneSignal |
|---|---|
| Dev local | `<à fournir par le backend>` |
| Staging | `<à fournir>` |
| Production | `<à fournir>` |

> Les App IDs ne sont **pas** des secrets (publics), mais utiliser un App ID séparé par environnement pour éviter de polluer les analytics prod avec du trafic dev.

### 2.4 Login / Logout — binding `external_user_id`

C'est le point **le plus critique** de l'intégration : OneSignal route les notifs par `external_user_id` (= `users.uuid` côté backend). Sans ce binding, **l'utilisateur ne reçoit aucune notification ciblée**.

```dart
// Au login (après réponse OK de POST /auth/login)
await OneSignal.login(currentUser.uuid);

// Au logout
await OneSignal.logout();
```

**Idempotent** : `login()` peut être appelé plusieurs fois pour le même user sans effet de bord. Appeler à chaque démarrage d'app si l'utilisateur est déjà authentifié (par ex. dans un `AppStartupService`).

---

## 3. Contrat backend

### 3.1 Enregistrement du device

**Endpoint** : `POST /api/v1/device-tokens`

**Auth** : `Authorization: Bearer {sanctum_token}`

**Payload** :

```json
{
  "token": "11111111-1111-1111-1111-111111111111",
  "subscription_id": "11111111-1111-1111-1111-111111111111",
  "external_user_id": "abcd-1234-...",
  "provider": "onesignal",
  "platform": "ios",
  "device_id": "iphone-15-pro-john-doe",
  "device_name": "iPhone 15 Pro",
  "app_version": "2.4.1"
}
```

| Champ | Requis | Description |
|---|---|---|
| `token` | ✅ | OneSignal Subscription ID (UUID). Récupéré via `OneSignal.User.pushSubscription.id` |
| `subscription_id` | recommandé | Identique à `token` pour OneSignal. Stocké séparément pour permettre des évolutions futures |
| `external_user_id` | recommandé | `currentUser.uuid`. Permet au backend de fan-outer côté OneSignal sans stocker tous les Subscription IDs |
| `provider` | ✅ | `"onesignal"` (pendant la transition, l'API accepte aussi `"fcm"` pour les anciennes versions) |
| `platform` | ✅ | `"ios"` ou `"android"` |
| `device_id` | optionnel | Identifiant stable du device. Permet la dédup (cf. § 3.2) |
| `device_name` | optionnel | Nom modèle, affiché dans les paramètres "Mes appareils" |
| `app_version` | optionnel | Version de l'app (semver) — utile pour l'observabilité |

**Réponse 201 Created** :

```json
{
  "success": true,
  "message": "Token de notification enregistré.",
  "data": {
    "uuid": "<server-side device_token uuid>",
    "platform": "ios",
    "provider": "onesignal",
    "device_name": "iPhone 15 Pro",
    "is_active": true
  }
}
```

**Réponse 200 OK (mise à jour)** : si un device avec le même `(user_id, device_id, platform, provider)` existait déjà, le serveur met à jour le token et renvoie 200 avec `"message": "Token de notification mis à jour."`.

**Erreurs** :

| Code | Cas | Action mobile |
|---|---|---|
| 401 | Token Sanctum invalide/expiré | Rediriger vers login |
| 422 | Validation échouée (platform inconnu, provider non listé) | Loguer, ne pas bloquer l'utilisateur |
| 5xx | Erreur serveur | Retry avec backoff exponentiel (max 3 tentatives), puis échouer silencieusement |

### 3.2 Quand appeler `POST /device-tokens` ?

À l'un de ces moments (idempotent par dédup serveur sur `(user_id, device_id, platform, provider)`) :

1. **Après login réussi**, immédiatement après `OneSignal.login()`
2. **Après acceptation de la permission notification** (si demandée plus tard que le login)
3. **Au resume de l'app** si le `subscription_id` a changé (rare mais possible — OneSignal peut renouveler l'ID lors de réinstallations)
4. **Sur changement de version** (mise à jour `app_version`)

### 3.3 Suppression du device

**Au logout** :

```dart
// 1. Côté OneSignal
await OneSignal.logout();

// 2. Côté backend (optionnel mais recommandé pour ne plus apparaître dans la liste "Mes appareils")
await api.delete(
  '/api/v1/device-tokens',
  body: { 'token': subscriptionId },
);
```

**Suppression d'un device** depuis l'écran "Mes appareils" : `DELETE /api/v1/device-tokens/{uuid}` avec l'UUID server-side reçu à l'enregistrement.

**Logout de tous les devices** : `DELETE /api/v1/device-tokens/all` (utile pour le bouton "Se déconnecter de tous mes appareils").

### 3.4 Liste des devices enregistrés

`GET /api/v1/device-tokens` retourne la liste des devices actifs du user :

```json
{
  "success": true,
  "data": [
    {
      "uuid": "...",
      "platform": "ios",
      "provider": "onesignal",
      "device_name": "iPhone 15 Pro",
      "app_version": "2.4.1",
      "is_active": true,
      "last_used_at": "2026-05-08T14:23:18+00:00",
      "created_at": "2026-04-12T09:00:00+00:00"
    }
  ]
}
```

Utilisé par l'écran "Sécurité > Mes appareils".

---

## 4. Format des notifications reçues

### 4.1 Structure générale

OneSignal envoie le payload dans le champ `additionalData` (Flutter SDK). Le backend respecte un schéma stable :

```dart
{
  "type": "<notification_type>",        // discriminant
  "action": "<deep-link path>",          // chemin pour navigation
  // ... champs additionnels par type
}
```

### 4.2 Catalogue des types

> Toutes les notifications respectent ce schéma. Le champ `type` est le **discriminant** utilisé par le router de navigation mobile.

| `type` | Champs `data` additionnels | `action` (deep link) | Catégorie OneSignal |
|---|---|---|---|
| `booking_confirmed` | `booking_id`, `booking_reference` | `/bookings/{booking_id}` | `bookings` |
| `new_booking` | `booking_id`, `event_id` | `/vendor/bookings/{booking_id}` | `bookings` |
| `ticket_checked_in` | `ticket_id`, `event_id` | `/vendor/events/{event_id}/check-in` | `check_ins` |
| `collaboration_invite` | `invitation_id` | `/collaborations/invitations/{invitation_id}` | `collaborations` |
| `event_reminder` | `booking_id` | `/bookings/{booking_id}` | `reminders` |
| `new_alert_events` | `alert_uuid`, `new_count` | `/search?alert={alert_uuid}` | `alerts` |
| `new_message` | `conversation_uuid`, `conversation_type` | `/messages/{conversation_uuid}` ou `/messages/support/{conversation_uuid}` | `messages` |
| `new_event_from_followed_organization` | `event_uuid`, `event_slug`, `organization_uuid` | `/events/{event_slug}` | `alerts` |
| `organization_invitation_received` | `organization_id`, `invitation_token` | `/invitations/{invitation_token}` | `organizations` |
| `organization_join_requested` | `organization_id` | `/vendor/members` | `organizations` |
| `organization_join_approved` | `organization_id`, `organization_slug` | `/organizers/{organization_slug}` | `organizations` |
| `organization_join_rejected` | `organization_id` | _(pas d'action — affichage seul)_ | `organizations` |
| `new_review` / `review_*` | `review_id`, `event_id` | `/events/{event_slug}` ou `/vendor/reviews` | `general` |
| `question_*` | `question_id`, `event_id` | `/vendor/events/{event_id}/qa` | `general` |

> **Règle d'or** : si `type` est inconnu de l'app (parce qu'elle est plus ancienne que le backend), naviguer vers la home. **Ne jamais** crasher.

### 4.3 Exemple complet — `booking_confirmed`

OneSignal payload reçu côté Flutter :

```dart
OSNotification {
  notificationId: "abc-123",
  title: "Réservation confirmée",
  body: "Votre réservation pour \"Concert Jazz\" est confirmée.",
  bigPicture: "https://cdn.lehiboo.com/events/.../cover.jpg",
  additionalData: {
    "type": "booking_confirmed",
    "booking_id": "1247",
    "booking_reference": "A1B2C3D4",
    "action": "/bookings/1247"
  },
  androidChannelId: "bookings"  // sur Android uniquement
}
```

---

## 5. Handlers — réception et clic

### 5.1 Click handler (deep linking)

C'est le handler **critique** : il décide où naviguer quand l'utilisateur tape sur la notif.

```dart
// Dans le AppStartupService (après initialisation OneSignal)
OneSignal.Notifications.addClickListener((event) {
  final data = event.notification.additionalData;
  if (data == null) return;

  final action = data['action'] as String?;
  if (action == null) {
    // Fallback : home
    AppRouter.go('/');
    return;
  }

  // Navigation typée par le routeur de l'app
  AppRouter.go(action);
});
```

**Point d'attention** : si l'app est **terminée** au moment du clic, le handler doit être enregistré **avant** `runApp()` pour ne pas perdre le payload.

### 5.2 Foreground handler (optionnel)

Par défaut, OneSignal **n'affiche pas** les notifs quand l'app est au premier plan. Comportement recommandé : afficher quand même mais en banner discret.

```dart
OneSignal.Notifications.addForegroundWillDisplayListener((event) {
  // Pour afficher la notif système malgré le foreground :
  event.preventDefault();
  event.notification.display();

  // Ou bien : laisser un toast/snackbar maison sur l'écran courant.
});
```

### 5.3 Permission state observer

```dart
OneSignal.Notifications.addPermissionObserver((permission) {
  // permission == true → l'utilisateur vient d'accepter
  if (permission) {
    _registerDeviceTokenWithBackend();
  }
});
```

### 5.4 Subscription observer (token refresh)

Le `subscription_id` peut changer (rare mais possible). Réenregistrer côté backend si ça arrive.

```dart
OneSignal.User.pushSubscription.addObserver((state) {
  if (state.current.id != null && state.current.id != _lastKnownId) {
    _lastKnownId = state.current.id;
    _registerDeviceTokenWithBackend();
  }
});
```

---

## 6. Catégories / Channels Android

OneSignal mappe `android_channel_id` → catégorie OneSignal. Le backend envoie ces IDs dans le payload :

| Channel ID | Importance | Vibration | Son | Usage |
|---|---|---|---|---|
| `bookings` | High | ✓ | default | Confirmation, annulation |
| `messages` | High | ✓ | default | Nouveaux messages |
| `reminders` | Default | ✓ | default | J-7, J-1 |
| `alerts` | Default | ✓ | default | Alertes saved searches |
| `organizations` | Default | ✓ | default | Invitations org |
| `collaborations` | Default | ✓ | default | Invites collab |
| `check_ins` | High | ✓ | default | Vendor scan billet |
| `general` | Default | — | default | Fallback |

> Côté **OneSignal console** : créer ces 8 catégories en miroir (Settings > Push Platforms > Notification Categories) pour garantir le rendu Android.

---

## 7. Migration depuis l'ancien SDK FCM

### 7.1 Plan en une seule release

L'app passe en une fois de FCM à OneSignal — pas de double-SDK. Étapes :

1. Retirer `firebase_messaging` du `pubspec.yaml`
2. Ajouter `onesignal_flutter`
3. Supprimer le code d'init Firebase + tous les handlers `RemoteMessage`
4. Supprimer `google-services.json` (Android) et la config Firebase iOS
5. Implémenter le code de la § 2 + § 5
6. Le **backend ne change pas** : `POST /api/v1/device-tokens` accepte `provider=onesignal` depuis la migration backend (déjà déployée)

### 7.2 Pendant la transition (canary)

Tant que la version mobile OneSignal n'est pas déployée à 100 % du parc :

- Le backend tourne en mode **dual-send** : si un user a des `DeviceToken provider=fcm` (anciennes versions) **et** `provider=onesignal` (nouvelles versions), les deux drivers sont appelés
- Aucune action mobile spécifique requise — le mode hybride est géré côté backend

### 7.3 Migration utilisateur — ce que voit l'utilisateur

Au premier lancement de la nouvelle version :

1. Pas de re-prompt de permission iOS si déjà accordée précédemment
2. **Le SDK OneSignal génère un nouveau Subscription ID** (différent du FCM token)
3. L'app appelle `OneSignal.login(user.uuid)` au démarrage si l'utilisateur est authentifié
4. L'app appelle `POST /api/v1/device-tokens` pour enregistrer le nouveau Subscription ID
5. **Aucune interruption visible** côté utilisateur

### 7.4 Cleanup post-migration (côté backend, hors scope mobile)

Une fois la version OneSignal en place chez ≥ 95 % du parc, le backend supprimera FcmDriver + service-account.json. La version mobile concernée n'a rien à faire — `provider=fcm` reste accepté en réception (réponse 200 cosmétique) jusqu'à un délai grace défini par le backend.

---

## 8. Tests

### 8.1 Test manuel en dev

1. Lancer l'app avec un App ID OneSignal **dev**
2. Login avec un user de test (récupérer `users.uuid` via tinker côté backend)
3. Vérifier que `POST /api/v1/device-tokens` répond 201 avec `provider=onesignal`
4. Vérifier dans la console OneSignal (Audience > Subscriptions) qu'un device apparaît avec le bon `External ID`
5. Depuis la console OneSignal, envoyer un test push à `External ID = <user.uuid>` → la notif arrive sur le device
6. Cliquer sur la notif → vérifier le routing vers `additionalData.action`

### 8.2 Test e2e via le backend

```bash
# 1. Récupérer un sanctum token
docker compose exec api php artisan tinker --execute="echo App\Models\User::find(1)->createToken('mobile-test')->plainTextToken;"

# 2. Déclencher une vraie notif backend (qui va passer par OneSignal)
docker compose exec api php artisan tinker --execute="
\$user = App\Models\User::find(1);
\$booking = App\Models\Booking::first();
\$user->notify(new App\Notifications\BookingConfirmedNotification(\$booking));
"
```

→ La notif doit apparaître sur le device du user.

### 8.3 Tests automatisés Flutter

```dart
// test/services/push_registration_test.dart
// Mock OneSignal + http client, asserter que :
// - login() est appelé après auth
// - logout() est appelé après déconnexion
// - POST /device-tokens est appelé avec provider=onesignal
// - le click handler navigue vers data.action
```

OneSignal expose des mocks officiels via `MethodChannel` mockable.

---

## 9. Checklist mobile — definition of done

### Setup
- [ ] `onesignal_flutter` dans `pubspec.yaml`, `firebase_messaging` retiré
- [ ] App IDs configurés par environnement (dev/staging/prod) via `--dart-define`
- [ ] Capability iOS Push Notifications + Background Modes activées
- [ ] Notification Service Extension créée (iOS)
- [ ] Certificat APNs uploadé en console OneSignal

### Code
- [ ] `OneSignal.initialize()` au boot
- [ ] `requestPermission()` au bon moment (post-onboarding ou au login)
- [ ] `OneSignal.login(user.uuid)` après auth + au resume si déjà authentifié
- [ ] `OneSignal.logout()` au logout
- [ ] `POST /api/v1/device-tokens` avec `provider=onesignal` après login + après acceptation permission
- [ ] `DELETE /api/v1/device-tokens` au logout (optionnel mais recommandé)
- [ ] Click handler enregistré **avant** `runApp()` pour gérer cold start
- [ ] Mapping `additionalData.type` → route mobile pour les 12+ types listés § 4.2
- [ ] Fallback "type inconnu" → home (jamais de crash)

### Test
- [ ] Test manuel : push test depuis console OneSignal arrive sur device
- [ ] Test e2e : `BookingConfirmedNotification` déclenchée backend arrive sur device
- [ ] Deep link : tap sur notif `booking_confirmed` ouvre `/bookings/{id}`
- [ ] Permission denied : pas de crash, `device-tokens` non appelé
- [ ] Logout : plus aucune notif après logout

### Observabilité
- [ ] Logs côté app pour `OneSignal.login` succès / échec
- [ ] Logs `POST /device-tokens` succès / échec avec status code
- [ ] Crash reporter (Sentry / Crashlytics) capture les erreurs des handlers OneSignal

---

## 10. FAQ

**Q. Faut-il garder `firebase_messaging` pour les anciennes versions ?**
Non. La nouvelle release mobile passe entièrement à OneSignal. Le mode dual-send est **côté backend uniquement** — pour servir les utilisateurs encore sur d'anciennes versions de l'app qui envoient encore des FCM tokens.

**Q. Que se passe-t-il si `OneSignal.login()` est appelé alors que le SDK n'a pas encore le subscription_id ?**
Le SDK est asynchrone — `login()` setup l'alias et OneSignal le rattachera au subscription dès qu'il sera disponible. Pas de race condition à gérer côté app, mais **attendre quand même** d'avoir un `pushSubscription.id` non-null avant d'appeler `POST /device-tokens` (le backend exige `token`).

**Q. Comment tester un payload spécifique sans avoir à déclencher le scénario métier complet ?**
Console OneSignal > New Push > "Test Audience" > External ID = `<user.uuid>` + payload custom dans "Custom data (additional data)". Reproduit exactement le format backend.

**Q. Le badge iOS est-il géré ?**
Non par défaut côté backend (`badge` est null dans `PushPayload` pour la majorité des notifs). Si on veut l'activer, à coordonner backend + mobile (l'app doit aussi reset le badge à l'ouverture).

**Q. Les notifs marketing passeront-elles par ce même flow ?**
Oui techniquement, mais elles sont gérées côté **console OneSignal** (segments + campagnes), pas via le code backend. Le mobile n'a rien à faire de plus — le SDK les reçoit comme n'importe quelle notif.

**Q. Que faire si OneSignal est down ?**
Le backend logue l'erreur mais ne bloque pas le flow métier (la réservation est validée même si la notif push échoue). L'utilisateur reçoit toujours l'email + la notif in-app database.

---

## 11. Références

- [Doc OneSignal Flutter SDK](https://documentation.onesignal.com/docs/flutter-sdk-setup)
- [API Reference OneSignal](https://documentation.onesignal.com/reference)
- [docs/03-guides/MIGRATION_FCM_TO_ONESIGNAL.md](docs/03-guides/MIGRATION_FCM_TO_ONESIGNAL.md) — état de la migration côté backend
- [docs/03-guides/MOBILE_REMINDERS_API.md](docs/03-guides/MOBILE_REMINDERS_API.md) — endpoints rappels (utilise les notifs push)

## 12. Contacts

| Question | Contact |
|---|---|
| App IDs OneSignal par environnement | Backend lead |
| Configuration APNs / certificats iOS | Backend lead (uploadés en console OneSignal) |
| Endpoint backend `/device-tokens` | Voir `api/app/Http/Controllers/Api/V1/DeviceTokenController.php` |
| Format payload de notif | Voir `api/app/Services/Push/Payloads/PushPayload.php` |
