import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/profile_api_datasource.dart';

/// User stats state
class UserStats {
  final int bookingsCount;
  final int favoritesCount;
  final int reviewsCount;
  final int upcomingEventsCount;

  const UserStats({
    this.bookingsCount = 0,
    this.favoritesCount = 0,
    this.reviewsCount = 0,
    this.upcomingEventsCount = 0,
  });

  factory UserStats.fromDto(UserStatsDto dto) {
    return UserStats(
      bookingsCount: dto.bookingsCount,
      favoritesCount: dto.favoritesCount,
      reviewsCount: dto.reviewsCount,
      upcomingEventsCount: dto.upcomingEventsCount,
    );
  }
}

/// Provider to fetch user stats
final userStatsProvider = FutureProvider.autoDispose<UserStats>((ref) async {
  final profileApi = ref.read(profileApiDataSourceProvider);

  try {
    final statsDto = await profileApi.getStats();
    return UserStats.fromDto(statsDto);
  } catch (e) {
    // Return empty stats on error (user might not be authenticated)
    return const UserStats();
  }
});
