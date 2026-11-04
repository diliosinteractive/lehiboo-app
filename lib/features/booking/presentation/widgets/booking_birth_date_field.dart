import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/account_bound_route_guard.dart';

/// Optional birth date of the person booking, sent as `customer_birth_date`.
///
/// The API and the web take a real birth date: the app no longer asks for an
/// age and invents a date from it. The API only requires a date before today.
class BookingBirthDateField extends ConsumerWidget {
  const BookingBirthDateField({
    super.key,
    required this.value,
    required this.ownerAccountId,
    required this.decoration,
    required this.onChanged,
  });

  /// `yyyy-MM-dd`, or null when unknown.
  final String? value;
  final String? ownerAccountId;
  final InputDecoration decoration;
  final ValueChanged<String?> onChanged;

  bool _ownsSession(WidgetRef ref) =>
      ownerAccountId != null &&
      ref.read(authSessionUserIdProvider) == ownerAccountId;

  Future<void> _pick(
    BuildContext context,
    WidgetRef ref,
    DateTime? current,
  ) async {
    if (!_ownsSession(ref)) return;
    // The UTC day is never later than the API's Europe/Paris day.
    final today = DateTime.now().toUtc();
    final firstDate = DateTime(1900);
    final lastDate = DateTime(today.year, today.month, today.day - 1);
    final initialDate = current != null &&
            !current.isBefore(firstDate) &&
            !current.isAfter(lastDate)
        ? current
        : null;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      // Nothing preselected: confirming untouched must not invent a date.
      initialDatePickerMode:
          initialDate == null ? DatePickerMode.year : DatePickerMode.day,
      helpText: context.l10n.bookingBirthDateHelp,
      builder: (_, child) => AccountBoundRouteGuard<DateTime>(
        ownerAccountId: ownerAccountId,
        builder: (_) => child ?? const SizedBox.shrink(),
      ),
    );
    if (picked == null || !context.mounted || !_ownsSession(ref)) return;
    onChanged(DateFormat('yyyy-MM-dd').format(picked));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parsed = DateTime.tryParse(value ?? '');
    return InkWell(
      key: const ValueKey('booking-birth-date-field'),
      onTap: () => _pick(context, ref, parsed),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        isEmpty: parsed == null,
        decoration: decoration.copyWith(
          suffixIcon: parsed != null
              ? IconButton(
                  key: const ValueKey('booking-birth-date-clear'),
                  icon: const Icon(Icons.clear, size: 20),
                  tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
                  onPressed: () => onChanged(null),
                )
              : const Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(
          parsed == null
              ? ''
              : context
                  .appDateFormat('dd/MM/yyyy', enPattern: 'MM/dd/yyyy')
                  .format(parsed),
        ),
      ),
    );
  }
}
