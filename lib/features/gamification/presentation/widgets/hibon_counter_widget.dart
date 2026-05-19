import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../presentation/providers/gamification_provider.dart';

class HibonCounterWidget extends ConsumerWidget {
  final bool compact;

  const HibonCounterWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only load hibons if user is authenticated
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    if (!isAuthenticated) {
      // Return empty placeholder when not authenticated
      return const SizedBox.shrink();
    }

    final profileAsync = ref.watch(gamificationNotifierProvider);

    // Fallback /balance pendant que /wallet charge au cold start (Plan 05).
    final balanceAsync = ref.watch(hibonsBalanceProvider);
    final fallbackBalance = balanceAsync.value?.balance;

    return profileAsync.when(
      data: (wallet) => _buildBadge(
        context,
        balance: wallet.balance,
        compact: compact,
      ),
      loading: () {
        // Pendant le chargement de /wallet, afficher la balance légère
        // de /balance si disponible (cold start, Plan 05).
        if (fallbackBalance != null) {
          return _buildBadge(
            context,
            balance: fallbackBalance,
            compact: compact,
          );
        }
        return const SizedBox(
          width: 60,
          height: 30,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      error: (err, stack) {
        debugPrint('🎮 HibonCounterWidget ERROR: $err');
        debugPrint('🎮 HibonCounterWidget STACK: $stack');
        // Afficher un placeholder au lieu d'une erreur visible
        // L'utilisateur peut toujours cliquer pour aller au dashboard
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 16,
            vertical: compact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.stars_rounded,
                    color: Colors.grey.shade400, size: 16),
              ),
              SizedBox(width: compact ? 6 : 8),
              Text(
                '---',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: compact ? 14 : 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadge(
    BuildContext context, {
    required int balance,
    required bool compact,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: Color(0xFFFFA000),
              size: 16,
            ),
          ),
          SizedBox(width: compact ? 6 : 8),
          Text(
            '$balance',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: compact ? 14 : 16,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              context.l10n.gamificationHibonsUnit,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
