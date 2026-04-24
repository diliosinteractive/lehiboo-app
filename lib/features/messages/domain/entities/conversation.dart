import 'package:equatable/equatable.dart';
import 'message.dart';

class ConversationOrganization extends Equatable {
  final String uuid;
  final String companyName;
  final String organizationName;
  final String? logoUrl;
  final String? avatarUrl;

  const ConversationOrganization({
    required this.uuid,
    required this.companyName,
    required this.organizationName,
    this.logoUrl,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [uuid, companyName, organizationName, logoUrl, avatarUrl];
}

class ConversationParticipant extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;

  const ConversationParticipant({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, email, avatarUrl];
}

class ConversationEvent extends Equatable {
  final String uuid;
  final String title;
  final String slug;

  const ConversationEvent({
    required this.uuid,
    required this.title,
    required this.slug,
  });

  @override
  List<Object?> get props => [uuid, title, slug];
}

class Conversation extends Equatable {
  final String uuid;
  final String subject;
  final String status; // 'open' | 'closed'
  final String conversationType; // 'participant_vendor' | 'user_support'
  final DateTime? closedAt;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final bool isSignalement;
  final ConversationOrganization? organization;
  final ConversationParticipant? participant;
  final ConversationEvent? event;
  final Message? latestMessage;
  final List<Message> messages; // populated only on detail fetch
  final DateTime createdAt;
  final DateTime updatedAt;

  const Conversation({
    required this.uuid,
    required this.subject,
    required this.status,
    required this.conversationType,
    this.closedAt,
    this.lastMessageAt,
    required this.unreadCount,
    required this.isSignalement,
    this.organization,
    this.participant,
    this.event,
    this.latestMessage,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  Conversation copyWith({
    String? uuid,
    String? subject,
    String? status,
    String? conversationType,
    DateTime? closedAt,
    DateTime? lastMessageAt,
    int? unreadCount,
    bool? isSignalement,
    ConversationOrganization? organization,
    ConversationParticipant? participant,
    ConversationEvent? event,
    Message? latestMessage,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      uuid: uuid ?? this.uuid,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      conversationType: conversationType ?? this.conversationType,
      closedAt: closedAt ?? this.closedAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isSignalement: isSignalement ?? this.isSignalement,
      organization: organization ?? this.organization,
      participant: participant ?? this.participant,
      event: event ?? this.event,
      latestMessage: latestMessage ?? this.latestMessage,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        subject,
        status,
        conversationType,
        closedAt,
        lastMessageAt,
        unreadCount,
        isSignalement,
        organization,
        participant,
        event,
        latestMessage,
        messages,
        createdAt,
        updatedAt,
      ];
}
