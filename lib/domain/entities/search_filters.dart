import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filters.freezed.dart';

@freezed
class SearchFilters with _$SearchFilters {
  const factory SearchFilters({
    String? query,
    String? cityId,
    String? categoryId,
    List<String>? ageRangeIds,
    bool? freeOnly,
    bool? indoorOnly,
    bool? outdoorOnly,
    int? durationBucket,
    DateTime? dateFrom,
    DateTime? dateTo,
    double? maxDistanceKm,
  }) = _SearchFilters;
}

@freezed
class Paginated<T> with _$Paginated<T> {
  const factory Paginated({
    required List<T> items,
    required int page,
    required int totalPages,
    required int totalItems,
  }) = _Paginated<T>;
}
