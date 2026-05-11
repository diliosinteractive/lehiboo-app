# Plan d'action — Migration FCM → OneSignal (Mobile Flutter)

> Plan d'action généré le **2026-05-08** suite à la spec [`MOBILE_PUSH_INTEGRATION_ONESIGNAL.md`](MOBILE_PUSH_INTEGRATION_ONESIGNAL.md). Backend Laravel déjà migré (`PUSH_DRIVER=onesignal`) — l'app mobile est encore sur **FCM** et doit basculer en une seule release.

---

## 1. État actuel — résumé

L'app utilise aujourd'hui **Firebase Cloud Messaging (FCM)**. La spec OneSignal existe mais **rien n'est implémenté côté mobile**, à l'exception de la variable `ONESIGNAL_APP_ID` déjà présente dans `.env.development`.

### Stack push actuelle

| Composant | Fichier | État |
|---|---|---|
| SDK | [`pubspec.yaml`](../pubspec.yaml) — `firebase_messaging: ^15.1.3`, `firebase_core: ^3.6.0` | ❌ FCM (à remplacer) |
| Service | [`lib/core/services/push_notification_service.dart`](../lib/core/services/push_notification_service.dart) | ❌ Tout sur `FirebaseMessaging` |
| Provider | [`lib/features/notifications/presentation/providers/push_notification_provider.dart`](../lib/features/notifications/presentation/providers/push_notification_provider.dart) | ⚠️ Logique réutilisable, mais payload backend incomplet |
| Datasource | [`lib/features/notifications/data/datasources/device_token_datasource.dart`](../lib/features/notifications/data/datasources/device_token_datasource.dart) | ⚠️ Manque `provider`, `subscription_id`, `external_user_id` |
| Deep linking | [`lib/core/services/deep_link_service.dart`](../lib/core/services/deep_link_service.dart) | ✅ Routeur par `type` déjà en place |
| Init | [`lib/main.dart`](../lib/main.dart) (Firebase ligne 89-97) | ❌ Pas d'OneSignal, pas de click-handler avant `runApp()` |
| iOS native | `ios/Runner/AppDelegate.swift`, `ios/Runner/Info.plist` | ❌ Pas de Notification Service Extension |
| Android native | `android/app/google-services.json`, `android/app/build.gradle.kts` | ⚠️ Toujours configuré pour Firebase |
| `.env` | `.env.development` ligne 23 | ✅ `ONESIGNAL_APP_ID` présent en dev / ❌ absent en `.env.production` |

### Gap analysis vs spec

| # | Item spec | Statut | Sévérité |
|---|---|---|---|
| 1 | `onesignal_flutter` dans `pubspec.yaml` | ❌ Absent | 🔴 Bloquant |
| 2 | `OneSignal.initialize()` au boot, **avant** `runApp()` | ❌ | 🔴 Bloquant |
| 3 | `OneSignal.login(user.uuid)` (binding `external_user_id`) après auth | ❌ | 🔴 Bloquant — sans ça, **0 notif ne route** |
| 4 | `OneSignal.logout()` au déconnexion | ❌ | 🔴 Bloquant |
| 5 | Click handler enregistré **avant** `runApp()` | ❌ | 🔴 Cold-start payload perdu |
| 6 | Payload `POST /device-tokens` avec `provider: "onesignal"` | ❌ | 🔴 Bloquant — backend ne peut pas distinguer |
| 7 | Payload avec `subscription_id` + `external_user_id` | ❌ | 🟠 Recommandé |
| 8 | iOS Notification Service Extension | ❌ | 🟠 Rich notifications iOS HS |
| 9 | iOS APNs certificate dans console OneSignal | ❌ (à confirmer ops) | 🟠 Bloque prod iOS |
| 10 | Subscription observer (refresh `subscription_id`) | ❌ | 🟡 Edge case |
| 11 | Permission observer | ❌ (équivalent existe via settings UI) | 🟡 Optionnel |
| 12 | `DELETE /device-tokens` au logout | ⚠️ Datasource existe, jamais appelé | 🟡 Cleanup serveur |
| 13 | Écran "Mes appareils" (`GET /device-tokens`) | ❌ Inexistant | 🟡 Feature spec §3.4 |
| 14 | Types `ticket_checked_in`, `collaboration_invite`, `event_reminder` dans le routeur | ❌ Absents | 🟢 Fallback `/notifications` OK |
| 15 | Cleanup Firebase (deps, `google-services.json`, init `main.dart`) | ❌ | 🟡 Post-migration |
| 16 | `ONESIGNAL_APP_ID` en `.env.production` | ❌ | 🟠 Bloquant build prod |
| 17 | `ONESIGNAL_APP_ID` lu via `--dart-define` ou `EnvConfig` | ❌ | 🟠 Bloquant init |

