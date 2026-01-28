import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';
import 'core/themes/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'routes/app_router.dart';
import 'config/dio_client.dart';
import 'config/env_config.dart';

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

// Fake Repositories (for offline testing)
import 'data/repositories/fake_activity_repository_impl.dart';
import 'domain/repositories/activity_repository.dart';
import 'features/booking/data/repositories/fake_booking_repository_impl.dart';

// Providers and Storage
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';

// Push Notifications
import 'features/notifications/presentation/providers/push_notification_provider.dart';

// Configuration flag - set to false to use fake data
const bool useRealApi = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  // Load environment variables
  // Use dart-define to specify environment: --dart-define=ENV=production or --dart-define=ENV=staging
  const String environment = String.fromEnvironment('ENV', defaultValue: 'development');
  final String envFile = switch (environment) {
    'production' => '.env.production',
    'staging' => '.env.staging',
    _ => '.env.development',
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

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Initialize Stripe
  final stripeKey = EnvConfig.stripePublishableKey;
  if (stripeKey.isNotEmpty) {
    Stripe.publishableKey = stripeKey;
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

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        ...(useRealApi
            ? _getRealApiOverrides()
            : _getFakeDataOverrides()),
      ],
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

    // Watch push notification provider to initialize on auth state changes
    // The provider will auto-initialize when user logs in and unregister on logout
    ref.watch(pushNotificationProvider);

    return MaterialApp.router(
      title: 'Le Hiboo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
