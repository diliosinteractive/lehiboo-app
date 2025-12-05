import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/data/repositories/fake_activity_repository_impl.dart';
import 'package:lehiboo/features/booking/data/repositories/fake_booking_repository_impl.dart';

void main() {
  group('FakeActivityRepository', () {
    test('searchActivities returns mocked data', () async {
      final repo = FakeActivityRepositoryImpl();
      final activities = await repo.searchActivities(query: '');
      expect(activities, isNotEmpty);
      expect(activities.first.title, isNotEmpty);
    });

    test('getActivity returns mocked data', () async {
      final repo = FakeActivityRepositoryImpl();
      final activity = await repo.getActivity('1');
      expect(activity, isNotNull);
      expect(activity!.id, '1');
    });
  });

  group('FakeBookingRepository', () {
    test('getMyBookings returns mocked data', () async {
      final repo = FakeBookingRepositoryImpl();
      final bookings = await repo.getMyBookings();
      expect(bookings, isNotEmpty);
      expect(bookings.first.userId, 'user_1');
    });
  });
}
