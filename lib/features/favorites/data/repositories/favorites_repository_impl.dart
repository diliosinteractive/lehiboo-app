import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../events/domain/entities/event.dart';
import '../../domain/entities/favorite_list.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_api_datasource.dart';
import '../models/toggle_favorite_result.dart';

final favoritesRepositoryImplProvider = Provider<FavoritesRepository>((ref) {
  final apiDataSource = ref.read(favoritesApiDataSourceProvider);
  return FavoritesRepositoryImpl(apiDataSource);
});

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesApiDataSource _apiDataSource;

  FavoritesRepositoryImpl(this._apiDataSource);

  // ==================== FAVORIS ====================

  @override
  Future<List<Event>> getFavorites({String? listId}) async {
    final favorites = await _apiDataSource.getFavorites(listId: listId);

    return favorites.map((f) {
      final startDate = _resolveStart(f);
      final endDate = _resolveEnd(f, startDate);

      return Event(
        // Use stringId (prefers uuid, falls back to id.toString())
        id: f.stringId,
        slug: f.slug,
        title: f.title,
        description: '',
        shortDescription: '',
        category: EventCategory.other,
        targetAudiences: const [EventAudience.all],
        startDate: startDate,
        endDate: endDate,
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
        organizerName: f.organizerName ?? '',
        organizerLogo: f.organizerLogo,
        isFavorite: true,
        isFeatured: false,
        isRecommended: false,
        status: f.isUpcoming ? EventStatus.upcoming : EventStatus.completed,
        hasDirectBooking: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        views: 0,
        // Store internal numeric ID and list info for API calls
        additionalInfo: {
          'internal_id': f.id,
          if (f.listId != null) 'list_id': f.listId,
          if (f.listName != null) 'list_name': f.listName,
          if (f.listColor != null) 'list_color': f.listColor,
          if (f.listIcon != null) 'list_icon': f.listIcon,
        },
      );
    }).toList();
  }

  @override
  Future<ToggleFavoriteResult> addToFavorites(String eventUuid, {String? listId}) async {
    return await _apiDataSource.addToFavorites(eventUuid, listId: listId);
  }

  @override
  Future<void> removeFromFavorites(String eventUuid) async {
    await _apiDataSource.removeFromFavorites(eventUuid);
  }

  @override
  Future<bool> isFavorite(String eventUuid) async {
    return await _apiDataSource.isFavorite(eventUuid);
  }

  @override
  Future<ToggleFavoriteResult> toggleFavorite(String eventUuid, {String? listId}) async {
    return await _apiDataSource.toggleFavorite(eventUuid, listId: listId);
  }

  @override
  Future<void> moveFavoriteToList(String eventUuid, String? listId) async {
    await _apiDataSource.moveFavoriteToList(eventUuid, listId);
  }

  // ==================== LISTES ====================

  @override
  Future<List<FavoriteList>> getLists() async {
    final lists = await _apiDataSource.getLists();
    return lists.map((l) => l.toEntity()).toList();
  }

  @override
  Future<FavoriteList> createList({
    required String name,
    String? description,
    String? color,
    String? icon,
  }) async {
    final listDto = await _apiDataSource.createList(
      name: name,
      description: description,
      color: color,
      icon: icon,
    );
    return listDto.toEntity();
  }

  @override
  Future<FavoriteList> getListDetails(String listId) async {
    final listDto = await _apiDataSource.getListDetails(listId);
    return listDto.toEntity();
  }

  @override
  Future<FavoriteList> updateList(
    String listId, {
    String? name,
    String? description,
    String? color,
    String? icon,
  }) async {
    final listDto = await _apiDataSource.updateList(
      listId,
      name: name,
      description: description,
      color: color,
      icon: icon,
    );
    return listDto.toEntity();
  }

  @override
  Future<void> deleteList(String listId) async {
    await _apiDataSource.deleteList(listId);
  }

  @override
  Future<void> reorderLists(List<String> orderedIds) async {
    await _apiDataSource.reorderLists(orderedIds);
  }

  // Prefer the full ISO `start_datetime` (carries the real time). Fall back
  // to stitching the legacy `date` + `time` fields for older payloads.
  DateTime _resolveStart(FavoriteEventDto f) {
    final iso = f.startDatetime;
    if (iso != null) {
      final parsed = DateTime.tryParse(iso);
      if (parsed != null) return parsed;
    }
    return _stitchDateAndTime(f.date, f.time);
  }

  DateTime _resolveEnd(FavoriteEventDto f, DateTime fallback) {
    final iso = f.endDatetime;
    if (iso != null) {
      final parsed = DateTime.tryParse(iso);
      if (parsed != null) return parsed;
    }
    return fallback;
  }

  DateTime _stitchDateAndTime(String date, String? time) {
    final base = DateTime.tryParse(date) ?? DateTime.now();
    if (time == null) return base;
    final parts = time.split(':');
    if (parts.length < 2) return base;
    return DateTime(
      base.year,
      base.month,
      base.day,
      int.tryParse(parts[0]) ?? 0,
      int.tryParse(parts[1]) ?? 0,
    );
  }
}
