class AdminReportStatsDto {
  final int pending;
  final int reviewed;
  final int dismissed;
  final int total;

  const AdminReportStatsDto({
    required this.pending,
    required this.reviewed,
    required this.dismissed,
    required this.total,
  });

  factory AdminReportStatsDto.fromJson(Map<String, dynamic> json) {
    return AdminReportStatsDto(
      pending: (json['pending'] as num?)?.toInt() ?? 0,
      reviewed: (json['reviewed'] as num?)?.toInt() ?? 0,
      dismissed: (json['dismissed'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}
