import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/l10n.dart';
import '../../data/models/daily_reward.dart';
import '../../data/models/hibons_wallet.dart';
import '../providers/gamification_provider.dart';
import '../widgets/daily_reward_widget.dart';
import '../widgets/earnings_by_pillar_donut.dart';
import '../widgets/hibon_counter_widget.dart';

class GamificationDashboardScreen extends ConsumerWidget {
  const GamificationDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyRewardAsync = ref.watch(dailyRewardProvider);
    final walletAsync = ref.watch(gamificationNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light premium grey
      body: CustomScrollView(
        slivers: [
          // Premium Header
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            backgroundColor: const Color(0xFFFF601F),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient Background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF8A65), Color(0xFFFF601F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Abstract decorative circles
                  Positioned(
                    right: -50,
                    top: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30,
                    bottom: 50,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Content
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        walletAsync.when(
                          data: (wallet) => _buildRankHeader(context, wallet),
                          loading: () => const CircularProgressIndicator(
                              color: Colors.white),
                          error: (_, __) => const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                tooltip: context.l10n.gamificationHowToEarnTitle,
                icon: const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white,
                ),
                onPressed: () => context.push('/hibons/how-to-earn'),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: HibonCounterWidget(compact: true),
              ),
            ],
          ),

          // Donut "Répartition par pilier" (Plan 05)
          const SliverToBoxAdapter(child: EarningsByPillarDonut()),

          // Body Stats & Menu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Reward Section

                  _buildDailyRewardSection(
                      context, ref, walletAsync, dailyRewardAsync),

                  const SizedBox(height: 32),

                  // Feature Grid
                  Text(
                    context.l10n.gamificationActivitiesBonusTitle,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748)),
                  ),
                  const SizedBox(height: 8),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildPremiumCard(
                        context,
                        title: context.l10n.gamificationLuckyWheelTitle,
                        icon: Icons.casino_rounded,
                        color: Colors.purple,
                        gradientColors: [
                          Colors.purple.shade400,
                          Colors.purple.shade700
                        ],
                        onTap: () => context.push('/lucky-wheel'),
                      ),
                      _buildPremiumCard(
                        context,
                        title: context.l10n.gamificationMyBadgesTitle,
                        icon: Icons.military_tech_rounded,
                        color: Colors.blue,
                        gradientColors: [
                          Colors.blue.shade400,
                          Colors.blue.shade700
                        ],
                        onTap: () => context.push('/achievements'),
                      ),
                      _buildPremiumCard(
                        context,
                        title: context.l10n.gamificationChallengesTitle,
                        icon: Icons.flag_rounded,
                        color: Colors.green,
                        gradientColors: [
                          Colors.green.shade400,
                          Colors.green.shade700
                        ],
                        onTap: () {}, // TODO
                      ),
                      _buildPremiumCard(
                        context,
                        title: context.l10n.gamificationShopTitle,
                        icon: Icons.shopping_bag_rounded,
                        color: Colors.orange,
                        gradientColors: [
                          Colors.orange.shade400,
                          Colors.orange.shade700
                        ],
                        onTap: () => context.push('/hibons-shop'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankHeader(BuildContext context, HibonsWallet wallet) {
    final hasNextRank = wallet.nextRank != null;
    final progressFraction = (wallet.progressToNextRank.clamp(0, 100)) / 100.0;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5)),
            ],
          ),
          child: const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFFFF3E0),
            child: Icon(Icons.emoji_events_rounded,
                size: 40, color: Color(0xFFFF601F)),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          wallet.rankLabel,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (hasNextRank) ...[
          Container(
            width: 200,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
            child: Container(
              width: 200 * progressFraction,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (wallet.hibonsToNextRank != null)
            Text(
              context.l10n.gamificationHibonsUntilNextRank(
                wallet.hibonsToNextRank!,
                wallet.nextRankLabel!,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: 2),
          Text(
            context.l10n.gamificationHibonsEarned(wallet.lifetimeEarned),
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ] else ...[
          Text(
            context.l10n.gamificationHibonsEarned(wallet.lifetimeEarned),
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.gamificationMaxRankReached,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPremiumCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required List<Color> gradientColors,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white70, size: 14),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyRewardSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<HibonsWallet> walletAsync,
    AsyncValue<DailyRewardState> dailyRewardAsync,
  ) {
    // Récupérer canClaimDaily du wallet
    final canClaimDaily = walletAsync.maybeWhen(
      data: (wallet) => wallet.canClaimDaily,
      orElse: () => false,
    );

    return dailyRewardAsync.when(
      data: (state) => DailyRewardWidget(
        state: state,
        canClaim: canClaimDaily,
        isLoading: false,
        onClaim: () async {
          try {
            final result = await ref.read(dailyRewardProvider.notifier).claim();
            if (context.mounted && result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.celebration, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text(result.message)),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              // Extraire le message d'erreur de l'API si disponible
              String errorMessage = context.l10n.gamificationDailyClaimError;
              final errorStr = e.toString();
              if (errorStr.contains('déjà réclamé')) {
                errorMessage =
                    context.l10n.gamificationDailyRewardAlreadyClaimed;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: Text(errorMessage)),
                    ],
                  ),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          }
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Text(context.l10n.gamificationErrorWithMessage('$e')),
    );
  }
}
