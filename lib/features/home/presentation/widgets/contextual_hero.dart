import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/home/presentation/providers/user_location_provider.dart';
import 'package:lehiboo/features/search/presentation/widgets/home_search_pill.dart';
import 'package:lehiboo/features/alerts/presentation/providers/alerts_provider.dart';
import 'package:lehiboo/features/search/presentation/providers/filter_provider.dart';

import '../../data/models/mobile_app_config.dart';

/// Images de villes pour le Hero (Unsplash - ambiances festives et colorées)
const _cityImages = <String, String>{
  // Nord-Pas-de-Calais - Ambiances festives, marchés, concerts
  'valenciennes': 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800&q=80', // Festival coloré
  'lille': 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&q=80', // Concert ambiance
  'douai': 'https://images.unsplash.com/photo-1506157786151-b8491531f063?w=800&q=80', // Festival musique
  'cambrai': 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=800&q=80', // Fête foraine
  'maubeuge': 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800&q=80',
  'denain': 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800&q=80',
  'anzin': 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800&q=80',
  'saint-amand-les-eaux': 'https://images.unsplash.com/photo-1504680177321-2e6a879aac86?w=800&q=80', // Spa/détente
  'roubaix': 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&q=80',
  'tourcoing': 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&q=80',
  'dunkerque': 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800&q=80', // Carnaval vibes
  'arras': 'https://images.unsplash.com/photo-1506157786151-b8091532f063?w=800&q=80',
  // Grandes villes françaises - Ambiances de nuit et festives
  'paris': 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800&q=80', // Concert Paris
  'lyon': 'https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?w=800&q=80', // Fête des Lumières vibes
  'marseille': 'https://images.unsplash.com/photo-1506157786151-b8091532f063?w=800&q=80', // Fiesta
  'bordeaux': 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=800&q=80', // Terrasse festive
  'toulouse': 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800&q=80',
  'nantes': 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800&q=80', // Confettis
  'strasbourg': 'https://images.unsplash.com/photo-1482575832494-771f74bf6857?w=800&q=80', // Marché Noël
  'nice': 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800&q=80', // Carnaval
  'montpellier': 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=800&q=80',
  'rennes': 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&q=80',
};

/// Image par défaut : ambiance concert/festival colorée
const _defaultHeroImage = 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800&q=80';

/// Hero contextuel avec titres dynamiques selon le contexte (heure, jour, saison, ville)
/// et effet parallax au scroll.
class ContextualHero extends ConsumerWidget {
  /// Offset de scroll pour l'effet parallax (valeur négative = scroll vers le bas)
  final double scrollOffset;

  /// Hauteur totale du hero
  final double height;

