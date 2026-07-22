import 'package:equatable/equatable.dart';

/// Cycle de vie d'un don côté plateforme (cf. docs/DONATIONS_SYSTEM.md §3).
enum DonationStatus {
  pending,
  processing,
  paid,
  failed,
  canceled,
  refunded,
  partiallyRefunded,
  disputed,
  unknown;

  static DonationStatus fromApi(String? value) {
    switch (value) {
      case 'pending':
        return DonationStatus.pending;
      case 'processing':
        return DonationStatus.processing;
      case 'paid':
        return DonationStatus.paid;
      case 'failed':
        return DonationStatus.failed;
      case 'canceled':
        return DonationStatus.canceled;
      case 'refunded':
        return DonationStatus.refunded;
      case 'partially_refunded':
        return DonationStatus.partiallyRefunded;
      case 'disputed':
        return DonationStatus.disputed;
      default:
        return DonationStatus.unknown;
    }
  }

  bool get isPaid => this == DonationStatus.paid;
}

/// Un don volontaire à la plateforme Le Hiboo (sans contrepartie).
class Donation extends Equatable {
  final String uuid;
  final double amount;
  final String currency;
  final DonationStatus status;
  final DateTime? paidAt;
  final DateTime? createdAt;

  const Donation({
    required this.uuid,
    required this.amount,
    this.currency = 'EUR',
    this.status = DonationStatus.pending,
    this.paidAt,
    this.createdAt,
  });

  @override
  List<Object?> get props => [uuid, amount, currency, status, paidAt, createdAt];
}

/// Paramètres prêts pour Stripe PaymentSheet, dérivés du bloc `payment_sheet`
/// renvoyé par `POST /v1/mobile/donations`.
class DonationPaymentSheet extends Equatable {
  final String clientSecret;
  final String merchantDisplayName;
  final String? customerId;
  final String? ephemeralKey;
  final String? paymentIntentId;

  const DonationPaymentSheet({
    required this.clientSecret,
    required this.merchantDisplayName,
    this.customerId,
    this.ephemeralKey,
    this.paymentIntentId,
  });

  /// Vrai uniquement pour un don fait par un utilisateur authentifié disposant
  /// d'un `stripe_customer_id` : PaymentSheet passe alors en mode client.
  bool get hasCustomer =>
      (customerId?.isNotEmpty ?? false) && (ephemeralKey?.isNotEmpty ?? false);

  @override
  List<Object?> get props =>
      [clientSecret, merchantDisplayName, customerId, ephemeralKey, paymentIntentId];
}

/// Résultat de la création d'un don : le don `pending` + les paramètres Stripe.
class DonationCheckout extends Equatable {
  final Donation donation;
  final DonationPaymentSheet paymentSheet;

  const DonationCheckout({required this.donation, required this.paymentSheet});

  @override
  List<Object?> get props => [donation, paymentSheet];
}
