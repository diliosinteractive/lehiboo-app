import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../events/domain/entities/event.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_api_datasource.dart';

final favoritesRepositoryImplProvider = Provider<FavoritesRepository>((ref) {
  final apiDataSource = ref.read(favoritesApiDataSourceProvider);
  return FavoritesRepositoryImpl(apiDataSource);
});

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesApiDataSource _apiDataSource;

  FavoritesRepositoryImpl(this._apiDataSource);

  @override
  Future<List<Event>> getFavorites() async {
    final favorites = await _apiDataSource.getFavorites();

    return favorites.map((f) {
      final dateTime = DateTime.tryParse(f.date) ?? DateTime.now();
      DateTime startDate = dateTime;

      if (f.time != null) {
        final timeParts = f.time!.split(':');
        if (timeParts.length >= 2) {
          startDate = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
            int.tryParse(timeParts[0]) ?? 0,
            int.tryParse(timeParts[1]) ?? 0,
          );
        }
      }

      return Event(
        id: f.id.toString(),
        title: f.title,
        description: '',
        shortDescription: '',
        category: EventCategory.other,
        targetAudiences: const [EventAudience.all],
        startDate: startDate,
        endDate: startDate,
        venue: f.venue ?? '',
        address: '',
        city: f.city ?? '',
        postalCode: '',
        latitude: 0.0,
        longitude: 0.0,
        images: f.thumbnail != null ? [f.thumbnail!] : [],
        coverImage: f.thumbnail,
        priceType: f.price?.isFree == true ? PriceType.free : PriceType.paid,
        minPrice: f.price?.min,
        maxPrice: f.price?.max,
        isIndoor: true,
        isOutdoor: false,
        tags: const [],
        organizerId: '',
        organizerName: '',
        isFavorite: true,
        isFeatured: false,
        isRecommended: false,
        status: f.isUpcoming ? EventStatus.upcoming : EventStatus.completed,
        hasDirectBooking: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        views: 0,
      );
    }).toList();
  }

  @override
  Future<void> addToFavorites(int eventId) async {
    await _apiDataSource.addToFavorites(eventId);
  }

  @override
  Future<void> removeFromFavorites(int eventId) async {
    await _apiDataSource.removeFromFavorites(eventId);
  }

  @override
  Future<bool> isFavorite(int eventId) async {
    return await _apiDataSource.isFavorite(eventId);
  }

  @override
  Future<bool> toggleFavorite(int eventId) async {
    return await _apiDataSource.toggleFavorite(eventId);
  }
}
