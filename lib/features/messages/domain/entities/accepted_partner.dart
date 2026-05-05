import 'package:equatable/equatable.dart';

class AcceptedPartner extends Equatable {
  final int id;
  final String companyName;
  final String organizationName;
  final String? logoUrl;
  final String? avatarUrl;

  const AcceptedPartner({
    required this.id,
    required this.companyName,
    required this.organizationName,
    this.logoUrl,
    this.avatarUrl,
  });

  @override
  List<Object?> get props =>
      [id, companyName, organizationName, logoUrl, avatarUrl];
}
