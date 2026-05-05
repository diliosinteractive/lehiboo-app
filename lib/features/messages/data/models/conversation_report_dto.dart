class ConversationReportDto {
  final String uuid;
  final String reason; // inappropriate|harassment|spam|other
  final String? comment;
  final String status; // pending|reviewed|dismissed (|suspended read-only)
  final String createdAt;
  final String? reviewedAt;
  final String? adminNote;
  final Map<String, dynamic>? conversation; // { uuid, subject, status, conversation_type }
  final Map<String, dynamic>? reporter;     // { id, name, email, avatar_url }
  final Map<String, dynamic>? againstWhom;  // { type, id, name, email, avatar_url, organization_uuid, organization_name }
  final Map<String, dynamic>? reviewedBy;   // { name } | null

  const ConversationReportDto({
    required this.uuid,
    required this.reason,
    this.comment,
    required this.status,
    required this.createdAt,
    this.reviewedAt,
    this.adminNote,
    this.conversation,
    this.reporter,
    this.againstWhom,
    this.reviewedBy,
  });

  factory ConversationReportDto.fromJson(Map<String, dynamic> json) {
    return ConversationReportDto(
      uuid: json['uuid'] as String,
      reason: json['reason'] as String? ?? 'other',
      comment: json['comment'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] as String,
      reviewedAt: json['reviewed_at'] as String?,
      adminNote: json['admin_note'] as String?,
      conversation: json['conversation'] as Map<String, dynamic>?,
      reporter: json['reporter'] as Map<String, dynamic>?,
      againstWhom: json['against_whom'] as Map<String, dynamic>?,
      reviewedBy: json['reviewed_by'] as Map<String, dynamic>?,
    );
  }
}

class ConversationReportListResponseDto {
  final List<ConversationReportDto> data;
  final int? total;
  final int? lastPage;
  final int? currentPage;

  const ConversationReportListResponseDto({
    required this.data,
    this.total,
    this.lastPage,
    this.currentPage,
  });

  factory ConversationReportListResponseDto.fromJson(
      Map<String, dynamic> json) {
    final rawData = json['data'];
    final List dataList;
    final Map<String, dynamic>? meta;
    if (rawData is List) {
      dataList = rawData;
      meta = json['meta'] as Map<String, dynamic>?;
    } else if (rawData is Map<String, dynamic>) {
      dataList = rawData['data'] as List? ?? [];
      meta = rawData['meta'] as Map<String, dynamic>? ??
          json['meta'] as Map<String, dynamic>?;
    } else {
      dataList = [];
      meta = json['meta'] as Map<String, dynamic>?;
    }
    return ConversationReportListResponseDto(
      data: dataList
          .map((e) =>
              ConversationReportDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: meta?['total'] as int?,
      lastPage: meta?['last_page'] as int?,
      currentPage: meta?['current_page'] as int?,
    );
  }
}
