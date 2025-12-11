import 'package:lehiboo/domain/entities/activity.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<Activity>? activitySuggestions;
  final Map<String, dynamic>? searchContext;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.activitySuggestions,
    this.searchContext,
  });
}
