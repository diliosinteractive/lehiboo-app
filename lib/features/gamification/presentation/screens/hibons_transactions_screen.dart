import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../providers/gamification_provider.dart';
import '../widgets/hibon_counter_widget.dart';
import '../widgets/hibon_transaction_tile.dart';

const _pillarFilters = <String>[
  'onboarding',
  'engagement',
  'discovery',
  'participation',
  'community',
];

const _typeFilters = <String>[
  'earned',
  'spent',
  'bonus',
  'purchase',
  'refund',
];

/// Écran dédié à l'historique paginé des transactions Hibons.
class HibonsTransactionsScreen extends ConsumerStatefulWidget {
  const HibonsTransactionsScreen({super.key});

  @override
  ConsumerState<HibonsTransactionsScreen> createState() =>
      _HibonsTransactionsScreenState();
}

class _HibonsTransactionsScreenState
    extends ConsumerState<HibonsTransactionsScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _pillarFilter;
  String? _typeFilter;

  TransactionsFilter get _filter => (type: _typeFilter, pillar: _pillarFilter);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(hibonsTransactionsListProvider(_filter).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final txState = ref.watch(hibonsTransactionsListProvider(_filter));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.gamificationHistoryTitle),
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
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(hibonsTransactionsListProvider(_filter).notifier).refresh(),
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, txState),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filtres par type
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: Text(context.l10n.gamificationAllFilter),
                            selected: _typeFilter == null,
                            onSelected: (_) =>
                                setState(() => _typeFilter = null),
                          ),
                          const SizedBox(width: 8),
                          for (final t in _typeFilters) ...[
                            FilterChip(
                              label: Text(_typeFilterLabel(context, t)),
                              selected: _typeFilter == t,
                              onSelected: (selected) => setState(
                                () => _typeFilter = selected ? t : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Filtres par pilier
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterChip(
                            label: Text(context.l10n.gamificationAllFilter),
                            selected: _pillarFilter == null,
                            onSelected: (_) =>
                                setState(() => _pillarFilter = null),
                          ),
                          const SizedBox(width: 8),
                          for (final p in _pillarFilters) ...[
                            FilterChip(
                              label: Text(_pillarFilterLabel(context, p)),
                              selected: _pillarFilter == p,
                              onSelected: (selected) => setState(
                                () => _pillarFilter = selected ? p : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildTransactionsList(context, txState),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HibonsTransactionsState txState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF8A65), Color(0xFFFF601F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            '${txState.currentBalance}',
            style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Text(context.l10n.gamificationHibonsAvailable,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            context.l10n.gamificationHibonsEarned(txState.lifetimeEarned),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(
      BuildContext context, HibonsTransactionsState txState) {
    return txState.transactions.when(
      data: (txs) {
        if (txs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child:
                Center(child: Text(context.l10n.gamificationNoTransactions)),
          );
        }
        return Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: txs.length,
              itemBuilder: (context, index) =>
                  HibonTransactionTile(transaction: txs[index]),
            ),
            if (txState.isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          context.l10n.gamificationErrorWithMessage(
            ApiResponseHandler.extractError(e),
          ),
        ),
      ),
    );
  }

  String _pillarFilterLabel(BuildContext context, String pillar) {
    switch (pillar) {
      case 'onboarding':
        return context.l10n.gamificationPillarOnboarding;
      case 'engagement':
        return context.l10n.gamificationPillarEngagement;
      case 'discovery':
        return context.l10n.gamificationPillarDiscovery;
      case 'participation':
        return context.l10n.gamificationPillarParticipation;
      case 'community':
        return context.l10n.gamificationPillarCommunity;
      default:
        return pillar;
    }
  }

  String _typeFilterLabel(BuildContext context, String type) {
    switch (type) {
      case 'earned':
        return context.l10n.gamificationTypeEarned;
      case 'spent':
        return context.l10n.gamificationTypeSpent;
      case 'bonus':
        return context.l10n.gamificationTypeBonus;
      case 'purchase':
        return context.l10n.gamificationTypePurchase;
      case 'refund':
        return context.l10n.gamificationTypeRefund;
      default:
        return type;
    }
  }
}
