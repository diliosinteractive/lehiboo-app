import '../../../memberships/data/models/membership_dto.dart';

/// The organization the vendor is currently checking tickets in for. The
/// `X-Organization-Id` header on every `/vendor/...` request is sourced
/// from `uuid` here.
class ActiveOrganization {
  final String uuid;
  final String name;
  final MembershipRole role;
  final String? logoUrl;

  const ActiveOrganization({
    required this.uuid,
    required this.name,
    required this.role,
    this.logoUrl,
  });

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'role': role.name,
        if (logoUrl != null) 'logo_url': logoUrl,
      };

  static ActiveOrganization? fromJson(Map<String, dynamic> json) {
    final uuid = json['uuid']?.toString();
    if (uuid == null || uuid.isEmpty) return null;
    final roleStr = json['role']?.toString().toLowerCase() ?? '';
    final role = MembershipRole.values.firstWhere(
      (r) => r.name == roleStr,
      orElse: () => MembershipRole.staff,
    );
    return ActiveOrganization(
      uuid: uuid,
      name: json['name']?.toString() ?? '',
      role: role,
      logoUrl: json['logo_url']?.toString(),
    );
  }
}
