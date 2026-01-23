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

  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  /// Host header for nginx reverse proxy (used when accessing API via IP)
  static String get apiHost => dotenv.env['API_HOST'] ?? '';

  // Website URLs
  static String get websiteUrl => dotenv.env['WEBSITE_URL'] ?? 'https://lehiboo.fr';

  static String get privacyPolicyUrl =>
      dotenv.env['PRIVACY_POLICY_URL'] ?? 'https://lehiboo.fr/privacy';

  static String get termsOfServiceUrl =>
      dotenv.env['TERMS_OF_SERVICE_URL'] ?? 'https://lehiboo.fr/terms';

  // Firebase Configuration
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseMessagingSenderId => dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';

  // Google Maps
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  // Feature Flags
  static bool get analyticsEnabled =>
      dotenv.env['ANALYTICS_ENABLED']?.toLowerCase() == 'true';

  static bool get crashlyticsEnabled =>
      dotenv.env['CRASHLYTICS_ENABLED']?.toLowerCase() == 'true';

  // Environment detection
  static bool get isProduction =>
      dotenv.env['ENVIRONMENT']?.toLowerCase() == 'production';

  static bool get isDevelopment =>
      dotenv.env['ENVIRONMENT']?.toLowerCase() != 'production';

  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

  // Security
  static String get htUsername => dotenv.env['HT_USERNAME'] ?? '';
  static String get htPassword => dotenv.env['HT_PASSWORD'] ?? '';
  static String get securityHeaderName => dotenv.env['SECURITY_HEADER_NAME'] ?? 'Authorization';
}
