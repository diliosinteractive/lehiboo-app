import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized environment configuration using flutter_dotenv.
/// All environment-specific values should be accessed through this class.
class EnvConfig {
  EnvConfig._();

  // API Configuration - Laravel v2
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.lehiboo.com/api/v1';

  static String get aiBaseUrl =>
      dotenv.env['AI_BASE_URL'] ?? 'https://api.lehiboo.com/api-planner';

  // Petit Boo AI Assistant
  static String get petitBooBaseUrl =>
      dotenv.env['PETIT_BOO_BASE_URL'] ?? 'https://petitboo.lehiboo.com';

  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  /// Host header for nginx reverse proxy (used when accessing API via IP)
  static String get apiHost => dotenv.env['API_HOST'] ?? '';

  // Website URLs
  static String get websiteUrl =>
      dotenv.env['WEBSITE_URL'] ?? 'https://lehiboo.com';

  // Firebase Configuration
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseMessagingSenderId => dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';

  // OneSignal Push Notifications
  static String get oneSignalAppId => dotenv.env['ONESIGNAL_APP_ID'] ?? '';

  // Google Maps
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  // Stripe Configuration (publishable key only - safe to expose in app)
  static String get stripePublishableKey =>
      dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

  // Feature Flags
  static bool get analyticsEnabled =>
      dotenv.env['ANALYTICS_ENABLED']?.toLowerCase() == 'true';

  static bool get crashlyticsEnabled =>
      dotenv.env['CRASHLYTICS_ENABLED']?.toLowerCase() == 'true';

  // Environment detection
  static bool get isProduction =>
      dotenv.env['ENVIRONMENT']?.toLowerCase() == 'production';

  static bool get isStaging =>
      dotenv.env['ENVIRONMENT']?.toLowerCase() == 'staging';

  static bool get isDevelopment =>
      !isProduction && !isStaging;

  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

  // Security
  static String get htUsername => dotenv.env['HT_USERNAME'] ?? '';
  static String get htPassword => dotenv.env['HT_PASSWORD'] ?? '';
  static String get securityHeaderName => dotenv.env['SECURITY_HEADER_NAME'] ?? 'Authorization';

  // Pusher / WebSocket (Laravel Reverb — Pusher-protocol compatible)
  static String get pusherKey => dotenv.env['PUSHER_APP_KEY'] ?? '';
  static String get pusherCluster => dotenv.env['PUSHER_APP_CLUSTER'] ?? 'eu';

  /// Custom WebSocket host (required for Reverb — do NOT use Pusher cloud).
  static String get pusherHost => dotenv.env['PUSHER_HOST'] ?? '';

  /// WebSocket port. 443 for TLS (production/staging), 80 for plain (dev).
  static int get pusherPort =>
      int.tryParse(dotenv.env['PUSHER_PORT'] ?? '') ?? (pusherUseTLS ? 443 : 80);

  static bool get pusherUseTLS =>
      dotenv.env['PUSHER_USE_TLS']?.toLowerCase() == 'true';

  static String get pusherAuthEndpoint =>
      dotenv.env['PUSHER_AUTH_ENDPOINT'] ??
      '${apiBaseUrl.replaceAll('/api/v1', '')}/broadcasting/auth';
}
