import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart'; // To fetch actual activities for mock
import '../../domain/models/chat_message.dart';
import 'package:lehiboo/features/ai_chat/data/datasources/ai_chat_service.dart';
import 'package:lehiboo/config/dio_client.dart';

// State class
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final int messageCount;
  final bool isLimitReached;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.messageCount = 0,
    this.isLimitReached = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    int? messageCount,
    bool? isLimitReached,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      messageCount: messageCount ?? this.messageCount,
      isLimitReached: isLimitReached ?? this.isLimitReached,
    );
  }
}



// Provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final dio = ref.watch(dioProvider); // Watch dioProvider
  final aiService = AiChatService(dio); // Inject Dio
  return ChatNotifier(ref, aiService);
});

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref ref;
  final _uuid = const Uuid();
  final AiChatService _aiService;

  ChatNotifier(this.ref, this._aiService) : super(ChatState());

  void addReview(String title, String message) {
    // Placeholder if we ever need it
  }

  Future<void> sendMessage(String text) async {
    final user = ref.read(currentUserProvider);
    final limit = 5;

    // Check limits
    if (user == null && state.messageCount >= limit) {
      state = state.copyWith(isLimitReached: true);
      return;
    }

    // Add user message
    final userMsg = ChatMessage(
      id: _uuid.v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      messageCount: state.messageCount + 1,
    );

    try {
      // Call Real AI Service
      final response = await _aiService.sendMessage(text);
      
      final aiText = response['message'] as String? ?? "Désolé, je n'ai pas compris.";
      final eventsData = response['events'] as List?;
      // Use searchParams if available (V2 Update), fallback to user_context
      final searchParams = response['searchParams'] as Map<String, dynamic>?;
      final userContext = response['user_context'] as Map<String, dynamic>?;
      
      List<Activity> suggestions = [];

      if (eventsData != null) {
        suggestions = eventsData.map((e) => _mapEventToActivity(e)).toList();
      }

      final aiMsg = ChatMessage(
        id: _uuid.v4(),
        text: aiText,
        isUser: false,
        timestamp: DateTime.now(),
        activitySuggestions: suggestions,
        searchContext: searchParams ?? userContext,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMsg],
        isLoading: false,
      );

    } catch (e) {
      // Handle Error
      final errorMsg = ChatMessage(
        id: _uuid.v4(),
        text: "Oups ! Une erreur est survenue lors de la communication avec Petit Boo. Réessayez plus tard.",
        isUser: false,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, errorMsg],
        isLoading: false,
      );
      print("AI Error: $e");
    }
  }

  // Helper to map API Event to Domain Activity
  // Ideally this should be in a Mapper class, but keeping it here for speed/simplicity as per instructions
  Activity _mapEventToActivity(Map<String, dynamic> json) {
    return Activity(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Activité sans titre',
      slug: json['slug'] ?? 'activite-${json['id']}', // Fallback slug
      description: json['description'] ?? '',
      imageUrl: json['image'],
    );
  }

  void resetLimit() {
    state = state.copyWith(isLimitReached: false);
  }
  
  void resetConversation() {
    _aiService.resetConversation();
    state = ChatState();
  }
}
