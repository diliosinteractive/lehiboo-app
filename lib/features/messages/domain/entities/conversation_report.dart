import 'package:equatable/equatable.dart';

class ConversationReportParty extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? organizationUuid;
  final String? organizationName;

  const ConversationReportParty({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.organizationUuid,
    this.organizationName,
  });

  @override
  List<Object?> get props =>
      [id, name, email, avatarUrl, organizationUuid, organizationName];
}

class ConversationReport extends Equatable {
  final String uuid;
  final String reason; // inappropriate|harassment|spam|other
  final String? comment;
  final String status; // pending|reviewed|dismissed (|suspended read-only)
  final DateTime createdAt;
  final DateTime? reviewedAt;
  final String? adminNote;
  final String? conversationUuid;
  final String? conversationSubject;
  final ConversationReportParty? reporter;
  final ConversationReportParty? againstWhom;
  final String? againstWhomType; // 'user'|'organization'
  final String? reviewedByName;

  const ConversationReport({
    required this.uuid,
    required this.reason,
    this.comment,
    required this.status,
    required this.createdAt,
    this.reviewedAt,
    this.adminNote,
    this.conversationUuid,
    this.conversationSubject,
    this.reporter,
    this.againstWhom,
    this.againstWhomType,
    this.reviewedByName,
  });

  ConversationReport copyWith({
    String? uuid,
    String? reason,
    String? comment,
    String? status,
    DateTime? createdAt,
    DateTime? reviewedAt,
    String? adminNote,
    String? conversationUuid,
    String? conversationSubject,
    ConversationReportParty? reporter,
    ConversationReportParty? againstWhom,
    String? againstWhomType,
    String? reviewedByName,
  }) {
    return ConversationReport(
      uuid: uuid ?? this.uuid,
      reason: reason ?? this.reason,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      adminNote: adminNote ?? this.adminNote,
      conversationUuid: conversationUuid ?? this.conversationUuid,
      conversationSubject: conversationSubject ?? this.conversationSubject,
      reporter: reporter ?? this.reporter,
      againstWhom: againstWhom ?? this.againstWhom,
      againstWhomType: againstWhomType ?? this.againstWhomType,
      reviewedByName: reviewedByName ?? this.reviewedByName,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        reason,
        comment,
        status,
        createdAt,
        reviewedAt,
        adminNote,
        conversationUuid,
        conversationSubject,
        reporter,
        againstWhom,
        againstWhomType,
        reviewedByName,
      ];
}