---

## 2. Questions ouvertes — à clarifier AVANT de coder

> ⚠️ Ces points peuvent invalider une partie du plan. À résoudre en priorité.

### 2.1 Endpoint device-tokens : `/auth/` ou pas ?

La spec OneSignal écrit `POST /api/v1/device-tokens` (sans `/auth/`).
Le code actuel utilise `POST /auth/device-tokens` ([`device_token_datasource.dart:95`](../lib/features/notifications/data/datasources/device_token_datasource.dart#L95)).
L'OpenAPI ([`openapi.yaml:2258`](../openapi.yaml#L2258)) confirme `/api/v1/auth/device-tokens`.
La spec antérieure [`PUSH_NOTIFICATIONS_MOBILE_SPEC.md`](PUSH_NOTIFICATIONS_MOBILE_SPEC.md) confirme aussi `/auth/`.

→ **Action :** demander au backend si l'URL change avec OneSignal. Probable que la spec OneSignal soit un raccourci d'écriture et que le bon chemin reste `/auth/device-tokens`. **Hypothèse de travail dans le plan : on garde `/auth/device-tokens`.**

### 2.2 App IDs OneSignal staging / prod

- Dev : `6292cfb4-d6d2-4338-a043-778b94affde6` (déjà en `.env.development`)
- Staging : **à fournir**
- Prod : **à fournir**

→ **Action :** récupérer les App IDs auprès du backend lead avant build prod.

### 2.3 APNs certificat uploadé en console OneSignal ?

→ **Action :** vérifier avec backend / ops avant le release iOS prod.

### 2.4 Le backend a-t-il prévu un retour 200 cosmétique pour `provider=fcm` ?

La spec §7.4 dit que oui, mais la phase canary suppose qu'on peut continuer à envoyer `provider=fcm` un certain temps. → **Confirmer délai de grâce** pour planifier la window de release mobile.

---

## 3. Plan d'action — par phases

### Phase 0 — Préparation (avant code) — ½ jour

- [ ] Confirmer endpoint `/auth/device-tokens` vs `/device-tokens` (cf. § 2.1)
- [ ] Récupérer `ONESIGNAL_APP_ID` staging + prod
- [ ] Vérifier APNs uploadé console OneSignal (backend lead)
- [ ] Créer 8 catégories Android en console OneSignal (`bookings`, `messages`, `reminders`, `alerts`, `organizations`, `collaborations`, `check_ins`, `general`) — backend ou mobile, à clarifier
- [ ] Créer une branche dédiée : `feat/onesignal-migration`

### Phase 1 — Setup SDK & native config — 1 jour

#### 1.1 Dependencies — [`pubspec.yaml`](../pubspec.yaml)
- [ ] **Ajouter** `onesignal_flutter: ^5.5.4` (ou plus récent stable)
- [ ] **Conserver temporairement** `firebase_core` + `firebase_analytics` (analytics encore utilisés)
- [ ] **Retirer** `firebase_messaging: ^15.1.3`

#### 1.2 iOS native
- [ ] Activer **Push Notifications** + **Background Modes > Remote notifications** dans `ios/Runner.xcworkspace` (Signing & Capabilities)
- [ ] Créer le target **OneSignalNotificationServiceExtension** (suivre le [guide officiel OneSignal Flutter](https://documentation.onesignal.com/docs/flutter-sdk-setup))
- [ ] Créer le target **OneSignalNotificationContentExtension** (optionnel mais recommandé pour rich media)
- [ ] Vérifier que `ios/Podfile` contient bien le `target 'OneSignalNotificationServiceExtension'` avec le post_install conforme à la doc
- [ ] Vérifier que le APNs certificate est bien présent en console OneSignal (cf. Phase 0)
- [ ] **Conserver** l'exception ATS (`NSAllowsArbitraryLoads`) pour le dev local HTTP — non lié à OneSignal mais nécessaire au reste de l'app

#### 1.3 Android native
- [ ] `android/app/build.gradle.kts` : confirmer `minSdk >= 21` (déjà OK)
- [ ] **Ne pas retirer** `google-services.json` tout de suite — `firebase_analytics` en dépend. Le retirer plus tard si on supprime aussi analytics.
- [ ] Aucune dépendance OneSignal explicite à ajouter (le plugin Flutter gère)
- [ ] `POST_NOTIFICATIONS` permission déjà présente (Android 13+) → OK

#### 1.4 Config — [`lib/core/config/env_config.dart`](../lib/core/config/env_config.dart) (à vérifier)
- [ ] Ajouter `static String get oneSignalAppId => dotenv.env['ONESIGNAL_APP_ID'] ?? '';`
- [ ] Ajouter `ONESIGNAL_APP_ID` à `.env.production` et `.env.staging` (si existe)

### Phase 2 — Refactor service push — 1 à 1,5 jour

#### 2.1 Réécrire [`lib/core/services/push_notification_service.dart`](../lib/core/services/push_notification_service.dart)

Remplacer entièrement l'implémentation `FirebaseMessaging` par `OneSignal`. Conserver l'interface publique (méthodes, callbacks) **autant que possible** pour minimiser l'impact sur le provider :

```dart
// Pseudo-API attendue
class PushNotificationService {
  Future<void> initialize();              // OneSignal.initialize + listeners
  Future<void> requestPermission();        // OneSignal.Notifications.requestPermission
  Future<void> bindUser(String userUuid);  // OneSignal.login(uuid)
  Future<void> unbindUser();               // OneSignal.logout
  Future<String?> ensureSubscriptionId();  // OneSignal.User.pushSubscription.id (avec retry)
  Future<void> unregister();
  String? get subscriptionId;              // remplace fcmToken
  bool get permissionDenied;

  Future<void> Function(String subscriptionId)? onSubscriptionReceived;
  Future<void> Function(String subscriptionId)? onSubscriptionRemoved;
}
```

Points clés :
- [ ] Renommer `fcmToken` → `subscriptionId` partout
- [ ] Renommer `onTokenReceived` / `onTokenRemoved` → `onSubscriptionReceived` / `onSubscriptionRemoved`
- [ ] Remplacer `FirebaseMessaging.onMessage` par `OneSignal.Notifications.addForegroundWillDisplayListener` (cf. spec §5.2)
- [ ] Remplacer `FirebaseMessaging.onMessageOpenedApp` par `OneSignal.Notifications.addClickListener` (cf. spec §5.1)
- [ ] Remplacer `getInitialMessage()` : OneSignal SDK gère le cold-start via le click listener si enregistré tôt → **enregistrer le listener AVANT `runApp()`**
- [ ] Ajouter `OneSignal.User.pushSubscription.addObserver` pour le subscription refresh (spec §5.4)
- [ ] Ajouter `OneSignal.Notifications.addPermissionObserver` (spec §5.3)
- [ ] **Retirer** `FlutterLocalNotificationsPlugin` pour les notifs push : OneSignal gère le foreground display via `event.notification.display()`. Garder `flutter_local_notifications` uniquement si d'autres features in-app l'utilisent (à vérifier).
- [ ] **Retirer** la création des channels Android côté Flutter — c'est OneSignal côté console qui gère via `android_channel_id` dans le payload

#### 2.2 Mettre à jour [`lib/core/services/deep_link_service.dart`](../lib/core/services/deep_link_service.dart)
- [ ] Le routing par `data['type']` reste valide (la spec OneSignal §4.1 confirme que `additionalData` contient toujours `type` + `action`)
- [ ] **Ajouter** les 3 types manquants au switch `routeForType` :
  - `ticket_checked_in` → `/vendor/events/{event_id}/check-in`
  - `collaboration_invite` → `/collaborations/invitations/{invitation_id}`
  - `event_reminder` → `/booking-detail/{booking_id}`
- [ ] **Vérifier** que le fallback "type inconnu" → `/notifications` ne crash pas (spec §4.2 « jamais de crash »)

### Phase 3 — Provider & datasource — ½ jour

#### 3.1 [`lib/features/notifications/data/datasources/device_token_datasource.dart`](../lib/features/notifications/data/datasources/device_token_datasource.dart)

- [ ] Étendre la signature `registerToken(...)` :

```dart
Future<DeviceTokenResult> registerToken({
  required String token,           // = subscriptionId pour OneSignal
  required String provider,         // 'onesignal' (NOUVEAU)
  required String platform,
  String? subscriptionId,           // recommandé par spec, identique à token
  String? externalUserId,           // user.uuid (NOUVEAU)
  String? deviceId,
  String? deviceName,
  String? appVersion,
});
```

- [ ] Ajouter les 3 champs dans le body POST :
  ```dart
  data: {
    'token': token,
    'provider': provider,
    if (subscriptionId != null) 'subscription_id': subscriptionId,
    if (externalUserId != null) 'external_user_id': externalUserId,
    'platform': platform,
    if (deviceId != null) 'device_id': deviceId,
    // ...
  }
  ```

#### 3.2 [`lib/features/notifications/presentation/providers/push_notification_provider.dart`](../lib/features/notifications/presentation/providers/push_notification_provider.dart)

- [ ] Renommer toutes les références `fcmToken` → `subscriptionId` (state, callbacks, méthodes)
- [ ] Dans `_handleAuthStateChange`, après login ⇒ appeler `pushService.bindUser(user.uuid)` AVANT `initialize()`
- [ ] Dans `unregister()`, appeler **dans cet ordre** :
  1. `tokenDataSource.unregisterToken(subscriptionId)` (DELETE backend) ← **NOUVEAU**, pas fait aujourd'hui
  2. `pushService.unbindUser()` (`OneSignal.logout()`)
  3. Reset state local
- [ ] Dans `_registerTokenWithBackend`, passer `provider: 'onesignal'` + `externalUserId: currentUser.uuid` + `subscriptionId: subscriptionId`
- [ ] Ajouter retry exponentiel sur 5xx (spec §3.1) — max 3 tentatives, backoff 1s/2s/4s

#### 3.3 [`lib/main.dart`](../lib/main.dart) — init early

- [ ] Initialiser OneSignal **AVANT** `runApp()` :
  ```dart
  // Après dotenv.load mais avant runApp()
  final oneSignalAppId = EnvConfig.oneSignalAppId;
  if (oneSignalAppId.isNotEmpty) {
    OneSignal.initialize(oneSignalAppId);
    OneSignal.Notifications.addClickListener(_handleCold StartClick);
  }
  ```
- [ ] **Conserver** `Firebase.initializeApp()` tant que `firebase_analytics` est utilisé
- [ ] Le `requestPermission()` peut rester déféré au login (comportement actuel acceptable)

### Phase 4 — Auth integration — ¼ jour

#### 4.1 [`lib/features/auth/presentation/providers/auth_provider.dart`](../lib/features/auth/presentation/providers/auth_provider.dart)

Le provider `pushNotificationProvider` écoute déjà `authProvider` — donc le binding sera automatique tant que l'étape 3.2 est faite. Vérifier :

- [ ] Au resume de l'app avec user déjà authentifié (`authState.isAuthenticated == true` au démarrage), `bindUser()` est bien appelé idempotemment
- [ ] Tester le flow login → bind → register backend
- [ ] Tester le flow logout → DELETE backend → unbind

### Phase 5 — Écran "Mes appareils" (optionnel mais recommandé) — ½ jour

> Spec §3.4. Peut être splitté en PR séparée si pression de release.

- [ ] Créer [`lib/features/profile/presentation/screens/my_devices_screen.dart`](../lib/features/profile/presentation/screens/my_devices_screen.dart)
- [ ] Provider qui lit `deviceTokenDataSource.listTokens()`
- [ ] Liste : icône plateforme + `device_name` + `app_version` + `last_used_at` + chip "Cet appareil" + bouton "Déconnecter"
- [ ] Bouton "Déconnecter de tous les appareils" → `unregisterAllTokens()`
- [ ] Ajouter une entrée dans [`lib/features/profile/presentation/screens/settings_screen.dart`](../lib/features/profile/presentation/screens/settings_screen.dart) : "Sécurité > Mes appareils"
- [ ] Ajouter la route dans [`lib/core/routing/app_router.dart`](../lib/core/routing/app_router.dart) (à vérifier)

### Phase 6 — Tests — ½ jour

#### 6.1 Tests manuels (spec §8.1)
- [ ] App lancée avec `ONESIGNAL_APP_ID` dev → `OneSignal.initialize` OK
- [ ] Login user de test → `OneSignal.login(uuid)` log visible
- [ ] Console OneSignal > Audience > Subscriptions : device apparaît avec `External ID = user.uuid`
- [ ] `POST /auth/device-tokens` retour 201 avec `provider=onesignal` (vérifier via Charles ou logs backend)
- [ ] Test push depuis console OneSignal vers `External ID = <uuid>` → notif arrive
- [ ] Tap sur notif → routing vers `additionalData.action` correct

#### 6.2 Test e2e backend (spec §8.2)
- [ ] Déclencher `BookingConfirmedNotification` côté backend → notif arrive sur device
- [ ] Tap → ouvre `/booking-detail/{id}` correctement

#### 6.3 Edge cases
- [ ] Permission denied → pas de crash, `device-tokens` non appelé
- [ ] Cold start (app killed) + tap notif → bonne route après ouverture
- [ ] Logout → plus aucune notif après
- [ ] Re-login avec même user → idempotent, pas de doublon serveur (dédup `device_id`)
- [ ] Switch user (logout user A, login user B sur même device) → user A ne reçoit plus les notifs

#### 6.4 Tests automatisés
- [ ] Mocker `OneSignal` via `MethodChannel` — assert `login()` après auth, `logout()` après déconnexion
- [ ] Mocker `Dio` — assert payload `device-tokens` contient bien `provider=onesignal`, `external_user_id`
- [ ] Test du routeur deep link : assert `data['type']='booking_confirmed'` → route `/booking-detail/{id}`

### Phase 7 — Cleanup post-validation — ¼ jour

> À faire une fois la version OneSignal validée en QA, AVANT release.

- [ ] Retirer `firebase_messaging` de `pubspec.yaml` ✓ (déjà fait en Phase 1.1)
- [ ] Retirer le code mort lié à FCM (handler background, channels Flutter, `_waitForApnsToken`, etc.)
- [ ] **Décision** sur `firebase_analytics` : si conservé, garder `firebase_core` + `google-services.json` + `GoogleService-Info.plist`. Sinon, full cleanup Firebase.
- [ ] Mettre à jour la doc projet (`CLAUDE.md` si la stack push y est mentionnée)
- [ ] Marquer la spec [`PUSH_NOTIFICATIONS_MOBILE_SPEC.md`](PUSH_NOTIFICATIONS_MOBILE_SPEC.md) comme dépréciée ou la fusionner avec la spec OneSignal

---

## 4. Estimation totale

| Phase | Effort |
|---|---|
| 0. Préparation | ½ jour |
| 1. SDK + native | 1 jour |
| 2. Refactor service | 1 à 1,5 jour |
| 3. Provider + datasource | ½ jour |
| 4. Auth integration | ¼ jour |
| 5. Écran "Mes appareils" *(optionnel)* | ½ jour |
| 6. Tests | ½ jour |
| 7. Cleanup | ¼ jour |
| **Total** | **~4 à 5 jours** (sans la phase 5 : ~3,5 à 4,5 jours) |

---

## 5. Définition de "done" (recopiée et adaptée de la spec §9)

### Setup
- [ ] `onesignal_flutter` ajouté, `firebase_messaging` retiré
- [ ] App IDs OneSignal configurés en `.env.development`, `.env.staging`, `.env.production`
- [ ] Capabilities iOS Push + Background Modes activées
- [ ] Notification Service Extension iOS créée
- [ ] APNs cert uploadé en console OneSignal *(ops)*
- [ ] 8 catégories OneSignal créées en console *(ops/backend)*

### Code
- [ ] `OneSignal.initialize()` au boot, **avant** `runApp()`
- [ ] Click listener enregistré **avant** `runApp()` pour le cold-start
- [ ] `requestPermission()` au login (ou onboarding)
- [ ] `OneSignal.login(user.uuid)` après auth + au resume si déjà authentifié
- [ ] `OneSignal.logout()` au logout
- [ ] `POST /auth/device-tokens` avec `provider=onesignal` + `external_user_id` + `subscription_id` après login + après acceptation permission
- [ ] `DELETE /auth/device-tokens` au logout (avant `OneSignal.logout()`, et avant `POST /auth/logout` côté API pour ne pas perdre le bearer)
- [ ] Mapping `data.type` → route mobile pour les 12+ types listés (les 3 manquants ajoutés)
- [ ] Fallback "type inconnu" → `/notifications` (jamais de crash)

### Test
- [ ] Test manuel push depuis console OneSignal → arrive sur device
- [ ] Test e2e `BookingConfirmedNotification` → arrive + deep link OK
- [ ] Permission denied → pas de crash
- [ ] Logout → plus de notifs

### Observabilité
- [ ] Logs `OneSignal.login` succès / échec
- [ ] Logs `POST /device-tokens` avec status code
- [ ] Sentry/Crashlytics capture les erreurs des handlers OneSignal

---

## 6. Risques & mitigation

| Risque | Probabilité | Impact | Mitigation |
|---|---|---|---|
| `subscription_id` null au moment du `POST /device-tokens` (race iOS) | Moyenne | Haut | Attendre `pushSubscription.id` non-null via `addObserver` avant le POST (spec §10 FAQ) |
| Endpoint `/auth/device-tokens` vs `/device-tokens` mal aligné backend ↔ mobile | Moyenne | Bloquant | Confirmer en Phase 0 |
| Cold-start payload perdu si listener enregistré trop tard | Élevée si oublié | Bloquant | **Listener AVANT `runApp()`** — checklist DoD |
| Anciennes versions FCM toujours en circulation après release | Élevée | Faible | Backend tourne en dual-send (déjà géré côté backend, spec §7.2) |
| APNs certificate non uploadé en console | Moyenne | Bloquant prod iOS | Vérifier en Phase 0 |
| Régression sur `firebase_analytics` lors du cleanup Firebase | Faible | Moyen | Garder `firebase_core` tant que analytics utilisé |

---

## 7. Références

- Spec OneSignal mobile : [`docs/MOBILE_PUSH_INTEGRATION_ONESIGNAL.md`](MOBILE_PUSH_INTEGRATION_ONESIGNAL.md)
- Spec FCM antérieure (à déprécier) : [`docs/PUSH_NOTIFICATIONS_MOBILE_SPEC.md`](PUSH_NOTIFICATIONS_MOBILE_SPEC.md)
- Doc OneSignal Flutter SDK : https://documentation.onesignal.com/docs/flutter-sdk-setup
- OpenAPI device-tokens : [`openapi.yaml`](../openapi.yaml) lignes 2258–2400
