import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/themes/colors.dart';
import '../../../gamification/presentation/providers/gamification_provider.dart';
import '../providers/petit_boo_chat_provider.dart';
import 'animated_toast.dart';

/// Dialog shown when user reaches their message limit
class LimitReachedDialog extends ConsumerWidget {
  const LimitReachedDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LimitReachedDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with mascot
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: HbColors.brandPrimary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Mascot
                  ClipOval(
                    child: Image.asset(
                      'assets/images/petit_boo_logo.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: HbColors.brandPrimary.withOpacity(0.3),
                        child: const Center(
                          child: Text('🦉', style: TextStyle(fontSize: 40)),
                        ),
                      ),
                    ),
                  ),
                  // Lock badge
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: const Icon(Icons.lock, color: HbColors.brandPrimary, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    "Oups, c'est déjà fini ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: HbColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Petit Boo a besoin d'énergie pour continuer à chercher "
                    "des pépites pour vous ! Rechargez son stock de Hibons "
                    "pour débloquer la conversation.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Wallet balance and actions
                  Consumer(
                    builder: (context, ref, child) {
                      final walletAsync = ref.watch(gamificationNotifierProvider);

                      return walletAsync.when(
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (e, s) => Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text('Erreur: $e'),
                        ),
                        data: (wallet) => _buildWalletActions(context, ref, wallet.balance),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletActions(BuildContext context, WidgetRef ref, int balance) {
    return Column(
      children: [
        // Balance display
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                "Solde : $balance Hibons",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
        ),

        // Option 1: Spend Hibons (if enough)
        if (balance >= 10)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _spendHibons(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Continuer pour 10 Hibons",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Option 2: Watch Ad
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _watchAd(context, ref),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue[800],
                side: BorderSide(color: Colors.blue.shade200),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_fill, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Regarder une pub (+20 Hibons)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Option 3: Buy more Hibons (if low balance)
        if (balance < 10)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/hibons-shop');
            },
            child: const Text(
              "Recharger mes Hibons",
              style: TextStyle(color: Colors.grey),
            ),
          ),

        // Close button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            "Peut-être plus tard",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Future<void> _spendHibons(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(gamificationNotifierProvider.notifier).spendHibons(
        10,
        "Message Petit Boo",
      );
      ref.read(petitBooChatProvider.notifier).resetLimit();
      if (context.mounted) {
        Navigator.pop(context);
        PetitBooToast.success(context, 'Conversation débloquée !');
      }
    } catch (e) {
      if (context.mounted) {
        PetitBooToast.error(context, 'Erreur: $e');
      }
    }
  }

  Future<void> _watchAd(BuildContext context, WidgetRef ref) async {
    // Show loading dialog (simulates ad)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Mock ad duration
    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.pop(context); // Close loading

      try {
        await ref.read(gamificationNotifierProvider.notifier).earnHibons(
          20,
          "Publicité regardée",
        );
        if (context.mounted) {
          PetitBooToast.success(context, 'Merci ! Vous avez gagné 20 Hibons.');
        }
      } catch (e) {
        // Ignore errors
      }
    }
  }
}
