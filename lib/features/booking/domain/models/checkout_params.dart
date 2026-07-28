import 'package:intl/intl.dart';
import 'package:lehiboo/core/l10n/app_locale.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

/// Paramètres pour l'écran de checkout
class CheckoutParams {
  final Event event;
  final String slotId;
  final CalendarDateSlot? selectedSlot;
  final Map<String, int> ticketQuantities;
  final double totalPrice;
  final String? couponCode;

  const CheckoutParams({
    required this.event,
    required this.slotId,
    this.selectedSlot,
    required this.ticketQuantities,
    required this.totalPrice,
    this.couponCode,
  });

  /// Crée les params depuis un Map (pour la navigation go_router)
  factory CheckoutParams.fromExtra(Map<String, dynamic> extra) {
    return CheckoutParams(
      event: extra['event'] as Event,
      slotId: extra['slotId'] as String,
      selectedSlot: extra['selectedSlot'] as CalendarDateSlot?,
      ticketQuantities: Map<String, int>.from(extra['ticketQuantities'] as Map),
      totalPrice: (extra['totalPrice'] as num).toDouble(),
      couponCode: extra['couponCode'] as String?,
    );
  }

  /// Calcule le nombre total de billets
  int get totalTickets {
    return ticketQuantities.values.fold(0, (sum, qty) => sum + qty);
  }

  /// Vérifie si l'événement est gratuit
  bool get isFree => totalPrice == 0;

  /// Retourne le label formaté de la date
  String? get formattedDate {
    if (selectedSlot == null) return null;

    final slot = selectedSlot!;
    final l10n = cachedAppLocalizations();
    final isEnglish = AppLocaleCache.languageCode == 'en';
    final dateStr = DateFormat(
      isEnglish ? 'EEEE, MMMM d, y' : 'EEEE d MMMM yyyy',
      AppLocaleCache.localeName,
    ).format(slot.date);

    if (slot.startTime != null) {
      return l10n.homeDateAtTime(dateStr, slot.startTime!);
    }

    return dateStr;
  }
}
