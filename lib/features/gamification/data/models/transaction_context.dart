/// Contexte enrichi attaché à une transaction Hibons (event/organization/booking).
class TransactionContext {
  final String type; // event | organization | booking
  final String? uuid;
  final String? slug;
  final String? title;
  final String? imageUrl;
  final String? reference; // bookings only

  const TransactionContext({
    required this.type,
    this.uuid,
    this.slug,
    this.title,
    this.imageUrl,
    this.reference,
  });
}
