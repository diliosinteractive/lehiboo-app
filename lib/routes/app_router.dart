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
import '../features/profile/presentation/screens/profile_edit_screen.dart';
import '../features/profile/presentation/screens/settings_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/register_type_screen.dart';
import '../features/auth/presentation/screens/customer_register_screen.dart';
import '../features/auth/presentation/screens/business_register_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/otp_verification_screen.dart';
import '../features/booking/presentation/screens/booking_slot_selection_screen.dart';
import '../features/booking/presentation/screens/booking_participant_screen.dart';
import '../features/booking/presentation/screens/booking_payment_screen.dart';
import '../features/booking/presentation/screens/booking_confirmation_screen.dart';
import '../features/booking/presentation/screens/bookings_list_screen.dart';
import '../features/booking/presentation/screens/booking_detail_screen.dart';
import '../features/booking/presentation/screens/ticket_detail_screen.dart';
import '../features/booking/presentation/screens/checkout_screen.dart';
import '../features/booking/presentation/screens/booking_success_screen.dart';
import '../features/booking/domain/models/checkout_params.dart';
import '../domain/entities/booking.dart' as booking_entity;
import '../domain/entities/activity.dart'; // Add Activity import
import '../features/events/presentation/screens/map_view_screen.dart';
import '../core/widgets/main_scaffold.dart';
import '../features/partners/presentation/screens/partner_detail_screen.dart';
// Legacy AI Chat imports removed - redirects to Petit Boo
import '../features/alerts/presentation/screens/alerts_list_screen.dart'; // Import AlertsListScreen
import '../features/gamification/presentation/screens/hibon_shop_screen.dart';
import '../features/gamification/presentation/screens/lucky_wheel_screen.dart';
import '../features/gamification/presentation/screens/achievements_screen.dart';
import '../features/gamification/presentation/screens/gamification_dashboard_screen.dart';
import '../features/petit_boo/presentation/screens/petit_boo_chat_screen.dart';
import '../features/petit_boo/presentation/screens/petit_boo_brain_screen.dart';
import '../features/petit_boo/presentation/screens/conversation_list_screen.dart';
import '../features/trip_plans/presentation/screens/trip_plans_list_screen.dart';
import '../features/trip_plans/presentation/screens/trip_plan_edit_screen.dart';

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
       
       debugPrint('🔀 Router redirect: ${state.matchedLocation}');
       debugPrint('🔀 AuthStatus: ${authState.status}');
       debugPrint('🔀 isPendingOtp: $isPendingOtp');
       
       // Auth-related routes
       final isLoggingIn = state.matchedLocation == '/login';
       final isRegistering = state.matchedLocation == '/register' ||
                            state.matchedLocation == '/register/customer' ||
                            state.matchedLocation == '/register/business' ||
                            state.matchedLocation == '/register-simple';
       final isResettingPassword = state.matchedLocation == '/forgot-password';
       final isVerifyingOtp = state.matchedLocation == '/verify-otp';
       final isOnboarding = state.matchedLocation == '/onboarding';
       final isAuthRoute = isLoggingIn || isRegistering || isResettingPassword || isVerifyingOtp;
       
       // 1. If onboarding not completed, go to onboarding
       if (!onboardingCompleted && !isOnboarding) {
         debugPrint('🔀 Redirecting to /onboarding');
         return '/onboarding';
       }
       
       // 2. If onboarding completed but user on onboarding page, go to login
       if (onboardingCompleted && isOnboarding) {
         debugPrint('🔀 Redirecting to /login (from onboarding)');
         return '/login';
       }
       
       // 3. If pending OTP verification
       if (isPendingOtp) {
         // Allow navigation to other auth routes (back to register, login, etc)
         if (isAuthRoute) {
           debugPrint('🔀 Pending OTP - Allowing auth route: ${state.matchedLocation}');
           return null; 
         }
         
         debugPrint('🔀 Pending OTP - FORCING redirect to /verify-otp');
         return '/verify-otp'; // Force redirect to OTP screen for non-auth routes
       }
       
       // 4. If not authenticated and not on auth route, redirect to login
       if (!isAuthenticated && !isAuthRoute && !isOnboarding) {
         debugPrint('🔀 Redirecting to /login (not authenticated)');
         return '/login';
       }
       
       // 5. If authenticated and on auth route, redirect to home
       if (isAuthenticated && isAuthRoute) {
         debugPrint('🔀 Redirecting to / (authenticated)');
         return '/';
       }
       
       debugPrint('🔀 No redirect');
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
      // Main register route - shows type selection
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterTypeScreen(),
      ),
      // Legacy simple register (for backwards compatibility)
      GoRoute(
        path: '/register-simple',
        name: 'register-simple',
        builder: (context, state) => const RegisterScreen(),
      ),
      // Customer registration (simple)
      GoRoute(
        path: '/register/customer',
        name: 'register-customer',
        builder: (context, state) => const CustomerRegisterScreen(),
      ),
      // Business registration (multi-step)
      GoRoute(
        path: '/register/business',
        name: 'register-business',
        builder: (context, state) => const BusinessRegisterScreen(),
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
          // Get from extra if available, otherwise from authState (for redirect case)
          final userId = extra?['userId'] ?? authState.pendingUserId ?? '';
          final email = extra?['email'] ?? authState.pendingEmail ?? '';
          final type = extra?['type'] ?? (authState.status == AuthStatus.pendingLoginOtp ? 'login' : 'register');
          return OtpVerificationScreen(
            userId: userId,
            email: email,
            type: type,
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
      // Favorites
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) {
          final lat = double.tryParse(state.uri.queryParameters['lat'] ?? '');
          final lng = double.tryParse(state.uri.queryParameters['lng'] ?? '');
          final zoom = double.tryParse(state.uri.queryParameters['zoom'] ?? '');
          return MapViewScreen(
            initialLat: lat,
            initialLng: lng,
            initialZoom: zoom,
          );
        },
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
          final openFilter = state.uri.queryParameters['openFilter'] == 'true';
          return SearchScreen(
            categorySlug: categorySlug,
            city: city,
            autoOpenFilter: openFilter,
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
      // Booking detail route
      GoRoute(
        path: '/booking-detail/:id',
        name: 'booking-detail',
        builder: (context, state) {
          final bookingId = state.pathParameters['id']!;
          final booking = state.extra as booking_entity.Booking?;
          return BookingDetailScreen(
            bookingId: bookingId,
            initialBooking: booking,
          );
        },
      ),
      // Ticket detail route
      GoRoute(
        path: '/ticket/:id',
        name: 'ticket-detail',
        builder: (context, state) {
          final ticketId = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>?;
          return TicketDetailScreen(
            ticketId: ticketId,
            ticket: extra?['ticket'] as booking_entity.Ticket?,
            tickets: extra?['tickets'] as List<booking_entity.Ticket>?,
            initialIndex: extra?['initialIndex'] as int? ?? 0,
            booking: extra?['booking'] as booking_entity.Booking?,
          );
        },
      ),

      // Checkout unifié (nouveau flow)
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final params = CheckoutParams.fromExtra(extra);
          return CheckoutScreen(params: params);
        },
      ),

      // Confirmation après checkout
      GoRoute(
        path: '/booking-confirmation/:id',
        name: 'booking-confirmation-new',
        builder: (context, state) {
          final bookingId = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>?;
          return BookingSuccessScreen(
            bookingId: bookingId,
            bookingResponse: extra?['booking'],
            event: extra?['event'],
            selectedSlot: extra?['selectedSlot'],
          );
        },
      ),

      // Profile edit / Account
      GoRoute(
        path: '/account',
        name: 'account',
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'profile-edit',
        builder: (context, state) => const ProfileEditScreen(),
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

      // Notifications (Now Alerts & Saved Searches)
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const AlertsListScreen(),
      ),
      // AI Chat (Legacy redirects to Petit Boo)
      GoRoute(
        path: '/ai-welcome',
        name: 'ai-welcome',
        redirect: (_, __) => '/petit-boo',
      ),
      GoRoute(
        path: '/ai-chat',
        name: 'ai-chat',
        redirect: (_, __) => '/petit-boo',
      ),
      // Gamification
      GoRoute(
        path: '/hibons-shop',
        name: 'hibons-shop',
        builder: (context, state) => const HibonShopScreen(),
      ),
      GoRoute(
        path: '/hibons-dashboard',
        name: 'hibons-dashboard',
        builder: (context, state) => const GamificationDashboardScreen(),
      ),
      GoRoute(
        path: '/lucky-wheel',
        name: 'lucky-wheel',
        builder: (context, state) => const LuckyWheelScreen(),
      ),
      GoRoute(
        path: '/achievements',
        name: 'achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      // Petit Boo AI Chat
      GoRoute(
        path: '/petit-boo',
        name: 'petit-boo',
        builder: (context, state) {
          final sessionUuid = state.uri.queryParameters['session'];
          final initialMessage = state.uri.queryParameters['message'];
          return PetitBooChatScreen(
            sessionUuid: sessionUuid,
            initialVoiceMessage: initialMessage,
          );
        },
      ),
      GoRoute(
        path: '/petit-boo/history',
        name: 'petit-boo-history',
        builder: (context, state) => const ConversationListScreen(),
      ),
      GoRoute(
        path: '/petit-boo/brain',
        name: 'petit-boo-brain',
        builder: (context, state) => const PetitBooBrainScreen(),
      ),
      // Trip Plans (Mes Sorties)
      GoRoute(
        path: '/trip-plans',
        name: 'trip-plans',
        builder: (context, state) => const TripPlansListScreen(),
      ),
      GoRoute(
        path: '/trip-plans/:uuid/edit',
        name: 'trip-plan-edit',
        builder: (context, state) {
          final uuid = state.pathParameters['uuid']!;
          return TripPlanEditScreen(planUuid: uuid);
        },
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