import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart';

// Filter types for bookings
enum BookingFilterType {
  all,
  upcoming,
  past,
  cancelled,
}

// Sort options for bookings
enum BookingSortOption {
  dateAsc,
  dateDesc,
  statusAsc,
}

extension BookingSortOptionExtension on BookingSortOption {
  String get label {
    switch (this) {
      case BookingSortOption.dateAsc:
        return 'Date (plus proche)';
      case BookingSortOption.dateDesc:
        return 'Date (plus lointaine)';
      case BookingSortOption.statusAsc:
        return 'Statut';
    }
  }

  String get id => name;
}

extension BookingFilterTypeExtension on BookingFilterType {
  String get label {
    switch (this) {
      case BookingFilterType.all:
        return 'Tous';
      case BookingFilterType.upcoming:
        return 'À venir';
      case BookingFilterType.past:
        return 'Passés';
      case BookingFilterType.cancelled:
        return 'Annulés';
    }
  }

  String get id => name;
}

// State class for bookings list
class BookingsListState {
  final List<Booking> allBookings;
  final BookingFilterType currentFilter;
  final BookingSortOption sortOption;
  final bool isLoading;
  final String? error;
  final bool isRefreshing;
  final int currentPage;
  final bool hasMorePages;

  const BookingsListState({
    this.allBookings = const [],
    this.currentFilter = BookingFilterType.all,
    this.sortOption = BookingSortOption.dateAsc,
    this.isLoading = false,
    this.error,
    this.isRefreshing = false,
    this.currentPage = 1,
    this.hasMorePages = false, // Pas de pagination pour l'instant
  });

  List<Booking> get filteredBookings {
    final now = DateTime.now();

    List<Booking> filtered;
    switch (currentFilter) {
      case BookingFilterType.all:
        filtered = List.from(allBookings);
        break;
      case BookingFilterType.upcoming:
        filtered = allBookings.where((b) {
          if (b.status == 'cancelled' || b.status == 'refunded') return false;
          final slotDate = b.slot?.startDateTime;
          return slotDate != null && slotDate.isAfter(now);
        }).toList();
        break;
      case BookingFilterType.past:
        filtered = allBookings.where((b) {
          if (b.status == 'cancelled' || b.status == 'refunded') return false;
          final slotDate = b.slot?.startDateTime;
          return slotDate != null && slotDate.isBefore(now);
        }).toList();
        break;
      case BookingFilterType.cancelled:
        filtered = allBookings.where((b) =>
            b.status == 'cancelled' || b.status == 'refunded').toList();
        break;
    }

    // Apply sorting
    filtered.sort((a, b) {
      switch (sortOption) {
        case BookingSortOption.dateAsc:
          final dateA = a.slot?.startDateTime;
          final dateB = b.slot?.startDateTime;
          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return 1;
          if (dateB == null) return -1;
          return dateA.compareTo(dateB);
        case BookingSortOption.dateDesc:
          final dateA = a.slot?.startDateTime;
          final dateB = b.slot?.startDateTime;
          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return 1;
          if (dateB == null) return -1;
          return dateB.compareTo(dateA);
        case BookingSortOption.statusAsc:
          return (a.status ?? '').compareTo(b.status ?? '');
      }
    });

    return filtered;
  }

  // Get count for each filter tab
  int countForFilter(BookingFilterType filter) {
    final now = DateTime.now();
    switch (filter) {
      case BookingFilterType.all:
        return allBookings.length;
      case BookingFilterType.upcoming:
        return allBookings.where((b) {
          if (b.status == 'cancelled' || b.status == 'refunded') return false;
          final slotDate = b.slot?.startDateTime;
          return slotDate != null && slotDate.isAfter(now);
        }).length;
      case BookingFilterType.past:
        return allBookings.where((b) {
          if (b.status == 'cancelled' || b.status == 'refunded') return false;
          final slotDate = b.slot?.startDateTime;
          return slotDate != null && slotDate.isBefore(now);
        }).length;
      case BookingFilterType.cancelled:
        return allBookings.where((b) =>
            b.status == 'cancelled' || b.status == 'refunded').length;
    }
  }

  BookingsListState copyWith({
    List<Booking>? allBookings,
    BookingFilterType? currentFilter,
    BookingSortOption? sortOption,
    bool? isLoading,
    String? error,
    bool? isRefreshing,
    int? currentPage,
    bool? hasMorePages,
  }) {
    return BookingsListState(
      allBookings: allBookings ?? this.allBookings,
      currentFilter: currentFilter ?? this.currentFilter,
      sortOption: sortOption ?? this.sortOption,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }
}

// Provider
final bookingsListControllerProvider =
    StateNotifierProvider<BookingListController, BookingsListState>(
  (ref) {
    final repo = ref.watch(bookingRepositoryProvider);
    return BookingListController(bookingRepository: repo)..loadBookings();
  },
);

class BookingListController extends StateNotifier<BookingsListState> {
  BookingListController({required this.bookingRepository})
      : super(const BookingsListState(isLoading: true));

  final BookingRepository bookingRepository;

  Future<void> loadBookings({bool refresh = false}) async {
    debugPrint('📋 loadBookings called (refresh: $refresh)');
    try {
      if (refresh) {
        state = state.copyWith(isRefreshing: true, error: null);
      } else {
        state = state.copyWith(isLoading: true, error: null);
      }

      debugPrint('📋 Fetching bookings from API...');
      final bookings = await bookingRepository.getMyBookings();
      debugPrint('📋 Got ${bookings.length} bookings from API');

      // Sort bookings: upcoming first by date, then past
      final sortedBookings = List<Booking>.from(bookings)
        ..sort((a, b) {
          final dateA = a.slot?.startDateTime;
          final dateB = b.slot?.startDateTime;
          if (dateA == null && dateB == null) return 0;
          if (dateA == null) return 1;
          if (dateB == null) return -1;
          return dateA.compareTo(dateB);
        });

      state = state.copyWith(
        allBookings: sortedBookings,
        isLoading: false,
        isRefreshing: false,
        error: null,
        hasMorePages: false, // Pas de pagination pour l'instant
      );
    } catch (e) {
      debugPrint('📋 Error loading bookings: $e');
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: e.toString(),
      );
    }
  }

  void setFilter(BookingFilterType filter) {
    state = state.copyWith(currentFilter: filter);
  }

  void setFilterById(String filterId) {
    final filter = BookingFilterType.values.firstWhere(
      (f) => f.id == filterId,
      orElse: () => BookingFilterType.all,
    );
    setFilter(filter);
  }

  void setSortOption(BookingSortOption option) {
    state = state.copyWith(sortOption: option);
  }

  Future<void> refresh() async {
    await loadBookings(refresh: true);
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMorePages) return;

    // For now, we don't have pagination in the repository
    // This is a placeholder for future implementation
    state = state.copyWith(hasMorePages: false);
  }
}

// Legacy provider for backward compatibility
final legacyBookingsListControllerProvider =
    StateNotifierProvider<LegacyBookingListController, AsyncValue<List<Booking>>>(
  (ref) {
    final repo = ref.watch(bookingRepositoryProvider);
    return LegacyBookingListController(bookingRepository: repo)..load();
  },
);

class LegacyBookingListController extends StateNotifier<AsyncValue<List<Booking>>> {
  LegacyBookingListController({required this.bookingRepository})
      : super(const AsyncValue.loading());

  final BookingRepository bookingRepository;

  Future<void> load() async {
    try {
      state = const AsyncValue.loading();
      final bookings = await bookingRepository.getMyBookings();
      state = AsyncValue.data(bookings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
