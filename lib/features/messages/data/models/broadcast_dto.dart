int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

bool _parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) return value == '1' || value == 'true';
  return false;
}

class BroadcastEventDto {
  final int id;
  final String uuid;
  final String title;
  final String slug;

  const BroadcastEventDto({
    required this.id,
    required this.uuid,
    required this.title,
    required this.slug,
  });

  factory BroadcastEventDto.fromJson(Map<String, dynamic> json) {
    return BroadcastEventDto(
      id: _parseInt(json['id']),
      uuid: json['uuid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }
}

class BroadcastDto {
  final int id;
  final String uuid;
  final String subject;
  final String body;
  final int recipientsCount;
  final int readCount;
  final int conversationsCreated;
  final bool isSent;
  final String? sentAt;
  final List<BroadcastEventDto> events;
  final String createdAt;

  const BroadcastDto({
    required this.id,
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

  factory BroadcastDto.fromJson(Map<String, dynamic> json) {
    final eventsList = (json['events'] as List?)
            ?.map((e) =>
                BroadcastEventDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return BroadcastDto(
      id: _parseInt(json['id']),
      uuid: json['uuid'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      body: json['body'] as String? ?? '',
      recipientsCount: _parseInt(
          json['recipients_count'] ?? json['recipientsCount']),
      readCount: _parseInt(json['read_count'] ?? json['readCount']),
      conversationsCreated: _parseInt(
          json['conversations_created'] ?? json['conversationsCreated']),
      isSent: _parseBool(json['is_sent'] ?? json['isSent']),
      sentAt: json['sent_at'] as String? ?? json['sentAt'] as String?,
      events: eventsList,
      createdAt: json['created_at'] as String? ??
          json['createdAt'] as String? ??
          '',
    );
  }
}

class BroadcastsListResponseDto {
  final List<BroadcastDto> data;
  final bool hasMore;
  final int total;
  final int currentPage;

  const BroadcastsListResponseDto({
    required this.data,
    required this.hasMore,
    required this.total,
    required this.currentPage,
  });

  factory BroadcastsListResponseDto.fromJson(Map<String, dynamic> json) {
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

    final pagination =
        meta?['pagination'] as Map<String, dynamic>? ?? meta ?? {};
    final total = _parseInt(pagination['total']);
    final rawLastPage = _parseInt(pagination['last_page']);
    final lastPage = rawLastPage < 1 ? 1 : rawLastPage;
    final rawCurrentPage = _parseInt(pagination['current_page']);
    final currentPage = rawCurrentPage < 1 ? 1 : rawCurrentPage;

    return BroadcastsListResponseDto(
      data: dataList
          .map((e) => BroadcastDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: currentPage < lastPage,
      total: total,
      currentPage: currentPage,
    );
  }
}

class VendorEventDto {
  final int id;
  final String uuid;
  final String title;
  final String slug;

  const VendorEventDto({
    required this.id,
    required this.uuid,
    required this.title,
    required this.slug,
  });

  factory VendorEventDto.fromJson(Map<String, dynamic> json) {
    return VendorEventDto(
      id: _parseInt(json['id']),
      uuid: json['uuid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }
}

class SlotOptionDto {
  final int id;
  final String uuid;
  final String? slotDate;
  final String? startTime;
  final String? endTime;

  const SlotOptionDto({
    required this.id,
    required this.uuid,
    this.slotDate,
    this.startTime,
    this.endTime,
  });

  factory SlotOptionDto.fromJson(Map<String, dynamic> json) {
    return SlotOptionDto(
      id: _parseInt(json['id']),
      uuid: json['uuid'] as String? ?? '',
      slotDate: json['slot_date'] as String? ?? json['slotDate'] as String?,
      startTime: json['start_time'] as String? ?? json['startTime'] as String?,
      endTime: json['end_time'] as String? ?? json['endTime'] as String?,
    );
  }
}
