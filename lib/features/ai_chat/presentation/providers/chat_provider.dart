import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/domain/entities/city.dart';
import 'package:lehiboo/domain/entities/taxonomy.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart'; // To fetch actual activities for mock
import '../../domain/models/chat_message.dart';
import 'package:lehiboo/features/ai_chat/data/datasources/ai_chat_service.dart';
import 'package:lehiboo/config/dio_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lehiboo/features/ai_chat/data/datasources/ai_context_storage.dart';

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
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Override in main.dart
});

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final dio = ref.watch(dioProvider); 
  ref.watch(currentUserProvider); // Force rebuild on auth change
  
  // Get SharedPreferences (must be overridden in main)
  final prefs = ref.watch(sharedPreferencesProvider);
  final contextStorage = AiContextStorage(prefs);
  
  final aiService = AiChatService(dio, contextStorage);
  return ChatNotifier(ref, aiService);
});

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref ref;
  final AiChatService _aiService;
  final Uuid _uuid = const Uuid();

  // Expose service for debug & brain
  AiChatService get aiService => _aiService;
  Map<String, dynamic> get userContext => _aiService.userContext;
  bool get isMemoryEnabled => _aiService.isMemoryEnabled;
  
  void updateBrainKey(String key, dynamic value) {
    _aiService.updateContextKey(key, value);
    // Force UI rebuild if needed (though context is not deep watched in state usually)
    // But since BrainScreen will likely read from provider or service directly, it might be fine.
    // Ideally we should have a 'version' in state to trigger rebuilds, 
    // but for now let's rely on the BrainScreen rebuilding itself or using a Stream if we had one.
  }

  void removeBrainKey(String key) {
    _aiService.removeContextKey(key);
  }

  void toggleMemory(bool enabled) {
    _aiService.setMemoryEnabled(enabled);
    // Trigger state update to refresh UI listeners
    state = state.copyWith(); 
  }

  ChatNotifier(this.ref, this._aiService) : super(ChatState()) {
    startSmartWelcome();
  }

  Future<void> startSmartWelcome() async {
    String userName = "Voyageur";
    String locationContext = "Paris"; // Default fallback
    String? userId;

    final user = ref.read(currentUserProvider);
    if (user != null) {
      if (user.firstName != null) userName = user.firstName!;
      userId = user.id;
    }

    // 1. Attempt to Sync History if logged in
    if (userId != null) {
      state = state.copyWith(isLoading: true);
      try {
        final history = await _aiService.fetchRemoteHistory(userId);
        if (history.isNotEmpty) {
           // Reconstruct messages from history
           final messages = history.where((h) {
             // Filter out System Instructions if they leaked into history
             final content = h['content'] as String? ?? '';
             final upperContent = content.toUpperCase();
             return !upperContent.startsWith('SYSTEM_INSTRUCTION') && !upperContent.startsWith('SYSTEM INSTRUCTION') && !upperContent.startsWith('ACT UNDER THE NAME');
           }).map((h) {
             final isUser = h['role'] == 'user';
             
             // Reconstruct suggestions if events exist in history
             List<Activity> suggestions = [];
             if (!isUser && h['events'] != null && h['events'] is List) {
               suggestions = (h['events'] as List).map((e) => _mapEventToActivity(e)).toList();
             }

             return ChatMessage(
               id: _uuid.v4(), // or use h['id'] if available
               text: h['content'] ?? '',
               isUser: isUser,
               timestamp: h['timestamp'] != null ? DateTime.parse(h['timestamp']) : DateTime.now(),
               activitySuggestions: suggestions,
             );
           }).toList();
           
           if (messages.isNotEmpty) {
             state = state.copyWith(
               messages: messages,
               isLoading: false,
               messageCount: messages.where((m) => m.isUser).length,
             );
             return; // Stop here, don't show Smart Welcome if we have history
           }
        }
      } catch (e) {
        debugPrint("History sync error: $e");
      }
      
      // 1.5 Fetch Quota
      try {
        final quota = await _aiService.getQuota(userId);
        if (quota.isNotEmpty) {
           final used = quota['used'] as int? ?? 0;
           final isLimitReached = quota['is_limit_reached'] as bool? ?? false;
           
           state = state.copyWith(
             messageCount: used,
             isLimitReached: isLimitReached,
           );
        }
      } catch (e) {
        debugPrint("Quota sync error: $e");
      }
    }

    // 2. If no history or guest, show Smart Welcome
    
    // Initial Loading State
    state = state.copyWith(isLoading: true, messages: [
      ChatMessage(
        id: _uuid.v4(),
        text: "Petit Boo se connecte...",
        isUser: false,
        timestamp: DateTime.now(),
      )
    ]);
    
    // ... (Location Logic same as before) ...
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition();
          
          // Inject into Brain
          _aiService.updateContextKey('latitude', position.latitude);
          _aiService.updateContextKey('longitude', position.longitude);

          try {
            List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
            if (placemarks.isNotEmpty) {
              locationContext = placemarks.first.locality ?? "Paris";
            }
          } catch (e) {
            debugPrint("Geocoding error: $e");
          }
        }
      }
    } catch (e) {
      debugPrint("Location error: $e");
    }

    try {
        final userContextCoords = _aiService.userContext['latitude'] != null 
            ? " (Lat: ${_aiService.userContext['latitude']}, Lng: ${_aiService.userContext['longitude']})" 
            : "";

        final prompt = "SYSTEM_INSTRUCTION: Ignore previous history. The user is '$userName' and is currently at '$locationContext'$userContextCoords. "
                     "Act as 'Petit Boo', a friendly local guide. " 
                     "Say hello warmly. Use EMOJIS to be friendly and expressive! 🌟 "
                     "TASK: Find 3 REAL, DIVERSE activities around '$locationContext' (Cultural, Active, Discovery). "
                     "CRITICAL: You MUST use the 'findEvents' tool to return the activities. "
                     "1. FIRST, call 'findEvents' with specific keywords OR location parameters (latitude, longitude, radius_km) to get real data. "
                     "2. THEN, write your friendly response based ONLY on the data returned by the tool. "
                     "3. Do NOT hallucinate activities. If 'findEvents' returns nothing, say you couldn't find anything specific but offer general advice. "
                     "4. In your text, be pedagogical and persuasive. "
                     "5. ABSOLUTELY NO LINKS or URLs. If referring to a place, just use its name. "
                     "MEMORY: Store any key user insights in 'user_context'. "
                     "REMEMBER: If the 'events' list is empty, valid cards will NOT appear, and you will look broken. USE THE TOOL.";

      // Direct API call
      // Pass userId if available to link session
      // Don't add this system prompt to local history
      final response = await _aiService.sendMessage(prompt, userId: userId, addToHistory: false);
      
      final aiText = response['message'] as String? ?? "Bonjour ! Je suis Petit Boo.";
      final eventsData = response['events'] as List?;
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
        searchContext: response['searchParams'] ?? response['user_context'],
      );

      state = state.copyWith(
        messages: [aiMsg], 
        isLoading: false
      );

    } catch (e) {
      debugPrint("Smart Welcome Error: $e");
      final fallbackMsg = ChatMessage(
        id: _uuid.v4(),
        text: "Bonjour ${user?.firstName ?? ''} ! Je suis Petit Boo. Désolé, j'ai eu un petit souci de connexion, mais je suis prêt à t'aider !",
        isUser: false,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(messages: [fallbackMsg], isLoading: false);
    }
  }

  void addReview(String title, String message) {
    // Placeholder
  }

  Future<void> sendMessage(String text) async {
    final user = ref.read(currentUserProvider);
    final limit = 5;

    // Check limits
    // Anonymous users (user == null) are NOT limited per spec.
    // Authenticated users: Check state.isLimitReached (synced with backend)
    // Authenticated users: Check state.isLimitReached (synced with backend)
    if (user != null && (state.isLimitReached || state.messageCount >= limit)) {
      if (!state.isLimitReached) {
        state = state.copyWith(isLimitReached: true);
      }
      return; 
    }

    // Add user message to UI
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
      // Call Real AI Service with userId
      final response = await _aiService.sendMessage(text, userId: user?.id);
      
      var aiText = response['message'] as String? ?? "Désolé, je n'ai pas compris.";
      
      // STRIP RAW URLs & Markdown Links
      final urlRegExp = RegExp(r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');
      final mdLinkRegExp = RegExp(r'\[([^\]]+)\]\((https?:\/\/[^\)]+)\)');
      
      // 1. Replace Markdown links with just the text label
      aiText = aiText.replaceAllMapped(mdLinkRegExp, (match) => match.group(1) ?? "");
      
      // 2. Remove remaining raw URLs
      aiText = aiText.replaceAll(urlRegExp, "");

      final eventsData = response['events'] as List?;
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
      debugPrint("AI Error: $e");
      
      // Check for 403 Limit Reached
      if (e is DioException && e.response?.statusCode == 403) {
         // Limit reached!
         state = state.copyWith(
           messages: state.messages.where((m) => m != userMsg).toList(), // Remove the message that failed
           isLoading: false,
           isLimitReached: true,
         );
         return;
      }

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
    }
  }

  // Helper to map API Event to Domain Activity
  // Ideally this should be in a Mapper class, but keeping it here for speed/simplicity as per instructions
  Activity _mapEventToActivity(Map<String, dynamic> json) {
    // Helper to safely parse double
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    // Map Category
    Category? category;
    if (json['category'] is Map) {
      final cat = json['category'];
      category = Category(
        id: '', 
        slug: cat['slug'] ?? '',
        name: cat['name'] ?? '',
      );
    } else if (json['category'] is String) {
      // Backend V2 (JSONB)
      final catName = json['category'] as String;
      category = Category(
        id: '', 
        slug: catName.toLowerCase(), // Simple slug generated from name
        name: catName,
      );
    }

    // Map Tags (Thematiques)
    List<Tag>? tags;
    if (json['thematiques'] is List) {
      tags = (json['thematiques'] as List).map((t) {
        return Tag(
          id: '',
          slug: t['slug'] ?? '',
          name: t['name'] ?? '',
        );
      }).toList();
    }

    // Map City
    City? city;
    if (json['location'] is Map) {
      final loc = json['location'];
      city = City(
        id: '',
        name: loc['city'] ?? '',
        slug: loc['city']?.toString().toLowerCase() ?? '',
        lat: parseDouble(loc['lat']),
        lng: parseDouble(loc['lng']),
      );
    }

    final price = parseDouble(json['price']);

    return Activity(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Activité sans titre',
      slug: json['slug'] ?? 'activite-${json['id']}',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? json['thumbnail'] ?? json['image_url'], // Priority to 'image'
      isFree: price == 0 || json['priceLabel'] == 'Gratuit',
      priceMin: price,
      city: city,
      category: category,
      tags: tags,
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
