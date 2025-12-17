
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/gamification_provider.dart';

class HibonCounterWidget extends ConsumerWidget {
  final bool compact;

  const HibonCounterWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(gamificationNotifierProvider);

    return profileAsync.when(
      data: (wallet) { // wallet is HibonsWallet
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 16,
            vertical: compact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFFFA000)], // Gold Gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Coin Icon (Custom or Standard)
              Container(
                 padding: const EdgeInsets.all(2),
                 decoration: const BoxDecoration(
                   color: Colors.white,
                   shape: BoxShape.circle,
                 ),
                 child: const Icon(Icons.stars_rounded, color: Color(0xFFFFA000), size: 16),
              ),
              SizedBox(width: compact ? 6 : 8),
              Text(
                '${wallet.balance}', // Using balance from wallet
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: compact ? 14 : 16,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.black.withOpacity(0.2), offset: const Offset(0, 1), blurRadius: 2),
                  ],
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: 4),
                Text(
                  'Hibons',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        width: 60,
        height: 30,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (err, stack) => const Icon(Icons.error_outline, color: Colors.red),
    );
  }
}
