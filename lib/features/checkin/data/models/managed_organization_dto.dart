import '../../domain/entities/active_organization.dart';

/// Organization the authenticated user owns or manages through the vendor
/// team relationship returned by `GET /organizations`.
class ManagedOrganizationDto {
  const ManagedOrganizationDto({
    required this.uuid,
    required this.name,
    required this.role,
    this.logoUrl,
  });

  final String uuid;
  final String name;
  final OrganizationAccessRole role;
  final String? logoUrl;

  /// Parses only scanner-capable management roles. Unknown roles, including
  /// customer/viewer relationships, fail closed and are not shown in the
  /// organization picker.
  static ManagedOrganizationDto? tryFromJson(Map<String, dynamic> json) {
    final uuid = _firstNonEmpty([json['uuid']]);
    final role = parseOrganizationAccessRole(json['role']);
    if (uuid == null || role == null) return null;

    return ManagedOrganizationDto(
      uuid: uuid,
      name: _firstNonEmpty([
            json['display_name'],
            json['displayName'],
            json['name'],
            json['company_name'],
          ]) ??
          '',
      role: role,
      logoUrl: _firstNonEmpty([
        json['logo_url'],
        json['logoUrl'],
        json['logo'],
      ]),
    );
  }

  ActiveOrganization toActiveOrganization() => ActiveOrganization(
        uuid: uuid,
        name: name,
        role: role,
        logoUrl: logoUrl,
      );
}

String? _firstNonEmpty(Iterable<Object?> candidates) {
  for (final candidate in candidates) {
    final value = candidate?.toString().trim();
    if (value != null && value.isNotEmpty) return value;
  }
  return null;
}