  const ContextualHero({
    super.key,
    this.scrollOffset = 0,
    this.height = 420,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsyncValue = ref.watch(mobileAppConfigProvider);
    final currentUser = ref.watch(currentUserProvider);
    final userLocationAsync = ref.watch(userLocationProvider);
    final alertsState = ref.watch(alertsProvider);

    // Get config or default
    final config = configAsyncValue.valueOrNull ?? MobileAppConfig.defaultConfig();
    final heroConfig = config.hero;
    final cityName = userLocationAsync.valueOrNull?.cityName;

    // Determine hero image: API config > city-specific > default
    final String heroImageUrl;
    if (heroConfig.image.isNotEmpty) {
      heroImageUrl = heroConfig.image;
    } else if (cityName != null) {
      final cityKey = cityName.toLowerCase().trim();
      heroImageUrl = _cityImages[cityKey] ?? _defaultHeroImage;
    } else {
      heroImageUrl = _defaultHeroImage;
    }

    // Build context-aware content
    final contextData = _buildContextualContent(cityName);
    final greetingMessage = _buildGreeting(currentUser?.firstName);

    // Get saved searches (alerts)
    final savedAlerts = alertsState.valueOrNull?.take(5).toList() ?? [];

    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Layer 1: Background Image with Parallax Effect
          Positioned(
            top: -scrollOffset * 0.5, // Parallax: image moves at half speed
            left: 0,
            right: 0,
            child: SizedBox(
              height: height + 100, // Extra height for parallax movement
              child: CachedNetworkImage(
                imageUrl: heroImageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildGradientBackground(),
                errorWidget: (context, url, error) => _buildGradientBackground(),
              ),
            ),
          ),

          // Layer 2: Dark Overlay for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // Layer 3: Content
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Personalized greeting for logged-in users
                    if (greetingMessage != null) ...[
                      Text(
                        greetingMessage,
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFFFF601F),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 4,
                              color: Colors.black.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],

                    // Contextual title (dynamic)
                    Text(
                      contextData.title,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            offset: const Offset(0, 2),
                            blurRadius: 6,
                            color: Colors.black.withValues(alpha: 0.9),
                          ),
                        ],
                      ),
                    ),

                    if (contextData.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        contextData.subtitle,
                        style: GoogleFonts.montserrat(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black.withValues(alpha: 0.7),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const Spacer(),

                    // Search pill
                    const HomeSearchPill(),

                    // Saved searches (alerts) chips
                    if (savedAlerts.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _SavedSearchesChips(
                        alerts: savedAlerts,
                        onAlertTap: (alert) {
                          // Apply filter and navigate to search
                          ref.read(eventFilterProvider.notifier).applyFilters(alert.filter);
                          context.push('/search');
                        },
                      ),
                    ],

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build gradient background fallback
  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A8A), // Deep blue
            Color(0xFF3B82F6), // Light blue
            Color(0xFF8B5CF6), // Purple touch
          ],
        ),
      ),
    );
  }

  /// Build personalized greeting based on time of day
  String? _buildGreeting(String? firstName) {
    if (firstName == null || firstName.isEmpty) return null;

    final hour = DateTime.now().hour;
    String greeting;

    if (hour >= 5 && hour < 12) {
      greeting = 'Bonjour';
    } else if (hour >= 12 && hour < 18) {
      greeting = 'Bon après-midi';
    } else if (hour >= 18 && hour < 22) {
      greeting = 'Bonsoir';
    } else {
      greeting = 'Bonne nuit';
    }

    return '$greeting $firstName !';
  }

  /// Build contextual content based on time, day, season, and location
  _ContextualContent _buildContextualContent(String? cityName) {
    final now = DateTime.now();
    final hour = now.hour;
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday
    final month = now.month;

    // Determine time context
    final bool isMorning = hour >= 5 && hour < 12;
    final bool isAfternoon = hour >= 12 && hour < 18;
    final bool isEvening = hour >= 18 && hour < 22;
    final bool isNight = hour >= 22 || hour < 5;

    // Determine day context
    final bool isWeekend = weekday == 6 || weekday == 7;
    final bool isFriday = weekday == 5;

    // Determine season
    final _Season season = _getSeason(month);

    // Build title
    String title;
    String subtitle;

    if (isNight) {
      title = cityName != null
          ? 'Sorties nocturnes à $cityName'
          : 'Sorties nocturnes';
      subtitle = 'Concerts, spectacles et soirées';
    } else if (isMorning) {
      if (isWeekend) {
        title = cityName != null
            ? 'Ce week-end à $cityName'
            : 'Ce week-end';
        subtitle = 'Les meilleures activités vous attendent';
      } else {
        title = cityName != null
            ? 'Bonne journée à $cityName'
            : 'Bonne journée';
        subtitle = 'Découvrez les activités du jour';
      }
    } else if (isAfternoon) {
      if (isWeekend) {
        title = cityName != null
            ? 'Cet après-midi à $cityName'
            : 'Cet après-midi';
        subtitle = 'Profitez de votre week-end';
      } else {
        title = cityName != null
            ? 'Activités à $cityName'
            : 'Activités près de vous';
        subtitle = 'Pour occuper votre après-midi';
      }
    } else if (isEvening) {
      if (isFriday || isWeekend) {
        title = cityName != null
            ? 'Ce soir à $cityName'
            : 'Ce soir';
        subtitle = 'Les sorties du week-end commencent';
      } else {
        title = cityName != null
            ? 'Ce soir à $cityName'
            : 'Ce soir';
        subtitle = 'Après le travail, on se détend';
      }
    } else {
      title = cityName != null
          ? 'Découvrez $cityName'
          : 'Découvrez les activités';
      subtitle = 'Trouvez votre prochaine sortie';
    }

    // Add seasonal touch
    switch (season) {
      case _Season.summer:
        if (title.contains('Découvrez')) {
          subtitle = 'Profitez des activités estivales';
        }
        break;
      case _Season.winter:
        if (isEvening || isNight) {
          subtitle = 'Réchauffez vos soirées';
        }
        break;
      case _Season.spring:
        if (isMorning || isAfternoon) {
          subtitle = 'Le printemps est là, sortez !';
        }
        break;
      case _Season.autumn:
        if (isWeekend) {
          subtitle = 'Les couleurs de l\'automne vous attendent';
        }
        break;
    }

    return _ContextualContent(title: title, subtitle: subtitle);
  }

  _Season _getSeason(int month) {
    if (month >= 3 && month <= 5) return _Season.spring;
    if (month >= 6 && month <= 8) return _Season.summer;
    if (month >= 9 && month <= 11) return _Season.autumn;
    return _Season.winter;
  }
}

enum _Season { spring, summer, autumn, winter }

class _ContextualContent {
  final String title;
  final String subtitle;

  _ContextualContent({required this.title, required this.subtitle});
}

/// Chips des recherches sauvegardées
class _SavedSearchesChips extends StatelessWidget {
  final List<dynamic> alerts;
  final Function(dynamic) onAlertTap;

  const _SavedSearchesChips({
    required this.alerts,
    required this.onAlertTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: alerts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return GestureDetector(
            onTap: () => onAlertTap(alert),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.notifications_active_outlined,
                    color: Color(0xFFFF601F),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    alert.name,
                    style: const TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
