import '../entities/donation.dart';

/// Contrat métier pour les dons volontaires à la plateforme.
abstract class DonationsRepository {
  /// Crée un don `pending` et renvoie les paramètres Stripe PaymentSheet.
  Future<DonationCheckout> createDonation({
    required double amount,
    String? email,
    String? name,
    required String locale,
    String sourceScreen,
  });

  /// Relit un don (statut à jour).
  Future<Donation> getDonation(String uuid);

  /// Réconcilie un don après paiement via son `payment_intent_id`.
  Future<Donation> confirmPayment({
    required String uuid,
    required String paymentIntentId,
  });
}
