import 'package:flutter_riverpod/flutter_riverpod.dart';

// Single source of truth for the global messages unread badge.
// Updated by ConversationsNotifier, SupportConversationsNotifier,
// and ConversationDetailNotifier.
final unreadCountProvider = StateProvider<int>((ref) => 0);
