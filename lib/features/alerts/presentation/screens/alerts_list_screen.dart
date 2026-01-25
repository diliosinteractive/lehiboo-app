import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/alerts_provider.dart';
import '../../domain/entities/alert.dart';
import '../../../../features/search/presentation/providers/filter_provider.dart';
import '../../../../features/booking/presentation/widgets/filter_tabs_row.dart';

/// Types de filtres pour les alertes
enum AlertFilterType {
  all('all', 'Toutes', Icons.list_alt),
  alerts('alerts', 'Alertes', Icons.notifications_active),
  searches('searches', 'Recherches', Icons.history);

  final String id;
  final String label;
  final IconData icon;

  const AlertFilterType(this.id, this.label, this.icon);
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
      ref.refresh(alertsProvider);
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

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F5), // Orange pastel comme les autres pages
      appBar: AppBar(
        title: const Text(
          'Mes Alertes & Recherches',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
              label: filter.label,
              icon: filter.icon,
              count: alerts.isNotEmpty ? _countForFilter(alerts, filter) : null,
              color: filter == AlertFilterType.alerts
                  ? const Color(0xFFFF601F)
                  : filter == AlertFilterType.searches
                      ? Colors.blueGrey
                      : const Color(0xFFFF601F),
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
                        color: const Color(0xFFFF601F),
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
          child: CircularProgressIndicator(color: Color(0xFFFF601F)),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Impossible de charger vos alertes'),
              TextButton(
                onPressed: () => ref.refresh(alertsProvider),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    String title;
    String message;
    IconData icon;

    switch (_currentFilter) {
      case AlertFilterType.all:
        title = 'Aucune alerte pour le moment';
        message =
            'Enregistrez vos recherches pour les retrouver ici et recevoir des notifications';
        icon = Icons.notifications_none_outlined;
        break;
      case AlertFilterType.alerts:
        title = 'Aucune alerte active';
        message =
            'Activez les notifications sur vos recherches pour être alerté des nouveaux événements';
        icon = Icons.notifications_off_outlined;
        break;
      case AlertFilterType.searches:
        title = 'Aucune recherche enregistrée';
        message = 'Vos recherches sans notification apparaîtront ici';
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
              color: const Color(0xFFFF601F).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: const Color(0xFFFF601F),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
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
                backgroundColor: const Color(0xFFFF601F),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Explorer les activités'),
            ),
          ],
        ],
      ),
    );
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
              title: const Text("Supprimer l'alerte"),
              content: const Text(
                  "Voulez-vous vraiment supprimer cette recherche enregistrée ?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Annuler"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("Supprimer"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        ref.read(alertsProvider.notifier).deleteAlert(alert.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alerte "${alert.name}" supprimée')),
        );
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
                color: Colors.black.withOpacity(0.03),
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
                        ? const Color(0xFFFF601F).withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    alert.enablePush
                        ? Icons.notifications_active
                        : Icons.history,
                    color: alert.enablePush
                        ? const Color(0xFFFF601F)
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
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _buildSubtitle(alert),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Créée le ${DateFormat('dd/MM/yyyy').format(alert.createdAt)}',
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

  String _buildSubtitle(Alert alert) {
    final parts = <String>[];
    if (alert.filter.citySlug != null) {
      parts.add(alert.filter.cityName ?? alert.filter.citySlug!);
    }
    if (alert.filter.thematiquesSlugs.isNotEmpty) {
      parts.add(alert.filter.thematiquesSlugs.first); // Just first one
    }
    if (alert.filter.dateFilterLabel != null) {
      parts.add(alert.filter.dateFilterLabel!);
    }
    if (alert.filter.priceFilterLabel != null) {
      parts.add(alert.filter.priceFilterLabel!);
    }

    if (parts.isEmpty) return 'Tous les événements';
    return parts.join(' • ');
  }
}
