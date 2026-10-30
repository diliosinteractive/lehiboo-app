/// Organization roles that can operate the vendor ticket scanner.
///
/// `staff` is accepted while decoding persisted state for compatibility with
/// app versions that used the mobile-only `MembershipRole.staff` value. The
/// backend's canonical role name is `manager`.
enum OrganizationAccessRole { owner, admin, manager }

OrganizationAccessRole? parseOrganizationAccessRole(Object? value) {
  return switch (value?.toString().trim().toLowerCase()) {
    'owner' => OrganizationAccessRole.owner,
    'admin' => OrganizationAccessRole.admin,
    'manager' || 'staff' => OrganizationAccessRole.manager,
    _ => null,
  };
}

/// The organization the vendor is currently checking tickets in for. The
/// `X-Organization-Id` header on every `/vendor/...` request is sourced
/// from `uuid` here.
class ActiveOrganization {
  final String uuid;
  final String name;
  final OrganizationAccessRole role;
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
    final role = parseOrganizationAccessRole(json['role']);
    if (role == null) return null;
    return ActiveOrganization(
      uuid: uuid,
      name: json['name']?.toString() ?? '',
      role: role,
      logoUrl: json['logo_url']?.toString(),
    );
  }
}
