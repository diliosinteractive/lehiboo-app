import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'firebase_options.dart';
import 'core/themes/app_theme.dart';
import 'core/services/push_notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'routes/app_router.dart';
import 'config/dio_client.dart';
import 'config/env_config.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

// API Repositories
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/events/data/repositories/event_repository_impl.dart';
import 'features/events/domain/repositories/event_repository.dart';
import 'features/booking/data/repositories/api_booking_repository_impl.dart';
import 'features/booking/presentation/controllers/booking_flow_controller.dart'; // For bookingRepositoryProvider
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/favorites/domain/repositories/favorites_repository.dart';
import 'features/blog/data/repositories/blog_repository_impl.dart';
import 'features/blog/domain/repositories/blog_repository.dart';
import 'features/petit_boo/data/repositories/petit_boo_repository_impl.dart';
import 'features/petit_boo/domain/repositories/petit_boo_repository.dart';
import 'features/messages/data/repositories/messages_repository_impl.dart';
import 'features/reviews/data/repositories/reviews_repository_impl.dart';
import 'features/reviews/domain/repositories/reviews_repository.dart';
import 'features/partners/data/repositories/organizer_repository_impl.dart';
import 'features/partners/domain/repositories/organizer_repository.dart';
import 'features/memberships/data/repositories/memberships_repository_impl.dart';
import 'features/memberships/domain/repositories/memberships_repository.dart';

// Fake Repositories (for offline testing)
import 'data/repositories/fake_activity_repository_impl.dart';
import 'domain/repositories/activity_repository.dart';
import 'features/booking/data/repositories/fake_booking_repository_impl.dart';

// Providers and Storage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';

// Push Notifications
import 'features/notifications/presentation/providers/push_notification_provider.dart';
import 'features/notifications/presentation/providers/in_app_notifications_provider.dart';

// Messages realtime (Pusher WebSocket — eagerly initialised at app boot)
import 'features/messages/presentation/providers/messages_realtime_provider.dart';
// Conversation list (eagerly initialised to sync badge count and realtime events)
import 'features/messages/presentation/providers/conversations_provider.dart';
import 'features/messages/presentation/providers/vendor_conversations_provider.dart';
import 'features/messages/presentation/providers/admin_conversations_provider.dart';
import 'domain/entities/user.dart';

// Hibons session heartbeat (auto-credits 10 H after 3 min foreground/day)
import 'features/gamification/presentation/providers/session_heartbeat_provider.dart';
import 'features/gamification/application/hibons_service.dart';
import 'features/gamification/application/hibons_auth_sync.dart';
import 'features/gamification/presentation/widgets/hibons_animation_coordinator.dart';

// Vendor check-in (rehydrate active org + clear on logout)
import 'features/checkin/presentation/providers/active_organization_provider.dart';

// Configuration flag - set to false to use fake data
const bool useRealApi = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  // Load environment variables
  // Use dart-define to specify environment: --dart-define=ENV=production or --dart-define=ENV=staging
  const String environment =
      String.fromEnvironment('ENV', defaultValue: 'development');
  final String envFile = switch (environment) {
    'production' => '.env.production',
    'staging' => '.env.staging',
    _ => '.env.staging',
  };

  try {
    await dotenv.load(fileName: envFile);
    debugPrint('Loaded environment: $environment from $envFile');
  } catch (e) {
    debugPrint('Could not load $envFile, falling back to .env: $e');
    try {
      await dotenv.load(fileName: '.env');
    } catch (e2) {
      debugPrint('Could not load .env file: $e2');
    }
  }

  // Initialize Dio client
  DioClient.initialize();

  // Initialize Firebase (kept for analytics — push notifications are now
  // handled by OneSignal below).
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Initialize OneSignal BEFORE runApp() so the click listener is registered
  // in time to capture cold-start payloads (app launched from a notification
  // tap). The listener stashes the payload; PushNotificationService.initialize()
  // replays it once the DeepLinkService is built.
  final oneSignalAppId = EnvConfig.oneSignalAppId;
  if (oneSignalAppId.isNotEmpty) {
    try {
      OneSignal.initialize(oneSignalAppId);
      OneSignal.Notifications.addClickListener(oneSignalColdStartClickListener);
      markOneSignalConfigured();
      debugPrint('OneSignal initialized (app_id=$oneSignalAppId)');
    } catch (e) {
      debugPrint('OneSignal initialization failed: $e');
    }
  } else {
    debugPrint('Warning: ONESIGNAL_APP_ID not configured — push disabled');
  }

  // Initialize Stripe
  final stripeKey = EnvConfig.stripePublishableKey;
  if (stripeKey.isNotEmpty) {
    Stripe.publishableKey = stripeKey;
    // Required on iOS to prevent PaymentSheet hangs during the Apple Pay
    // capability check, even when Apple Pay isn't enabled. Use a stable
    // placeholder; replace with a real Apple-registered ID if/when Apple
    // Pay is enabled.
    Stripe.merchantIdentifier = 'merchant.com.lehiboo.app';
    try {
      await Stripe.instance.applySettings();
      debugPrint('Stripe initialized successfully');
    } catch (e) {
      debugPrint('Stripe initialization failed: $e');
    }
  } else {
    debugPrint('Warning: Stripe publishable key not configured');
  }

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Container Riverpod explicite pour permettre à HibonsService (singleton)
  // de lire l'état depuis l'intercepteur Dio (qui n'a pas de Ref).
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      ...(useRealApi ? _getRealApiOverrides() : _getFakeDataOverrides()),
    ],
  );

  HibonsService.instance.attach(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LeHibooApp(),
    ),
  );
}

