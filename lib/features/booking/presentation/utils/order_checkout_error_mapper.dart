import 'package:dio/dio.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/l10n/generated/app_localizations.dart';

enum OrderCheckoutIssue {
  availability,
  minimumQuantity,
  maximumQuantity,
}

/// Converts checkout validation envelopes into actionable, localized copy.
///
/// The API is still the final authority because inventory may change between
/// opening an event and creating an order. Stable machine codes are preferred;
/// legacy French/English messages are recognized only for compatibility with
/// older API deployments.
class OrderCheckoutErrorMapper {
  OrderCheckoutErrorMapper._();

  static OrderCheckoutIssue? issue(Object error) {
    final body = _responseBody(error);
    if (body == null) return null;

    final code = _errorCode(body);
    if (_minimumCodes.contains(code)) {
      return OrderCheckoutIssue.minimumQuantity;
    }
    if (_maximumCodes.contains(code)) {
      return OrderCheckoutIssue.maximumQuantity;
    }
    if (_availabilityCodes.contains(code)) {
      return OrderCheckoutIssue.availability;
    }

    final message = body['message']?.toString().toLowerCase() ?? '';
    if (message.contains('stock insuffisant') ||
        message.contains('insufficient stock') ||
        message.contains('créneau') && message.contains('disponible') ||
        message.contains('creneau') && message.contains('disponible') ||
        message.contains('slot') && message.contains('available') ||
        message.contains('billet') && message.contains('épuis') ||
        message.contains('billet') && message.contains('epuis') ||
        message.contains('ticket') && message.contains('sold out')) {
      return OrderCheckoutIssue.availability;
    }

    return null;
  }

  static bool isExpectedValidation(Object error) => issue(error) != null;

  static String userMessage(Object error, AppLocalizations l10n) {
    final body = _responseBody(error);

    switch (issue(error)) {
      case OrderCheckoutIssue.minimumQuantity:
        final minimum = _detailInt(body, const [
          'minimum',
          'min',
          'min_quantity',
          'min_per_order',
        ]);
        if (minimum != null) {
          return l10n.bookingTicketMinimumRequired(minimum);
        }
        return l10n.bookingTicketAvailabilityChanged;
      case OrderCheckoutIssue.maximumQuantity:
        final maximum = _detailInt(body, const [
          'maximum',
          'max',
          'max_quantity',
          'max_per_order',
        ]);
        if (maximum != null) {
          return l10n.bookingTicketMaximumAllowed(maximum);
        }
        return l10n.bookingTicketAvailabilityChanged;
      case OrderCheckoutIssue.availability:
        return l10n.bookingTicketAvailabilityChanged;
      case null:
        return ApiResponseHandler.extractError(error);
    }
  }

  static Map<String, dynamic>? _responseBody(Object error) {
    if (error is! DioException) return null;
    final data = error.response?.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  static String _errorCode(Map<String, dynamic> body) {
    final topLevelCode =
        (body['code'] ?? body['error_code'])?.toString().trim().toLowerCase();
    if (topLevelCode != null && topLevelCode.isNotEmpty) {
      return topLevelCode;
    }

    final error = body['error'];
    if (error is String) return error.trim().toLowerCase();
    if (error is Map) {
      return (error['code'] ?? error['error_code'])
              ?.toString()
              .trim()
              .toLowerCase() ??
          '';
    }
    return '';
  }

  static int? _detailInt(
    Map<String, dynamic>? body,
    List<String> aliases,
  ) {
    if (body == null) return null;
    final candidates = <dynamic>[
      body['details'],
      body['meta'],
      if (body['error'] is Map) (body['error'] as Map)['details'],
    ];

    for (final candidate in candidates) {
      if (candidate is! Map) continue;
      for (final alias in aliases) {
        final value = candidate[alias];
        if (value is int) return value;
        if (value is num) return value.toInt();
        final parsed = int.tryParse(value?.toString() ?? '');
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  static const _minimumCodes = {
    'ticket_minimum_not_met',
    'minimum_quantity_not_met',
    'min_quantity_not_met',
  };

  static const _maximumCodes = {
    'ticket_maximum_exceeded',
    'maximum_quantity_exceeded',
    'max_quantity_exceeded',
  };

  static const _availabilityCodes = {
    'insufficient_stock',
    'insufficient_quota',
    'ticket_sold_out',
    'ticket_unavailable',
    'ticket_sale_not_started',
    'ticket_sale_ended',
    'invalid_ticket_type',
    'slot_full',
    'slot_not_available',
    'slot_capacity_exceeded',
  };
}
