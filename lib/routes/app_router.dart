import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../core/providers/shared_preferences_provider.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';

import '../features/home/presentation/screens/home_screen.dart';
import '../features/home/presentation/screens/city_detail_screen.dart';
import 'package:lehiboo/features/events/presentation/screens/event_detail_screen.dart'; // Corrected import
import 'package:lehiboo/features/events/presentation/screens/event_list_screen.dart'; // Re-added for /recommended route
import 'package:lehiboo/features/events/presentation/screens/event_questions_screen.dart';
import 'package:lehiboo/features/search/presentation/screens/search_screen.dart';
import '../features/search/presentation/screens/filter_screen.dart';
import '../features/favorites/presentation/screens/favorites_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/profile_edit_screen.dart';
import '../features/profile/presentation/screens/settings_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/auth_bootstrap_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/register_type_screen.dart';
import '../features/auth/presentation/screens/customer_register_screen.dart';
import '../features/auth/presentation/screens/business_register_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/otp_verification_screen.dart';
import '../features/reminders/presentation/screens/reminders_list_screen.dart';
import '../features/user_questions/presentation/screens/user_questions_screen.dart';
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
import '../features/partners/presentation/screens/organizer_profile_screen.dart';
import '../features/partners/presentation/screens/followed_organizers_screen.dart';
import '../features/memberships/presentation/screens/invitation_landing_screen.dart';
import '../features/memberships/presentation/screens/memberships_screen.dart';
import '../features/memberships/presentation/screens/private_events_screen.dart';
import '../features/checkin/presentation/screens/checkin_scan_screen.dart';
import '../features/checkin/presentation/screens/checkin_manual_entry_screen.dart';
// Legacy AI Chat imports removed - redirects to Petit Boo
import '../features/alerts/presentation/screens/alerts_list_screen.dart'; // Import AlertsListScreen
// HibonShopScreen import retiré : route /hibons-shop redirigée vers
// /hibons-dashboard (Plan 04 — achats Hibons désactivés). Le fichier source
// est conservé pour réactivation v2.
import '../features/gamification/presentation/screens/lucky_wheel_screen.dart';
import '../features/gamification/presentation/screens/achievements_screen.dart';
import '../features/gamification/presentation/screens/gamification_dashboard_screen.dart';
import '../features/gamification/presentation/screens/how_to_earn_hibons_screen.dart';
import '../features/petit_boo/presentation/screens/petit_boo_chat_screen.dart';
import '../features/petit_boo/presentation/screens/petit_boo_brain_screen.dart';
import '../features/petit_boo/presentation/screens/conversation_list_screen.dart';
import '../features/trip_plans/presentation/screens/trip_plans_list_screen.dart';
import '../features/trip_plans/presentation/screens/trip_plan_edit_screen.dart';
import '../features/messages/presentation/screens/conversations_list_screen.dart';
import '../features/messages/presentation/screens/conversation_detail_screen.dart';
import '../features/messages/presentation/screens/new_conversation_screen.dart';
import '../features/messages/presentation/screens/support_detail_screen.dart';
import '../features/messages/presentation/screens/vendor_new_conversation_screen.dart';
import '../features/messages/presentation/screens/admin_new_conversation_screen.dart';
import '../features/messages/presentation/screens/admin_report_detail_screen.dart';
import '../features/messages/domain/entities/conversation_route.dart';
import '../features/reviews/presentation/screens/event_reviews_full_screen.dart';
import '../features/reviews/presentation/screens/my_reviews_screen.dart';
/// ChangeNotifier that drives GoRouter.refreshListenable so redirect logic
/// re-runs on auth state changes WITHOUT rebuilding the GoRouter instance
/// (which would reset the navigation stack).
class _AuthRouterRefresh extends ChangeNotifier {
  _AuthRouterRefresh(Ref ref) {
    _sub = ref.listen<AuthState>(
      authProvider,
      (previous, next) {
        // Only refresh when meaningful routing state changes. Ignore pure
        // errorMessage toggles — those must not reset the navigation stack.
        if (previous?.status != next.status) {
          debugPrint('🔀 AuthRouterRefresh: ${previous?.status} → ${next.status}');
          notifyListeners();
        }
      },
      fireImmediately: false,
    );
  }

