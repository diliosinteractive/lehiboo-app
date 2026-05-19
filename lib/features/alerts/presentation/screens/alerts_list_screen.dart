import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../providers/alerts_provider.dart';
import '../../domain/entities/alert.dart';
import '../../../../features/search/presentation/providers/filter_provider.dart';
import '../../../../features/search/presentation/utils/search_l10n.dart';
import '../../../../features/booking/presentation/widgets/filter_tabs_row.dart';
import '../../../../features/petit_boo/presentation/widgets/animated_toast.dart';

/// Types de filtres pour les alertes
enum AlertFilterType {
  all('all', Icons.list_alt),
  alerts('alerts', Icons.notifications_active),
  searches('searches', Icons.history);

  final String id;
  final IconData icon;

  const AlertFilterType(this.id, this.icon);
}

class AlertsListScreen extends ConsumerStatefulWidget {
  const AlertsListScreen({super.key});

  @override
  ConsumerState<AlertsListScreen> createState() => _AlertsListScreenState();
}

class _AlertsListScreenState extends ConsumerState<AlertsListScreen> {
  AlertFilterType _currentFilter = AlertFilterType.all;

  @override
  void initState() {
    super.initState();
    // Refresh alerts when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(alertsProvider);
    });
  }

  List<Alert> _filterAlerts(List<Alert> alerts) {
    switch (_currentFilter) {
      case AlertFilterType.all:
        return alerts;
      case AlertFilterType.alerts:
        return alerts.where((a) => a.enablePush).toList();
      case AlertFilterType.searches:
        return alerts.where((a) => !a.enablePush).toList();
    }
  }

  int _countForFilter(List<Alert> alerts, AlertFilterType filter) {
    switch (filter) {
      case AlertFilterType.all:
        return alerts.length;
      case AlertFilterType.alerts:
        return alerts.where((a) => a.enablePush).length;
      case AlertFilterType.searches:
        return alerts.where((a) => !a.enablePush).length;
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertsAsync = ref.watch(alertsProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor:
          const Color(0xFFFFF8F5), // Orange pastel comme les autres pages
      appBar: AppBar(
        title: Text(
          l10n.alertsListTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: alertsAsync.when(
        data: (alerts) {
          // Build filter tabs with counts
          final filterTabs = AlertFilterType.values.map((filter) {
            return FilterTab(
              id: filter.id,
              label: _filterLabel(context, filter),
              icon: filter.icon,
              count: alerts.isNotEmpty ? _countForFilter(alerts, filter) : null,
              color: filter == AlertFilterType.alerts
                  ? HbColors.brandPrimary
                  : filter == AlertFilterType.searches
                      ? Colors.blueGrey
                      : HbColors.brandPrimary,
            );
          }).toList();

          final filteredAlerts = _filterAlerts(alerts);

          return Column(
            children: [
              // Filter chips
              Container(
                color: Colors.white,
                child: FilterTabsRow(
                  tabs: filterTabs,
                  selectedTabId: _currentFilter.id,
                  onTabSelected: (id) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _currentFilter = AlertFilterType.values.firstWhere(
                        (f) => f.id == id,
                        orElse: () => AlertFilterType.all,
                      );
                    });
                  },
                ),
              ),
              // Divider
              Container(
                height: 1,
                color: Colors.grey.shade200,
              ),
              // Content
              Expanded(
                child: filteredAlerts.isEmpty
                    ? _buildEmptyState(context)
                    : RefreshIndicator(
                        onRefresh: () async {
                          return ref.refresh(alertsProvider);
                        },
                        color: HbColors.brandPrimary,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredAlerts.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _AlertItemCard(alert: filteredAlerts[index]);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(l10n.alertsLoadError),
              TextButton(
                onPressed: () => ref.refresh(alertsProvider),
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = context.l10n;
    String title;
    String message;
    IconData icon;

    switch (_currentFilter) {
      case AlertFilterType.all:
        title = l10n.alertsEmptyAllTitle;
        message = l10n.alertsEmptyAllBody;
        icon = Icons.notifications_none_outlined;
        break;
      case AlertFilterType.alerts:
        title = l10n.alertsEmptyActiveTitle;
        message = l10n.alertsEmptyActiveBody;
        icon = Icons.notifications_off_outlined;
        break;
      case AlertFilterType.searches:
        title = l10n.alertsEmptySearchesTitle;
        message = l10n.alertsEmptySearchesBody;
        icon = Icons.search_off_outlined;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: HbColors.brandPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: HbColors.brandPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textSlate,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          if (_currentFilter == AlertFilterType.all) ...[
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/explore'),
              style: ElevatedButton.styleFrom(
                backgroundColor: HbColors.brandPrimary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(l10n.alertsExploreActivities),
            ),
          ],
        ],
      ),
    );
  }

  String _filterLabel(BuildContext context, AlertFilterType filter) {
    final l10n = context.l10n;
    return switch (filter) {
      AlertFilterType.all => l10n.alertsFilterAll,
      AlertFilterType.alerts => l10n.alertsFilterAlerts,
      AlertFilterType.searches => l10n.alertsFilterSearches,
    };
  }
}

class _AlertItemCard extends ConsumerWidget {
  final Alert alert;

  const _AlertItemCard({required this.alert});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(alert.id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[50], // Lighter red for background
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(context.l10n.alertsDeleteTitle),
              content: Text(context.l10n.alertsDeleteBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(context.l10n.commonCancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(context.l10n.messagesDeleteAction),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        ref.read(alertsProvider.notifier).deleteAlert(alert.id);
        PetitBooToast.success(context, context.l10n.alertsDeleted(alert.name));
      },
      child: GestureDetector(
        onTap: () {
          ref.read(eventFilterProvider.notifier).applyFilters(alert.filter);
          context.push('/search');
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: alert.enablePush
                        ? HbColors.brandPrimary.withValues(alpha: 0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    alert.enablePush
                        ? Icons.notifications_active
                        : Icons.history,
                    color: alert.enablePush
                        ? HbColors.brandPrimary
                        : Colors.grey[500],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: HbColors.textSlate,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _buildSubtitle(context, alert),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.alertsCreatedOn(
                          DateFormat('dd/MM/yyyy').format(alert.createdAt),
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Arrow
                Icon(Icons.chevron_right, color: Colors.grey[300]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildSubtitle(BuildContext context, Alert alert) {
    final parts = <String>[];
    if (alert.filter.citySlug != null) {
      parts.add(alert.filter.cityName ?? alert.filter.citySlug!);
    }
    if (alert.filter.thematiquesSlugs.isNotEmpty) {
      parts.add(alert.filter.thematiquesSlugs.first); // Just first one
    }
    final dateLabel = context.searchDateFilterLabelOrNull(alert.filter);
    if (dateLabel != null) {
      parts.add(dateLabel);
    }
    final priceLabel = context.searchPriceFilterLabel(alert.filter);
    if (priceLabel != null) {
      parts.add(priceLabel);
    }

    if (parts.isEmpty) return context.l10n.alertsAllEvents;
    return parts.join(' • ');
  }
}
