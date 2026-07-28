import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/api_response_handler.dart';
import '../../domain/entities/donation.dart';
import '../../domain/repositories/donations_repository.dart';
import '../datasources/donations_api_datasource.dart';
import '../models/donation_dto.dart';

/// Provider auto-initialisé (pas d'override requis dans main.dart) : la feature
/// don est autonome et lit directement le datasource authentifié.
final donationsRepositoryProvider = Provider<DonationsRepository>((ref) {
  final dataSource = ref.read(donationsApiDataSourceProvider);
  return DonationsRepositoryImpl(dataSource);
});

class DonationsRepositoryImpl implements DonationsRepository {
  final DonationsApiDataSource _dataSource;

  DonationsRepositoryImpl(this._dataSource);

  @override
  Future<DonationCheckout> createDonation({
    required double amount,
    String? email,
    String? name,
    required String locale,
    String sourceScreen = 'settings',
  }) async {
    final dto = await _dataSource.createDonation(
      amount: amount,
      email: email,
      name: name,
      locale: locale,
      sourceScreen: sourceScreen,
    );

    final ps = dto.paymentSheet;
    if (ps == null) {
      throw const ApiFormatException(
        'Missing payment_sheet block in donation creation response',
      );
    }

    return DonationCheckout(
      donation: _mapDonation(dto.data),
      paymentSheet: DonationPaymentSheet(
        clientSecret: ps.clientSecret,
        merchantDisplayName: ps.merchantDisplayName ?? 'Le Hiboo',
        customerId: ps.customerId,
        ephemeralKey: ps.ephemeralKey,
        paymentIntentId: ps.paymentIntentId,
      ),
    );
  }

  @override
  Future<Donation> getDonation(String uuid) async {
    final dto = await _dataSource.getDonation(uuid);
    return _mapDonation(dto);
  }

  @override
  Future<Donation> confirmPayment({
    required String uuid,
    required String paymentIntentId,
  }) async {
    final dto = await _dataSource.confirmPayment(
      uuid: uuid,
      paymentIntentId: paymentIntentId,
    );
    return _mapDonation(dto);
  }

  Donation _mapDonation(DonationDto dto) {
    return Donation(
      uuid: dto.uuid,
      amount: dto.amount ?? 0,
      currency: dto.currency ?? 'EUR',
      status: DonationStatus.fromApi(dto.status),
      paidAt: dto.paidAt != null ? DateTime.tryParse(dto.paidAt!) : null,
      createdAt: dto.createdAt != null ? DateTime.tryParse(dto.createdAt!) : null,
    );
  }
}