  late final ProviderSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}


/// Clé globale du navigateur racine — utilisée par `HibonsAnimationCoordinator`
/// pour obtenir un BuildContext sous l'Overlay (les toasts/overlays Hibons
/// sont montés depuis l'intercepteur Dio, hors hiérarchie de widgets).
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Clé globale du ScaffoldMessenger — permet d'afficher des SnackBar depuis
/// n'importe où (ex: l'intercepteur Dio Hibons via le coordinateur).
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final routerProvider = Provider<GoRouter>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  final refresh = _AuthRouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/bootstrap',
    refreshListenable: refresh,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final onboardingCompleted =
          prefs.getBool(AppConstants.keyOnboardingCompleted) ?? false;
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
      final isBootstrap = state.matchedLocation == '/bootstrap';
      final isAuthRoute =
          isLoggingIn || isRegistering || isResettingPassword || isVerifyingOtp;

      // Wait for the async auth check to finish before choosing the first real screen.
      if (authState.status == AuthStatus.initial) {
        if (!isBootstrap) {
          debugPrint('🔀 Waiting auth bootstrap');
          return '/bootstrap';
        }
        return null;
      }

      if (isBootstrap) {
        if (!onboardingCompleted) return '/onboarding';
        if (isPendingOtp) return '/verify-otp';
        return '/';
      }

      // 1. If onboarding not completed, go to onboarding
      if (!onboardingCompleted && !isOnboarding) {
        debugPrint('🔀 Redirecting to /onboarding');
        return '/onboarding';
      }

      // 2. If onboarding completed but user on onboarding page, go to login
      if (onboardingCompleted && isOnboarding) {
        debugPrint('🔀 Redirecting to / (from onboarding)');
        return '/';
      }

      // 3. If pending OTP verification
      if (isPendingOtp) {
        // Allow navigation to other auth routes (back to register, login, etc)
        if (isAuthRoute) {
          debugPrint(
              '🔀 Pending OTP - Allowing auth route: ${state.matchedLocation}');
          return null;
        }

        debugPrint('🔀 Pending OTP - FORCING redirect to /verify-otp');
        return '/verify-otp'; // Force redirect to OTP screen for non-auth routes
      }

      // NOTE: no auto-redirect for "authenticated on auth route". Screens that
      // perform auth (login, register, verify-otp, ...) navigate explicitly on
      // success — an auto-redirect here would race with those calls and clear
      // the navigation stack (losing e.g. the EventDetail a guest guard was
      // invoked from).

      // 4. Messages require authentication — redirect to login if not authenticated.
      //    Covers direct navigation, deep links from FCM, and URL-bar entry.
      // 4. Messages require authentication — handled via GuestGuard in UI entries
      // for a better UX (modal instead of full-screen redirect).
      if (state.matchedLocation.startsWith('/messages') &&
          authState.status == AuthStatus.unauthenticated) {
        return null;
      }

      debugPrint('🔀 No redirect');
      return null;
    },
    routes: [
      GoRoute(
        path: '/bootstrap',
        name: 'bootstrap',
        builder: (context, state) => const AuthBootstrapScreen(),
      ),

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

      // Messages routes — outside ShellRoute so navbar is hidden
      GoRoute(
        path: '/messages',
        name: 'messages',
        builder: (_, __) => const ConversationsListScreen(),
      ),
      GoRoute(
        path: '/messages/new',
        name: 'messages-new',
        builder: (_, __) => const NewConversationScreen(),
      ),
      GoRoute(
        path: '/messages/new/from-booking/:bookingUuid',
        name: 'messages-from-booking',
        builder: (_, state) => NewConversationScreen(
          fromBookingUuid: state.pathParameters['bookingUuid']!,
        ),
      ),
      GoRoute(
        path: '/messages/new/from-organizer/:organizationUuid',
        name: 'messages-from-organizer',
        builder: (_, state) => NewConversationScreen(
          fromOrganizationUuid: state.pathParameters['organizationUuid']!,
          fromOrganizationName: state.uri.queryParameters['name'],
        ),
      ),
      GoRoute(
        path: '/messages/support/new',
        name: 'messages-support-new',
        builder: (_, __) => const SupportDetailScreen(isNew: true),
      ),
      GoRoute(
        path: '/messages/support/:conversationUuid',
        name: 'messages-support-detail',
        builder: (_, state) => SupportDetailScreen(
          conversationUuid: state.pathParameters['conversationUuid']!,
        ),
      ),

      // ── Vendor routes (static before parameterized) ───────────────────────
      GoRoute(
        path: '/messages/vendor/new/participant',
        name: 'messages-vendor-new-participant',
        builder: (_, __) => const VendorNewConversationScreen(
            mode: VendorConversationMode.toParticipant),
      ),
      GoRoute(
        path: '/messages/vendor/new/partner',
        name: 'messages-vendor-new-partner',
        builder: (_, __) => const VendorNewConversationScreen(
            mode: VendorConversationMode.toPartner),
      ),
      GoRoute(
        path: '/messages/vendor/new/support',
        name: 'messages-vendor-new-support',
        builder: (_, __) => const VendorNewConversationScreen(
            mode: VendorConversationMode.supportThread),
      ),
      GoRoute(
        path: '/messages/vendor-org/:conversationUuid',
        name: 'messages-vendor-org-detail',
        builder: (_, state) => ConversationDetailScreen(
          conversationUuid: state.pathParameters['conversationUuid']!,
          route: ConversationRoute.vendorOrgOrg,
        ),
      ),
      GoRoute(
        path: '/messages/vendor/:conversationUuid',
        name: 'messages-vendor-detail',
        builder: (_, state) => ConversationDetailScreen(
          conversationUuid: state.pathParameters['conversationUuid']!,
          route: ConversationRoute.vendor,
        ),
      ),

      // ── Admin routes (static before parameterized) ────────────────────────
      GoRoute(
        path: '/messages/admin/new/user',
        name: 'messages-admin-new-user',
        builder: (_, __) => const AdminNewConversationScreen(
            mode: AdminConversationMode.toUser),
      ),
      GoRoute(
        path: '/messages/admin/new/organizer',
        name: 'messages-admin-new-organizer',
        builder: (_, __) => const AdminNewConversationScreen(
            mode: AdminConversationMode.toOrganizer),
      ),
      GoRoute(
        path: '/messages/admin/reports/:reportUuid',
        name: 'messages-admin-report-detail',
        builder: (_, state) => AdminReportDetailScreen(
          reportUuid: state.pathParameters['reportUuid']!,
        ),
      ),
      GoRoute(
        path: '/messages/admin/:conversationUuid',
        name: 'messages-admin-detail',
        builder: (_, state) {
          final readonly =
              state.uri.queryParameters['readonly'] == 'true';
          return ConversationDetailScreen(
            conversationUuid: state.pathParameters['conversationUuid']!,
            route: readonly
                ? ConversationRoute.adminReadonly
                : ConversationRoute.admin,
          );
        },
      ),

      // IMPORTANT: static sub-paths (new, support, vendor, admin) must be
      // declared before this wildcard
      GoRoute(
        path: '/messages/:conversationUuid',
        name: 'messages-detail',
        builder: (_, state) => ConversationDetailScreen(
          conversationUuid: state.pathParameters['conversationUuid']!,
        ),
      ),

      // ── Vendor check-in routes ────────────────────────────────────────────
      // Outside the main shell — full-screen scanner, no bottom nav.
      // Spec: docs/MOBILE_CHECKIN_SPEC.md.
      GoRoute(
        path: '/vendor/scan',
        name: 'vendor-scan',
        builder: (_, __) => const CheckinScanScreen(),
        routes: [
          GoRoute(
            path: 'manual',
            name: 'vendor-scan-manual',
            builder: (_, __) => const CheckinManualEntryScreen(),
          ),
        ],
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(
          redirectTo: state.uri.queryParameters['redirect'],
        ),
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
          final authState = ref.read(authProvider);
          final userId = extra?['userId'] ?? authState.pendingUserId ?? '';
          final email = extra?['email'] ?? authState.pendingEmail ?? '';
          final type = extra?['type'] ??
              (authState.status == AuthStatus.pendingLoginOtp
                  ? 'login'
                  : 'register');
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
      // Full Q&A screen for an event
      GoRoute(
        path: '/event/:id/questions',
        name: 'event-questions',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          final extra = state.extra;
          final title = extra is Map<String, dynamic>
              ? (extra['title']?.toString() ?? 'Événement')
              : 'Événement';
          return EventQuestionsScreen(
            eventSlug: eventId,
            eventTitle: title,
          );
        },
      ),
      // Organizer profile (public)
      GoRoute(
        path: '/organizers/:identifier',
        name: 'organizer-profile',
        builder: (context, state) => OrganizerProfileScreen(
          identifier: state.pathParameters['identifier']!,
        ),
      ),
      // Authed user's followed organizers list
      GoRoute(
        path: '/me/followed-organizers',
        name: 'followed-organizers',
        builder: (_, __) => const FollowedOrganizersScreen(),
      ),
      // Authed user's memberships (4 tabs: active / pending / rejected / invitations)
      GoRoute(
        path: '/me/memberships',
        name: 'memberships',
        builder: (_, state) => MembershipsScreen(
          initialTab: state.uri.queryParameters['tab'],
        ),
      ),
      // Private events visible to the user via active memberships
      GoRoute(
        path: '/me/private-events',
        name: 'private-events',
        builder: (_, state) => PrivateEventsScreen(
          initialOrgFilter: state.uri.queryParameters['org'],
        ),
      ),
      // Invitation deep-link landing — public preview before login
      GoRoute(
        path: '/invitations/:token',
        name: 'invitation-landing',
        builder: (_, state) => InvitationLandingScreen(
          token: state.pathParameters['token']!,
        ),
      ),
      // Backward-compat: legacy /partner/:id → /organizers/:id
      GoRoute(
        path: '/partner/:id',
        name: 'partner-detail',
        redirect: (context, state) =>
            '/organizers/${state.pathParameters['id']!}',
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
          final dateFilter = state.uri.queryParameters['date'];
          final openFilter = state.uri.queryParameters['openFilter'] == 'true';
          return SearchScreen(
            categorySlug: categorySlug,
            city: city,
            dateFilter: dateFilter,
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
      // Plan 04: boutique de packs Hibons désactivée (404 backend).
      // Le code de HibonShopScreen reste en place pour réactivation v2 ;
      // on redirige les anciens deep-links vers le dashboard.
      GoRoute(
        path: '/hibons-shop',
        name: 'hibons-shop',
        redirect: (_, __) => '/hibons-dashboard',
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
      GoRoute(
        path: '/hibons/how-to-earn',
        name: 'hibons-how-to-earn',
        builder: (context, state) => const HowToEarnHibonsScreen(),
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
      // Reminders (Mes Rappels)
      GoRoute(
        path: '/my-reminders',
        name: 'my-reminders',
        builder: (context, state) => const RemindersListScreen(),
      ),
      // User Questions (Mes Questions)
      GoRoute(
        path: '/my-questions',
        name: 'my-questions',
        builder: (context, state) => const UserQuestionsScreen(),
      ),
      // User Reviews (Mes Avis)
      GoRoute(
        path: '/my-reviews',
        name: 'my-reviews',
        builder: (context, state) {
          final reviewUuid = state.uri.queryParameters['reviewUuid'];
          return MyReviewsScreen(highlightReviewUuid: reviewUuid);
        },
      ),
      // Full reviews list for an event
      GoRoute(
        path: '/event/:slug/reviews',
        name: 'event-reviews',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          final extra = state.extra;
          final title = extra is Map<String, dynamic>
              ? extra['title']?.toString()
              : null;
          return EventReviewsFullScreen(eventSlug: slug, eventTitle: title);
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
