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
  final bool isLoading;
  final String? error;
  final bool isRefreshing;
  final int currentPage;
  final bool hasMorePages;

  const BookingsListState({
    this.allBookings = const [],
    this.currentFilter = BookingFilterType.all,
    this.isLoading = false,
    this.error,
    this.isRefreshing = false,
    this.currentPage = 1,
    this.hasMorePages = true,
  });

  List<Booking> get filteredBookings {
    final now = DateTime.now();

    switch (currentFilter) {
      case BookingFilterType.all:
        return allBookings;
      case BookingFilterType.upcoming:
        return allBookings.where((b) {
          if (b.status == 'cancelled' || b.status == 'refunded') return false;
          final slotDate = b.slot?.startDateTime;
          return slotDate != null && slotDate.isAfter(now);
        }).toList();
      case BookingFilterType.past:
        return allBookings.where((b) {
          if (b.status == 'cancelled' || b.status == 'refunded') return false;
          final slotDate = b.slot?.startDateTime;
          return slotDate != null && slotDate.isBefore(now);
        }).toList();
      case BookingFilterType.cancelled:
        return allBookings.where((b) =>
            b.status == 'cancelled' || b.status == 'refunded').toList();
    }
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
    bool? isLoading,
    String? error,
    bool? isRefreshing,
    int? currentPage,
    bool? hasMorePages,
  }) {
    return BookingsListState(
      allBookings: allBookings ?? this.allBookings,
      currentFilter: currentFilter ?? this.currentFilter,
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
    try {
      if (refresh) {
        state = state.copyWith(isRefreshing: true, error: null);
      } else {
        state = state.copyWith(isLoading: true, error: null);
      }

      final bookings = await bookingRepository.getMyBookings();

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
      );
    } catch (e) {
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
