import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/home/presentation/providers/user_location_provider.dart';
// Note: Import commenté car la fonctionnalité favoris n'est pas encore utilisée dans le scoring
// import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';

import 'event_card.dart';

/// Provider pour l'historique de navigation des catégories
final categoryHistoryProvider = StateNotifierProvider<CategoryHistoryNotifier, Map<String, int>>((ref) {
  return CategoryHistoryNotifier();
});

class CategoryHistoryNotifier extends StateNotifier<Map<String, int>> {
  CategoryHistoryNotifier() : super({}) {
    _loadHistory();
  }

  static const _storageKey = 'category_view_history';

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final Map<String, dynamic> decoded = json.decode(jsonString);
        state = decoded.map((key, value) => MapEntry(key, value as int));
      }
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, json.encode(state));
    } catch (e) {
      // Silently fail
    }
  }

  /// Enregistre une vue sur une catégorie
  Future<void> recordCategoryView(String categorySlug) async {
    state = {
      ...state,
      categorySlug: (state[categorySlug] ?? 0) + 1,
    };
    await _saveHistory();
  }

  /// Retourne le score d'intérêt pour une catégorie (0-10)
  int getInterestScore(String categorySlug) {
    final views = state[categorySlug] ?? 0;
    // Score plafonné à 10, basé sur les vues
    return views.clamp(0, 10);
  }
}

/// Provider pour les activités personnalisées avec scoring
final personalizedActivitiesProvider = FutureProvider<List<ScoredActivity>>((ref) async {
  final allActivities = await ref.watch(homeActivitiesProvider.future);
  final todayActivities = await ref.watch(homeTodayActivitiesProvider.future);
  final tomorrowActivities = await ref.watch(homeTomorrowActivitiesProvider.future);

  // Combine all activities
  final activities = <Activity>{
    ...allActivities,
    ...todayActivities,
    ...tomorrowActivities,
  }.toList();

  if (activities.isEmpty) return [];

  // Get scoring factors
  final categoryHistory = ref.watch(categoryHistoryProvider);
  final userLocation = ref.watch(userLocationProvider).valueOrNull;
  // Note: favorites pourrait être utilisé pour scorer les partenaires favoris
  // final favorites = ref.watch(favoritesProvider);

  // Score each activity
  final scored = activities.map((activity) {
    double score = 0;

    // +3 points if category was previously viewed
    if (activity.category != null) {
      final categoryScore = categoryHistory[activity.category!.slug] ?? 0;
      score += (categoryScore * 0.3).clamp(0, 3);
    }

    // +2 points if within 10km (when location available)
    if (userLocation != null && activity.city != null) {
      // Simplified: just check if same city
      if (activity.city!.name.toLowerCase() == userLocation.cityName?.toLowerCase()) {
        score += 2;
      }
    }

    // +1 point if partner is in favorites
    // (simplified: check if any favorite matches this activity's partner)
    // This would need actual partner favorite tracking

    // +0.5 point for free activities (user preference for deals)
    if (activity.priceMin == 0) {
      score += 0.5;
    }

    // +1 point if activity is today or tomorrow
    if (activity.nextSlot != null) {
      final now = DateTime.now();
      final diff = activity.nextSlot!.startDateTime.difference(now);
      if (diff.inDays <= 1 && diff.inHours > 0) {
        score += 1;
      }
    }

    return ScoredActivity(activity: activity, score: score);
  }).toList();

  // Sort by score descending
  scored.sort((a, b) => b.score.compareTo(a.score));

  // Return top 10
  return scored.take(10).toList();
});

/// Activity with a personalization score
class ScoredActivity {
  final Activity activity;
  final double score;

  ScoredActivity({required this.activity, required this.score});
}

/// Section "Pour vous" avec algorithme de personnalisation
class PersonalizedSection extends ConsumerWidget {
  const PersonalizedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalizedAsync = ref.watch(personalizedActivitiesProvider);

    return personalizedAsync.when(
      data: (scoredActivities) {
        if (scoredActivities.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with sparkle icon
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF601F), Color(0xFFFFB347)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pour vous',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        Text(
                          'Basé sur vos préférences',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/events'),
                    child: const Text(
                      'Voir tout',
                      style: TextStyle(
                        color: Color(0xFFFF601F),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Grid 2 columns
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildPersonalizedGrid(scoredActivities, ref),
            ),

            const SizedBox(height: 24),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildPersonalizedGrid(List<ScoredActivity> activities, WidgetRef ref) {
    // Take first 4 for the grid
    final gridActivities = activities.take(4).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.52, // Plus d'espace pour le contenu complet
      ),
      itemCount: gridActivities.length,
      itemBuilder: (context, index) {
        final scored = gridActivities[index];
        // Enregistrer la catégorie quand on navigue
        return GestureDetector(
          onTap: () {
            if (scored.activity.category != null) {
              ref
                  .read(categoryHistoryProvider.notifier)
                  .recordCategoryView(scored.activity.category!.slug);
            }
          },
          child: EventCard(
            activity: scored.activity,
            fillContainer: true,
            heroTagPrefix: 'personalized',
          ),
        );
      },
    );
  }
}

