class VendorStatsDto {
  final int clientTotal;
  final int clientUnread;
  final int supportTotal;
  final int supportUnread;

  const VendorStatsDto({
    required this.clientTotal,
    required this.clientUnread,
    required this.supportTotal,
    required this.supportUnread,
  });

  factory VendorStatsDto.fromJson(Map<String, dynamic> json) {
    final cr = (json['client_requests'] ?? json['clientRequests'])
            as Map<String, dynamic>? ??
        {};
    final su = (json['support']) as Map<String, dynamic>? ?? {};
    return VendorStatsDto(
      clientTotal: (cr['total'] as num?)?.toInt() ?? 0,
      clientUnread: (cr['unread'] as num?)?.toInt() ?? 0,
      supportTotal: (su['total'] as num?)?.toInt() ?? 0,
      supportUnread: (su['unread'] as num?)?.toInt() ?? 0,
    );
  }
}
