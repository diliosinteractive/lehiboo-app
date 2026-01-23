import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/core/themes/lehiboo_tokens.dart';
import 'package:lehiboo/core/widgets/feedback/hb_feedback.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_list_controller.dart';
import 'package:lehiboo/features/booking/presentation/widgets/booking_list_card.dart';
import 'package:lehiboo/features/booking/presentation/widgets/filter_tabs_row.dart';
import 'package:lehiboo/features/booking/presentation/widgets/quick_qr_bottom_sheet.dart';

class BookingsListScreen extends ConsumerStatefulWidget {
  const BookingsListScreen({super.key});

  @override
  ConsumerState<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends ConsumerState<BookingsListScreen> {
  final ScrollController _scrollController = ScrollController();

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
      ref.read(bookingsListControllerProvider.notifier).loadMore();
    }
  }

  void _showQuickQR(Booking booking) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickQRBottomSheet(booking: booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingsListControllerProvider);
    final tokens = HbTheme.tokens(context);

    // Build filter tabs with counts
    final filterTabs = BookingFilterType.values.map((filter) {
      return FilterTab(
        id: filter.id,
        label: filter.label,
        count: state.allBookings.isNotEmpty ? state.countForFilter(filter) : null,
      );
    }).toList();

    return Scaffold(
      backgroundColor: HbColors.orangePastel,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mes réservations',
          style: TextStyle(
            color: HbColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: HbColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: HbColors.textPrimary),
            onPressed: () {
              // Could show a filter bottom sheet if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            color: Colors.white,
            child: FilterTabsRow(
              tabs: filterTabs,
              selectedTabId: state.currentFilter.id,
              onTabSelected: (id) {
                ref.read(bookingsListControllerProvider.notifier).setFilterById(id);
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
            child: _buildContent(state, tokens),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BookingsListState state, LeHibooTokens tokens) {
    if (state.isLoading && state.allBookings.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: HbColors.brandPrimary,
        ),
      );
    }

    if (state.error != null && state.allBookings.isEmpty) {
      return HbErrorView(
        message: 'Erreur de chargement: ${state.error}',
        onRetry: () => ref.read(bookingsListControllerProvider.notifier).loadBookings(),
      );
    }

    final bookings = state.filteredBookings;

    if (bookings.isEmpty) {
      return _buildEmptyState(state.currentFilter);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(bookingsListControllerProvider.notifier).refresh(),
      color: HbColors.brandPrimary,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(tokens.spacing.m),
        itemCount: bookings.length + (state.hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= bookings.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: HbColors.brandPrimary,
                  ),
                ),
              ),
            );
          }

          final booking = bookings[index];
          return Padding(
            padding: EdgeInsets.only(bottom: tokens.spacing.m),
            child: BookingListCard(
              booking: booking,
              onTap: () => _navigateToDetail(booking),
              onQRTap: booking.status == 'confirmed'
                  ? () => _showQuickQR(booking)
                  : null,
              onLongPress: booking.status == 'confirmed'
                  ? () => _showQuickQR(booking)
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BookingFilterType filter) {
    String title;
    String message;
    IconData icon;

    switch (filter) {
      case BookingFilterType.all:
        title = 'Aucune réservation';
        message = 'Vous n\'avez pas encore de réservation.\nDécouvrez nos événements !';
        icon = Icons.calendar_today_outlined;
        break;
      case BookingFilterType.upcoming:
        title = 'Aucune réservation à venir';
        message = 'Vous n\'avez pas de réservation prévue.\nExplorez nos événements !';
        icon = Icons.event_available_outlined;
        break;
      case BookingFilterType.past:
        title = 'Aucune réservation passée';
        message = 'Vous n\'avez pas encore participé à un événement.';
        icon = Icons.history_outlined;
        break;
      case BookingFilterType.cancelled:
        title = 'Aucune réservation annulée';
        message = 'Vous n\'avez aucune réservation annulée.';
        icon = Icons.cancel_outlined;
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withOpacity(0.1),
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
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: HbColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: HbColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (filter == BookingFilterType.all ||
                filter == BookingFilterType.upcoming) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/explore'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Explorer les événements',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(Booking booking) {
    context.push('/booking-detail/${booking.id}', extra: booking);
  }
}
