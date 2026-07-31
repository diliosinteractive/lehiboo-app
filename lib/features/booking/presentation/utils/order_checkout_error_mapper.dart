import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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

  static String userMessage(
    Object error,
    AppLocalizations l10n, {
    bool paymentWasCompleted = false,
    String? fallback,
  }) {
    if (paymentWasCompleted && isConfirmationOutcomeUncertain(error)) {
      return l10n.bookingPaymentConfirmationUncertain;
    }

    if (error is StripeException) {
      return stripeUserMessage(error, l10n);
    }
    if (error is StripeConfigException) {
      return l10n.bookingPaymentUnavailable;
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return l10n.bookingCheckoutTimedOut;
        case DioExceptionType.connectionError:
          return l10n.bookingCheckoutConnectionError;
        default:
          break;
      }
    }

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
        return ApiResponseHandler.extractError(
          error,
          fallback: fallback,
          localizations: l10n,
        );
    }
  }

  /// Maps Stripe's small set of SDK failure codes to safe, actionable copy.
  ///
  /// Stripe's `localizedMessage` is deliberately not rendered: depending on
  /// the platform/plugin version it can contain configuration or SDK details.
  static String stripeUserMessage(
    StripeException error,
    AppLocalizations l10n,
  ) {
    if (error.error.code == FailureCode.Canceled) {
      return l10n.bookingPaymentCancelled;
    }
    if (error.error.code == FailureCode.Timeout) {
      return l10n.bookingPaymentTimedOut;
    }
    if (_isStripeConnectivityFailure(error)) {
      return l10n.bookingPaymentTimedOut;
    }
    if (error.error.code == FailureCode.Unknown ||
        _isStripeUnavailableFailure(error)) {
      return l10n.bookingPaymentUnavailable;
    }
    return l10n.bookingPaymentFailed;
  }

  /// Once Stripe has returned success, *any* exception while confirming or
  /// decoding the confirmation leaves the booking outcome unknown.
  ///
  /// This intentionally includes malformed 2xx responses and 4xx conflicts:
  /// the server may have committed the booking before the client failed to
  /// decode it, and a retry may observe a now-conflicting state. Callers pair
  /// this predicate with their `paymentWasCompleted` flag, so pre-payment
  /// validation errors are still rendered normally.
  static bool isConfirmationOutcomeUncertain(Object _) => true;

  static bool _isStripeConnectivityFailure(StripeException error) {
    if (error.error.code == FailureCode.Timeout) return true;
    final diagnostic = _stripeDiagnostic(error);
    return diagnostic.contains('timeout') ||
        diagnostic.contains('timed out') ||
        diagnostic.contains('network') ||
        diagnostic.contains('connection');
  }

  static bool _isStripeUnavailableFailure(StripeException error) {
    final diagnostic = _stripeDiagnostic(error);
    return diagnostic.contains('config') ||
        diagnostic.contains('not initialized') ||
        diagnostic.contains('not initialised') ||
        diagnostic.contains('publishable key') ||
        diagnostic.contains('client secret') ||
        diagnostic.contains('merchant');
  }

  static String _stripeDiagnostic(StripeException error) => [
        error.error.type,
        error.error.stripeErrorCode,
        error.error.declineCode,
        error.error.message,
        error.error.localizedMessage,
      ].whereType<String>().join(' ').toLowerCase();

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
