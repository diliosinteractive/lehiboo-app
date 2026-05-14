import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/models/event_filter.dart';

extension SearchL10n on BuildContext {
  String searchDateFilterLabel(DateFilterType type) {
    final l10n = this.l10n;
    return switch (type) {
      DateFilterType.today => l10n.searchDateToday,
      DateFilterType.tomorrow => l10n.searchDateTomorrow,
      DateFilterType.thisWeek => l10n.searchDateThisWeek,
      DateFilterType.thisWeekend => l10n.searchDateThisWeekend,
      DateFilterType.thisMonth => l10n.searchDateThisMonth,
      DateFilterType.custom => l10n.searchDateCustom,
    };
  }

  String? searchDateFilterLabelOrNull(EventFilter filter) {
    final type = filter.dateFilterType;
    return type == null ? null : searchDateFilterLabel(type);
  }

  String? searchPriceFilterLabel(EventFilter filter) {
    final l10n = this.l10n;
    if (filter.onlyFree) return l10n.commonFree;

    return switch (filter.priceFilterType) {
      PriceFilterType.free => l10n.commonFree,
      PriceFilterType.paid => l10n.searchPricePaid,
      PriceFilterType.range => l10n.searchPriceRange(
          filter.priceMin.toInt(),
          filter.priceMax.toInt(),
        ),
      null => null,
    };
  }

  String searchLocationTypeLabel(LocationTypeFilter type) {
    final l10n = this.l10n;
    return switch (type) {
      LocationTypeFilter.physical => l10n.searchLocationTypePhysical,
      LocationTypeFilter.offline => l10n.searchLocationTypeOffline,
      LocationTypeFilter.online => l10n.searchLocationTypeOnline,
      LocationTypeFilter.hybrid => l10n.searchLocationTypeHybrid,
    };
  }

  String searchSortOptionLabel(SortOption option) {
    final l10n = this.l10n;
    return switch (option) {
      SortOption.relevance => l10n.searchSortRelevance,
      SortOption.newest => l10n.searchSortNewest,
      SortOption.dateAsc => l10n.searchSortDateAsc,
      SortOption.dateDesc => l10n.searchSortDateDesc,
      SortOption.priceAsc => l10n.searchSortPriceAsc,
      SortOption.priceDesc => l10n.searchSortPriceDesc,
      SortOption.popularity => l10n.searchSortPopularity,
      SortOption.distance => l10n.searchSortDistance,
    };
  }

  String searchActionLabel(int count) {
    return count == 1
        ? l10n.searchActionWithActivity(count)
        : l10n.searchActionWithActivities(count);
  }

  String searchClearAllLabel(int count) => l10n.searchClearAllWithCount(count);

  String searchAroundMeLabel(num radiusKm) {
    return l10n.searchAroundMeWithRadius(radiusKm.round());
  }

  String searchWithinRadiusLabel(num radiusKm) {
    return l10n.searchWithinRadius(radiusKm.round());
  }

  String searchCityRadiusLabel(String cityName, num radiusKm) {
    return l10n.searchCityWithRadius(cityName, radiusKm.round());
  }

  String searchRadiusAroundCityLabel(String cityName) {
    return l10n.searchRadiusAroundCity(cityName);
  }

  String searchMinCharactersLabel(int count) => l10n.searchMinCharacters(count);
}
