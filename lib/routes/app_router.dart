import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

import '../features/home/presentation/screens/home_screen.dart';
import '../features/home/presentation/screens/city_detail_screen.dart';
import 'package:lehiboo/features/events/presentation/screens/event_detail_screen.dart'; // Corrected import
import 'package:lehiboo/features/events/presentation/screens/event_list_screen.dart'; // Re-added for /recommended route
import 'package:lehiboo/features/search/presentation/screens/search_screen.dart';
import '../features/search/presentation/screens/filter_screen.dart';
import '../features/favorites/presentation/screens/favorites_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/settings_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/otp_verification_screen.dart';
import '../features/booking/presentation/screens/booking_slot_selection_screen.dart';
import '../features/booking/presentation/screens/booking_participant_screen.dart';
import '../features/booking/presentation/screens/booking_payment_screen.dart';
import '../features/booking/presentation/screens/booking_confirmation_screen.dart';
import '../features/booking/presentation/screens/bookings_list_screen.dart';
import '../domain/entities/activity.dart'; // Add Activity import
import '../features/events/presentation/screens/map_view_screen.dart';
import '../core/widgets/main_scaffold.dart';
import '../features/partners/presentation/screens/partner_detail_screen.dart';
import '../features/ai_chat/presentation/screens/ai_welcome_screen.dart';
import '../features/ai_chat/presentation/screens/ai_chat_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
       final prefs = await SharedPreferences.getInstance();
       final onboardingCompleted = prefs.getBool(AppConstants.keyOnboardingCompleted) ?? false;
       final isAuthenticated = authState.isAuthenticated;
       final isPendingOtp = authState.status == AuthStatus.pendingVerification || 
                           authState.status == AuthStatus.pendingLoginOtp;
       
       // Auth-related routes
       final isLoggingIn = state.matchedLocation == '/login';
       final isRegistering = state.matchedLocation == '/register';
       final isResettingPassword = state.matchedLocation == '/forgot-password';
       final isVerifyingOtp = state.matchedLocation == '/verify-otp';
       final isOnboarding = state.matchedLocation == '/onboarding';
       final isAuthRoute = isLoggingIn || isRegistering || isResettingPassword || isVerifyingOtp;
       
       // 1. If onboarding not completed, go to onboarding
       if (!onboardingCompleted && !isOnboarding) {
         return '/onboarding';
       }
       
       // 2. If onboarding completed but user on onboarding page, go to login
       if (onboardingCompleted && isOnboarding) {
         return '/login';
       }
       
       // 3. If pending OTP and not on verify-otp, stay on current route (don't redirect)
       // This allows the navigation to /verify-otp to complete
       if (isPendingOtp && isVerifyingOtp) {
         return null; // Allow access to OTP screen
       }
       
       // 4. If not authenticated and not on auth route, redirect to login
       if (!isAuthenticated && !isAuthRoute && !isOnboarding) {
         return '/login';
       }
       
       // 5. If authenticated and on auth route, redirect to home
       if (isAuthenticated && isAuthRoute) {
         return '/';
       }
       
       return null;
    },
    routes: [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Main shell route with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/explore',
            name: 'explore',
            builder: (context, state) {
              final categorySlug = state.uri.queryParameters['categorySlug'];
              final city = state.uri.queryParameters['city'];
              return SearchScreen(
                categorySlug: categorySlug,
                city: city,
              );
            },
          ),
          GoRoute(
            path: '/favorites',
            name: 'favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/my-bookings',
            name: 'my-bookings',
            builder: (context, state) => const BookingsListScreen(),
          ),
        ],
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verify-otp',
        name: 'verify-otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OtpVerificationScreen(
            userId: extra?['userId'] ?? '',
            email: extra?['email'] ?? '',
            type: extra?['type'] ?? 'register',
          );
        },
      ),

      // Event routes
      GoRoute(
        path: '/event/:id',
        name: 'event-detail',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EventDetailScreen(eventId: eventId);
        },
      ),
      // Alias route for /events/:id
      GoRoute(
        path: '/events/:id',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          return EventDetailScreen(eventId: eventId);
        },
      ),
      // Partner route
      GoRoute(
        path: '/partner/:id',
        name: 'partner-detail',
        builder: (context, state) {
          final partnerId = state.pathParameters['id']!;
          return PartnerDetailScreen(partnerId: partnerId);
        },
      ),
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) => const MapViewScreen(),
      ),

      // City details
      GoRoute(
        path: '/city/:slug',
        name: 'city-detail',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return CityDetailScreen(citySlug: slug);
        },
      ),

      // Search routes
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) {
          final categorySlug = state.uri.queryParameters['categorySlug'];
          final city = state.uri.queryParameters['city'];
          return SearchScreen(
            categorySlug: categorySlug,
            city: city,
          );
        },
      ),
      GoRoute(
        path: '/filters',
        name: 'filters',
        builder: (context, state) => const FilterScreen(),
      ),

      // Booking routes
      GoRoute(
        path: '/booking/:activityId',
        name: 'booking',
        builder: (context, state) {
          final activity = state.extra as Activity;
          return BookingSlotSelectionScreen(activity: activity);
        },
        routes: [
          GoRoute(
            path: 'participants',
            name: 'booking-participants',
            builder: (context, state) {
              final activity = state.extra as Activity;
              return BookingParticipantScreen(activity: activity);
            },
          ),
          GoRoute(
            path: 'payment',
            name: 'booking-payment',
            builder: (context, state) {
              final activity = state.extra as Activity;
              return BookingPaymentScreen(activity: activity);
            },
          ),
          GoRoute(
            path: 'confirmation',
            name: 'booking-confirmation',
            builder: (context, state) {
              final activity = state.extra as Activity;
              return BookingConfirmationScreen(activity: activity);
            },
          ),
        ],
      ),
      


      // Settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),

      // Recommended events
      GoRoute(
        path: '/recommended',
        name: 'recommended',
        builder: (context, state) => const EventListScreen(
          title: 'Recommandés pour vous',
          filterType: 'recommended',
        ),
      ),

      // Notifications
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      // AI Chat
      GoRoute(
        path: '/ai-welcome',
        name: 'ai-welcome',
        builder: (context, state) => const AiWelcomeScreen(),
      ),
      GoRoute(
        path: '/ai-chat',
        name: 'ai-chat',
        builder: (context, state) => const AiChatScreen(),
      ),
    ],

    errorBuilder: (context, state) => const ErrorScreen(),
  );
});

// Error screen
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Page non trouvée',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'La page que vous recherchez n\'existe pas',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF601F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Retour à l\'accueil',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Notifications Screen placeholder
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFFFF601F),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Écran des notifications'),
      ),
    );
  }
}