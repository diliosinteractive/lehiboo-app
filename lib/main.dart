import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/themes/app_theme.dart';
import 'routes/app_router.dart';
import 'config/dio_client.dart';

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
    const ProviderScope(
      child: LeHibooApp(),
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
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
