import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/chat_message_dto.dart';
import '../../data/models/conversation_dto.dart';
import '../../data/models/petit_boo_event_dto.dart';
import '../../data/models/quota_dto.dart';

/// Provider for the Petit Boo repository (will be overridden in main.dart)
final petitBooRepositoryProvider = Provider<PetitBooRepository>((ref) {
  throw UnimplementedError('petitBooRepositoryProvider not initialized');
});

/// Abstract repository interface for Petit Boo
abstract class PetitBooRepository {
  /// Send a message and receive streaming response
  ///
  /// Returns a stream of [PetitBooEventDto] for real-time updates.
  /// If [sessionUuid] is null, a new session will be created.
  Stream<PetitBooEventDto> sendMessage({
    String? sessionUuid,
    required String message,
  });

  /// Get list of user's conversations
  Future<ConversationsResult> getConversations({
    int page = 1,
    int perPage = 20,
  });

  /// Get a specific conversation with messages
  Future<ConversationDto> getConversation(String uuid);

  /// Create a new conversation
  Future<ConversationDto> createConversation({String? title});

  /// Delete/archive a conversation
  Future<void> deleteConversation(String uuid);

  /// Get user's chat quota
  Future<QuotaDto> getQuota();

  /// Check if Petit Boo service is available
  Future<bool> isServiceAvailable();

  /// Set auth token for API calls
  void setAuthToken(String token);

  /// Clear auth token
  void clearAuthToken();
}

/// Result wrapper for conversations list with pagination
class ConversationsResult {
  final List<ConversationDto> conversations;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  ConversationsResult({
    required this.conversations,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });

  bool get hasNext => currentPage < totalPages;
  bool get hasPrev => currentPage > 1;
}