/// Real API repositories - connects to LeHiboo WordPress API v2
List<Override> _getRealApiOverrides() {
  return [
    // Auth Repository
    authRepositoryProvider.overrideWith((ref) {
      return ref.read(authRepositoryImplProvider);
    }),
    // Event Repository
    eventRepositoryProvider.overrideWith((ref) {
      return ref.read(eventRepositoryImplProvider);
    }),
    // Booking Repository
    bookingRepositoryProvider.overrideWith((ref) {
      return ref.read(apiBookingRepositoryImplProvider);
    }),
    // Favorites Repository
    favoritesRepositoryProvider.overrideWith((ref) {
      return ref.read(favoritesRepositoryImplProvider);
    }),
    // Blog Repository
    blogRepositoryProvider.overrideWith((ref) {
      return ref.read(blogRepositoryImplProvider);
    }),
    // Petit Boo AI Chat Repository
    petitBooRepositoryProvider.overrideWith((ref) {
      return ref.read(petitBooRepositoryImplProvider);
    }),
    // Messages Repository
    messagesRepositoryProvider.overrideWith((ref) {
      return ref.read(messagesRepositoryImplProvider);
    }),
    // Reviews Repository
    reviewsRepositoryProvider.overrideWith((ref) {
      return ref.read(reviewsRepositoryImplProvider);
    }),
    // Organizer Repository (public organizer profile + follow)
    organizerRepositoryProvider.overrideWith((ref) {
      return ref.read(organizerRepositoryImplProvider);
    }),
    // Memberships Repository (join/leave + invitations)
    membershipsRepositoryProvider.overrideWith((ref) {
      return ref.read(membershipsRepositoryImplProvider);
    }),
    // Keep activity repository for backward compatibility
    activityRepositoryProvider.overrideWithValue(FakeActivityRepositoryImpl()),
  ];
}

/// Fake data repositories - for offline testing and development
List<Override> _getFakeDataOverrides() {
  return [
    activityRepositoryProvider.overrideWithValue(FakeActivityRepositoryImpl()),
    bookingRepositoryProvider.overrideWithValue(FakeBookingRepositoryImpl()),
  ];
}

class LeHibooApp extends ConsumerWidget {
  const LeHibooApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    // Wire force logout so the 401 interceptor can trigger auth state change.
    DioClient.onForceLogout =
        () => ref.read(authProvider.notifier).forceLogout();

    // Watch push notification provider to initialize on auth state changes
    // The provider will auto-initialize when user logs in and unregister on logout
    ref.watch(pushNotificationProvider);
    ref.watch(inAppNotificationsProvider);

    // Eagerly initialize the Pusher WebSocket so it connects as soon as the
    // user authenticates — not lazily when they navigate to the messages screen.
    // This mirrors the web frontend which subscribes globally at app boot.
    ref.watch(messagesRealtimeProvider);

    // Eagerly initialize the role-appropriate conversation provider when
    // authenticated so the global unread badge syncs against the correct API.
    final authState = ref.watch(authProvider);
    final user = authState.user;
    if (authState.status == AuthStatus.authenticated && user != null) {
      switch (user.role) {
        case UserRole.partner:
          ref.watch(vendorConversationsProvider);
        case UserRole.admin:
          ref.watch(adminConversationsProvider('user_support'));
        default:
          ref.watch(conversationsProvider);
      }
    }

    // Hibons session heartbeat : observe le lifecycle et envoie 1×/jour après
    // 3 min en foreground si l'user est authentifié.
    ref.watch(sessionHeartbeatProvider);

    // Invalide les providers wallet/balance affichés sur la home dès qu'un
    // login/logout survient — sinon HibonCounterWidget garde la valeur
    // cachée du compte précédent.
    ref.watch(hibonsAuthSyncProvider);

    // Vendor check-in: keep the active-org notifier alive for the whole app
    // session so it can rehydrate from secure storage on launch and clear
    // itself when the user logs out (its ref.listen on authProvider only
    // fires while the provider is observed).
    ref.watch(activeOrganizationProvider);

    return MaterialApp.router(
      title: 'Le Hiboo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      scaffoldMessengerKey: scaffoldMessengerKey,
      // Le coordinateur écoute HibonsService et déclenche les SnackBars +X Hibons
      // et l'overlay rank-up via les clés globales (rootNavigatorKey,
      // scaffoldMessengerKey) — son BuildContext est au-dessus du Navigator.
      builder: (context, child) =>
          HibonsAnimationCoordinator(child: child ?? const SizedBox()),
    );
  }
}
