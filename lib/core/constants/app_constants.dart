class AppConstants {
  // App Info
  static const String appName = 'Le Hiboo';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Trouvez votre prochaine sortie près de chez vous';

  // API Configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.lehiboo.fr/v1',
  );
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keySelectedCity = 'selected_city';
  static const String keySelectedRadius = 'selected_radius';
  static const String keyFavoriteEvents = 'favorite_events';
  static const String keyRecentSearches = 'recent_searches';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';

  // Default Values
  static const int defaultSearchRadius = 10; // km
  static const int defaultPageSize = 20;
  static const int maxRecentSearches = 10;
  static const int maxImageUploadSize = 10 * 1024 * 1024; // 10 MB
  static const int minPasswordLength = 8;
  static const int otpLength = 6;
  static const Duration sessionTimeout = Duration(hours: 24);

  // Event Categories
  static const List<String> eventCategories = [
    'Spectacle',
    'Atelier',
    'Sport',
    'Culture',
    'Marché',
    'Loisirs',
    'Festival',
    'Concert',
    'Théâtre',
    'Cinéma',
    'Exposition',
    'Conférence',
    'Formation',
    'Autre',
  ];

  // Age Ranges
  static const Map<String, String> ageRanges = {
    'baby': '0-3 ans',
    'child': '4-11 ans',
    'teen': '12-17 ans',
    'adult': '18+ ans',
    'senior': '65+ ans',
    'all': 'Tout âge',
  };

  // Price Ranges
  static const Map<String, String> priceRanges = {
    'free': 'Gratuit',
    'low': '< 10€',
    'medium': '10-25€',
    'high': '25-50€',
    'premium': '> 50€',
  };

  // Time Filters
  static const Map<String, String> timeFilters = {
    'today': "Aujourd'hui",
    'tomorrow': 'Demain',
    'weekend': 'Ce week-end',
    'week': 'Cette semaine',
    'month': 'Ce mois',
    'custom': 'Personnalisé',
  };

  // Distance Filters
  static const List<int> distanceFilters = [1, 2, 5, 10, 20, 50, 100]; // km

  // Regex Patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegex = RegExp(
    r'^\+?[0-9]{10,15}$',
  );
  static final RegExp postalCodeRegex = RegExp(
    r'^[0-9]{5}$',
  );

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Social Media Links
  static const String facebookUrl = 'https://facebook.com/lehiboo';
  static const String instagramUrl = 'https://instagram.com/lehiboo';
  static const String twitterUrl = 'https://twitter.com/lehiboo';
  static const String linkedinUrl = 'https://linkedin.com/company/lehiboo';
  static const String websiteUrl = 'https://lehiboo.fr';

  // Support
  static const String supportEmail = 'support@lehiboo.fr';
  static const String supportPhone = '+33 1 23 45 67 89';
  static const String privacyPolicyUrl = 'https://lehiboo.fr/privacy';
  static const String termsOfServiceUrl = 'https://lehiboo.fr/terms';

  // Map Configuration
  static const double defaultMapZoom = 14.0;
  static const double defaultLatitude = 48.8566; // Paris
  static const double defaultLongitude = 2.3522; // Paris
  static const String mapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#f5f5f5"}]
    },
    {
      "elementType": "labels.icon",
      "stylers": [{"visibility": "off"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#616161"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#f5f5f5"}]
    }
  ]
  ''';

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  static const bool enablePushNotifications = true;
  static const bool enableSocialLogin = true;
  static const bool enableOfflineMode = false;
  static const bool enablePayment = true;
  static const bool enableChat = false;
  static const bool enableVideoTour = true;

  // Cache Configuration
  static const Duration cacheValidDuration = Duration(hours: 1);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100 MB
  static const int maxCachedImages = 500;

  // Pagination
  static const int initialPage = 1;
  static const int itemsPerPage = 20;
  static const int maxPages = 100;

  // Rating
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const double ratingIncrement = 0.5;

  // Private constructor to prevent instantiation
  AppConstants._();
}