import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/domain/entities/booking.dart';
import 'package:lehiboo/features/booking/domain/repositories/booking_repository.dart';
import 'package:lehiboo/features/booking/presentation/controllers/booking_flow_controller.dart'; // import repo provider

final bookingsListControllerProvider =
    StateNotifierProvider<BookingListController, AsyncValue<List<Booking>>>(
  (ref) {
    final repo = ref.watch(bookingRepositoryProvider);
    return BookingListController(bookingRepository: repo)..load();
  },
);

class BookingListController extends StateNotifier<AsyncValue<List<Booking>>> {
  BookingListController({required this.bookingRepository})
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
