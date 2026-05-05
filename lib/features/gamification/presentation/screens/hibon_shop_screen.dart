
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/gamification_provider.dart';
import '../../data/models/hibon_transaction.dart';
import '../widgets/hibon_counter_widget.dart';

const _pillarFilters = <Map<String, String>>[
  {'key': 'onboarding', 'label': 'Onboarding'},
  {'key': 'engagement', 'label': 'Engagement'},
  {'key': 'discovery', 'label': 'Découverte'},
  {'key': 'participation', 'label': 'Participation'},
  {'key': 'community', 'label': 'Communauté'},
];

class HibonShopScreen extends ConsumerStatefulWidget {
  const HibonShopScreen({super.key});

  @override
  ConsumerState<HibonShopScreen> createState() => _HibonShopScreenState();
}

class _HibonShopScreenState extends ConsumerState<HibonShopScreen> {
  String? _pillarFilter;

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(hibonTransactionsProvider(_pillarFilter));
    final walletAsync = ref.watch(gamificationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boutique Hibons'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: HibonCounterWidget(compact: true),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Balance
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF8A65), Color(0xFFFF601F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                   walletAsync.when(
                    data: (wallet) => Text(
                      '${wallet.balance}',
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    loading: () => const CircularProgressIndicator(color: Colors.white),
                    error: (e, s) => const Text('---', style: TextStyle(color: Colors.white)),
                  ),
                  const Text('Hibons disponibles', style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),

            // Shop Sections
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Boosters & Utilitaires', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildShopItem(
                    context, 
                    ref,
                    title: 'Streak Shield',
                    description: 'Protégez votre série pour 1 jour',
                    price: 150,
                    icon: Icons.shield,
                    color: Colors.blue,
                    onTap: () => _buyItem(context, ref, 'Streak Shield', 150),
                  ),
                  const SizedBox(height: 8),
                   _buildShopItem(
                    context, 
                    ref,
                    title: 'Hibou Express (24h)',
                    description: 'Messages illimités avec Petit Boo',
                    price: 300,
                    icon: Icons.chat_bubble,
                    color: Colors.purple,
                    onTap: () => _buyItem(context, ref, 'Hibou Express', 300),
                  ),
                  const SizedBox(height: 8),
                   _buildShopItem(
                    context, 
                    ref,
                    title: 'Multiplicateur x1.5 (1h)',
                    description: 'Gagnez plus de Hibons pendant 1h',
                    price: 100,
                    icon: Icons.bolt,
                    color: Colors.amber,
                    onTap: () => _buyItem(context, ref, 'Multiplicateur Hibons', 100),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text('Packs de Hibons (Bientôt)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 12),
                  // Placeholder for IAP
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Center(child: Text('Les achats In-App arrivent bientôt !')),
                  ),

                  const SizedBox(height: 24),
                  const Text('Historique', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('Tous'),
                          selected: _pillarFilter == null,
                          onSelected: (_) => setState(() => _pillarFilter = null),
                        ),
                        const SizedBox(width: 8),
                        for (final p in _pillarFilters) ...[
                          FilterChip(
                            label: Text(p['label']!),
                            selected: _pillarFilter == p['key'],
                            onSelected: (selected) => setState(
                              () => _pillarFilter = selected ? p['key'] : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  transactionsAsync.when(
                    data: (result) {
                      final txs = result.items;
                      if (txs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: Text('Aucune transaction')),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: min(txs.length, 5),
                        itemBuilder: (context, index) {
                          final tx = txs[index];
                          final pillarColor = _parsePillarColor(tx.pillarColor);
                          final isEarn = tx.type == TransactionType.earn;
                          return ListTile(
                            leading: tx.context?.imageUrl != null
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(tx.context!.imageUrl!),
                                  )
                                : CircleAvatar(
                                    backgroundColor: pillarColor != null
                                        ? pillarColor.withValues(alpha: 0.15)
                                        : (isEarn
                                            ? Colors.green.shade100
                                            : Colors.red.shade100),
                                    child: Icon(
                                      isEarn
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: pillarColor ??
                                          (isEarn ? Colors.green : Colors.red),
                                      size: 20,
                                    ),
                                  ),
                            title: Text(tx.title ?? tx.description),
                            subtitle: Text(
                              tx.subtitle != null
                                  ? '${tx.subtitle} • ${DateFormat('dd/MM HH:mm').format(tx.timestamp)}'
                                  : DateFormat('dd/MM/yyyy HH:mm')
                                      .format(tx.timestamp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              tx.formattedAmount ??
                                  '${isEarn ? '+' : '-'}${tx.amount}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isEarn ? Colors.green : Colors.red,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Text('Erreur: $e'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopItem(BuildContext context, WidgetRef ref, {required String title, required String description, required int price, required IconData icon, required Color color, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF601F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text('$price H'),
        ),
      ),
    );
  }

  Color? _parsePillarColor(String? hex) {
    if (hex == null) return null;
    final cleaned = hex.replaceAll('#', '');
    final value = int.tryParse(cleaned, radix: 16);
    if (value == null) return null;
    if (cleaned.length == 6) return Color(0xFF000000 | value);
    return Color(value);
  }

  void _buyItem(BuildContext context, WidgetRef ref, String itemName, int price) async {
    // Check balance first (Optimistic check)
    final wallet = ref.read(gamificationNotifierProvider).value;
    if (wallet != null && wallet.balance < price) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hibons insuffisants !')));
       return;
    }

    try {
      final repo = ref.read(gamificationRepositoryProvider);
      
      // Special logic for shield
      if (itemName == 'Streak Shield') {
         await repo.buyStreakShield();
      } else {
         await repo.buyShopItem(itemName, price);
      }
      
      ref.invalidate(gamificationNotifierProvider);
      ref.invalidate(hibonTransactionsProvider); // Refresh all family combos
      
      if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Achat effectué : $itemName')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }
}
