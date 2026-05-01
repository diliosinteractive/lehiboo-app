class AcceptedPartnerDto {
  final int id;
  final String companyName;
  final String organizationName;
  final String? logoUrl;
  final String? avatarUrl;

  const AcceptedPartnerDto({
    required this.id,
    required this.companyName,
    required this.organizationName,
    this.logoUrl,
    this.avatarUrl,
  });

  factory AcceptedPartnerDto.fromJson(Map<String, dynamic> json) {
    return AcceptedPartnerDto(
      id: int.tryParse(json['id'].toString()) ?? 0,
      companyName: json['company_name'] as String? ?? '',
      organizationName: json['organization_name'] as String? ?? '',
      logoUrl: json['logo_url'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}
