import 'package:equatable/equatable.dart';

class BroadcastEvent extends Equatable {
  final String uuid;
  final String title;

  const BroadcastEvent({required this.uuid, required this.title});

  @override
  List<Object?> get props => [uuid, title];
}

class Broadcast extends Equatable {
  final String uuid;
  final String subject;
  final String body;
  final int recipientsCount;
  final int readCount;
  final int conversationsCreated;
  final bool isSent;
  final DateTime? sentAt;
  final List<BroadcastEvent> events;
  final DateTime createdAt;

  const Broadcast({
    required this.uuid,
    required this.subject,
    required this.body,
    required this.recipientsCount,
    required this.readCount,
    required this.conversationsCreated,
    required this.isSent,
    this.sentAt,
    required this.events,
    required this.createdAt,
  });

  Broadcast copyWith({
    String? uuid,
    String? subject,
    String? body,
    int? recipientsCount,
    int? readCount,
    int? conversationsCreated,
    bool? isSent,
    DateTime? sentAt,
    List<BroadcastEvent>? events,
    DateTime? createdAt,
  }) {
    return Broadcast(
      uuid: uuid ?? this.uuid,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      recipientsCount: recipientsCount ?? this.recipientsCount,
      readCount: readCount ?? this.readCount,
      conversationsCreated: conversationsCreated ?? this.conversationsCreated,
      isSent: isSent ?? this.isSent,
      sentAt: sentAt ?? this.sentAt,
      events: events ?? this.events,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        subject,
        body,
        recipientsCount,
        readCount,
        conversationsCreated,
        isSent,
        sentAt,
        events,
        createdAt,
      ];
}

class VendorEvent extends Equatable {
  final int id;
  final String uuid;
  final String title;
  final String slug;

  const VendorEvent({
    required this.id,
    required this.uuid,
    required this.title,
    required this.slug,
  });

  @override
  List<Object?> get props => [id, uuid, title, slug];
}

class SlotOption extends Equatable {
  final int id;
  final String uuid;
  final String? slotDate;
  final String? startTime;
  final String? endTime;

  const SlotOption({
    required this.id,
    required this.uuid,
    this.slotDate,
    this.startTime,
    this.endTime,
  });

  @override
  List<Object?> get props => [id, uuid, slotDate, startTime, endTime];
}

class BroadcastsListResult extends Equatable {
  final List<Broadcast> broadcasts;
  final bool hasMore;
  final int currentPage;
  final int totalCount;

  const BroadcastsListResult({
    required this.broadcasts,
    required this.hasMore,
    required this.currentPage,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [broadcasts, hasMore, currentPage, totalCount];
}
