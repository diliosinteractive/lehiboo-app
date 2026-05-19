import 'package:flutter/widgets.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_question.dart';

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

  String eventQuestionStatusLabel(QuestionStatus status) {
    final l10n = this.l10n;
    return switch (status) {
      QuestionStatus.pending => l10n.eventQuestionStatusPending,
      QuestionStatus.approved => l10n.eventQuestionStatusApproved,
      QuestionStatus.answered => l10n.eventQuestionStatusAnswered,
      QuestionStatus.rejected => l10n.eventQuestionStatusRejected,
    };
  }

  String eventServiceLabel(String key) {
    final l10n = this.l10n;
    return switch (key) {
      'materiel' => l10n.eventServiceEquipment,
      'animateur' => l10n.eventServiceFacilitator,
      'hebergement' => l10n.eventServiceAccommodation,
      'vestiaire' => l10n.eventServiceCloakroom,
      'securite' => l10n.eventServiceSecurity,
      'premiers_secours' => l10n.eventServiceFirstAid,
      'garderie' => l10n.eventServiceChildcare,
      'photobooth' => l10n.eventServicePhotoBooth,
      _ => _titleCaseApiKey(key),
    };
  }

  String eventAccessibilityFeatureLabel(String key) {
    final l10n = this.l10n;
    return switch (key) {
      'pmr' => l10n.eventAccessibilityPmr,
      'lsf' => l10n.eventAccessibilitySignLanguage,
      'ascenseur' => l10n.eventAccessibilityElevator,
      'stationnement_handicap' => l10n.eventAccessibilityDisabledParking,
      'places_handicap' => l10n.eventAccessibilityDisabledSeats,
      'chien_guide' => l10n.eventAccessibilityGuideDog,
      'boucle_magnetique' => l10n.eventAccessibilityHearingLoop,
      'audiodescription' => l10n.eventAccessibilityAudioDescription,
      'braille' => l10n.eventAccessibilityBraille,
      _ => _titleCaseApiKey(key),
    };
  }

  String eventSlotDateRange({
    required DateTime date,
    String? startTime,
    String? endTime,
  }) {
    final dateLabel = appDateFormat(
      'E d MMM yyyy',
      enPattern: 'EEE, MMM d, y',
    ).format(date);
    final start = _stripSeconds(startTime);
    final end = _stripSeconds(endTime);
    if (start != null && end != null) {
      return l10n.eventDateFromTo(dateLabel, start, end);
    }
    if (start != null) {
      return l10n.eventDateAtStart(dateLabel, start);
    }
    return dateLabel;
  }
}

String? _stripSeconds(String? time) {
  if (time == null || time.isEmpty) return null;
  final parts = time.split(':');
  if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
  return time;
}

String _titleCaseApiKey(String key) {
  final label = key.replaceAll('_', ' ').trim();
  if (label.isEmpty) return key;
  return label[0].toUpperCase() + label.substring(1);
}
