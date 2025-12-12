import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/themes/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'routes/app_router.dart';
import 'config/dio_client.dart';

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

// Fake Repositories (for offline testing)
import 'data/repositories/fake_activity_repository_impl.dart';
import 'domain/repositories/activity_repository.dart';
import 'features/booking/data/repositories/fake_booking_repository_impl.dart';

// Configuration flag - set to false to use fake data
const bool useRealApi = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  // Load environment variables
  // Use dart-define to specify environment: --dart-define=ENV=production
  const String environment = String.fromEnvironment('ENV', defaultValue: 'development');
  final String envFile = environment == 'production' ? '.env.production' : '.env.development';
  
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

  // Initialize other services here (Firebase, etc.)

  runApp(
    ProviderScope(
      overrides: useRealApi
          ? _getRealApiOverrides()
          : _getFakeDataOverrides(),
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
