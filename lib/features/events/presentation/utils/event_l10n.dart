import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/event.dart';

extension EventL10n on BuildContext {
  String eventCategoryLabel(EventCategory category) {
    final l10n = this.l10n;
    return switch (category) {
      EventCategory.workshop => l10n.eventCategoryWorkshop,
      EventCategory.show => l10n.eventCategoryShow,
      EventCategory.festival => l10n.eventCategoryFestival,
      EventCategory.concert => l10n.eventCategoryConcert,
      EventCategory.exhibition => l10n.eventCategoryExhibition,
      EventCategory.sport => l10n.eventCategorySport,
      EventCategory.culture => l10n.eventCategoryCulture,
      EventCategory.market => l10n.eventCategoryMarket,
      EventCategory.leisure => l10n.eventCategoryLeisure,
      EventCategory.outdoor => l10n.eventCategoryOutdoor,
      EventCategory.indoor => l10n.eventCategoryIndoor,
      EventCategory.theater => l10n.eventCategoryTheater,
      EventCategory.cinema => l10n.eventCategoryCinema,
      EventCategory.other => l10n.eventCategoryOther,
    };
  }

  String eventAudienceLabel(EventAudience audience) {
    final l10n = this.l10n;
    return switch (audience) {
      EventAudience.all => l10n.eventAudienceAll,
      EventAudience.family => l10n.eventAudienceFamily,
      EventAudience.children => l10n.eventAudienceChildren,
      EventAudience.teenagers => l10n.eventAudienceTeenagers,
      EventAudience.adults => l10n.eventAudienceAdults,
      EventAudience.seniors => l10n.eventAudienceSeniors,
    };
  }

  String eventDateAtTime(String date, String time) {
    return l10n.eventDateAtTime(date, time);
  }

  String eventAllDatesCount(int count) => l10n.eventAllDatesCount(count);

  String eventFiltersWithCount(int count) => l10n.eventFiltersWithCount(count);

  String eventMapEventsHere(int count) => l10n.eventMapEventsHere(count);
}
