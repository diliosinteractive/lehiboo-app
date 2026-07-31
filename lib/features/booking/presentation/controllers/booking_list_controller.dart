import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
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
  createdDesc,
  statusAsc,
}

extension BookingSortOptionExtension on BookingSortOption {
  String get id => name;
}

extension BookingFilterTypeExtension on BookingFilterType {
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
    this.sortOption = BookingSortOption.createdDesc,
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
        filtered = allBookings
            .where((b) => b.status == 'cancelled' || b.status == 'refunded')
            .toList();
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
        case BookingSortOption.createdDesc:
          final createdA = a.createdAt;
          final createdB = b.createdAt;
          if (createdA == null && createdB == null) return 0;
          if (createdA == null) return 1;
          if (createdB == null) return -1;
          return createdB.compareTo(createdA);
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
        return allBookings
            .where((b) => b.status == 'cancelled' || b.status == 'refunded')
            .length;
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
    ref.watch(authSessionKeyProvider);
    final hasActiveAccount = ref.watch(authSessionUserIdProvider) != null;
    final repo = ref.watch(bookingRepositoryProvider);
    final controller = BookingListController(
      bookingRepository: repo,
      hasActiveAccount: hasActiveAccount,
    );
    if (hasActiveAccount) controller.loadBookings();
    return controller;
  },
);

class BookingListController extends StateNotifier<BookingsListState> {
  BookingListController({
    required this.bookingRepository,
    required bool hasActiveAccount,
  })  : _hasActiveAccount = hasActiveAccount,
        super(BookingsListState(isLoading: hasActiveAccount));

  final BookingRepository bookingRepository;
  final bool _hasActiveAccount;
  int _loadGeneration = 0;

  Future<void> loadBookings({bool refresh = false}) async {
    if (!mounted) return;
    final requestGeneration = ++_loadGeneration;
    if (!_hasActiveAccount) {
      state = const BookingsListState();
      return;
    }
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
      if (!mounted || requestGeneration != _loadGeneration) return;

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
      if (!mounted || requestGeneration != _loadGeneration) return;
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: ApiResponseHandler.extractError(e),
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
final legacyBookingsListControllerProvider = StateNotifierProvider<
    LegacyBookingListController, AsyncValue<List<Booking>>>(
  (ref) {
    ref.watch(authSessionKeyProvider);
    final hasActiveAccount = ref.watch(authSessionUserIdProvider) != null;
    final repo = ref.watch(bookingRepositoryProvider);
    final controller = LegacyBookingListController(
      bookingRepository: repo,
      hasActiveAccount: hasActiveAccount,
    );
    if (hasActiveAccount) controller.load();
    return controller;
  },
);

class LegacyBookingListController
    extends StateNotifier<AsyncValue<List<Booking>>> {
  LegacyBookingListController({
    required this.bookingRepository,
    required bool hasActiveAccount,
  })  : _hasActiveAccount = hasActiveAccount,
        super(
          hasActiveAccount
              ? const AsyncValue.loading()
              : const AsyncValue.data([]),
        );

  final BookingRepository bookingRepository;
  final bool _hasActiveAccount;
  int _loadGeneration = 0;

  Future<void> load() async {
    if (!mounted) return;
    final requestGeneration = ++_loadGeneration;
    if (!_hasActiveAccount) {
      state = const AsyncValue.data([]);
      return;
    }
    try {
      state = const AsyncValue.loading();
      final bookings = await bookingRepository.getMyBookings();
      if (!mounted || requestGeneration != _loadGeneration) return;
      state = AsyncValue.data(bookings);
    } catch (e, st) {
      if (!mounted || requestGeneration != _loadGeneration) return;
      state = AsyncValue.error(e, st);
    }
  }
}
