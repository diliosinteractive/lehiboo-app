import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/themes/app_theme.dart';
import 'routes/app_router.dart';
import 'config/dio_client.dart';
import 'data/repositories/fake_activity_repository_impl.dart';
import 'domain/repositories/activity_repository.dart'; // Ensure provider is reachable
import 'features/booking/data/repositories/fake_booking_repository_impl.dart';
import 'features/booking/presentation/controllers/booking_flow_controller.dart'; // Exposure of bookingRepositoryProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Could not load .env file: $e');
  }

  // Initialize Dio client
  DioClient.initialize();

  // Initialize other services here (Firebase, etc.)

  runApp(
    ProviderScope(
      overrides: [
        // Inject Fake Repositories for offline testing
        activityRepositoryProvider.overrideWithValue(FakeActivityRepositoryImpl()),
        bookingRepositoryProvider.overrideWithValue(FakeBookingRepositoryImpl()),
      ],
      child: const LeHibooApp(),
    ),
  );
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
