import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import '../providers/chat_provider.dart';
import '../../domain/models/chat_message.dart';
import '../widgets/ai_suggestion_carousel.dart';
import '../widgets/typing_bubble.dart';
import 'ai_brain_screen.dart';


class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  void _initSpeech() async {
    // Check permission first (optional but good practice)
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  
    try {
      _speechEnabled = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening' || status == 'done') {
            setState(() => _isListening = false);
          }
        },
        onError: (errorNotification) {
          setState(() => _isListening = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur micro: ${errorNotification.errorMsg}')),
          );
        },
      );
      setState(() {});
    } catch (e) {
      print("Speech init error: $e");
    }
  }

  void _startListening() async {
    if (!_speechEnabled) {
      _initSpeech();
      return;
    }

    if (_isListening) {
      _stopListening();
      return;
    }

    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        // Guard: If we stopped listening (e.g. sent message), ignore late results
        if (!_isListening) return;
        
        setState(() {
          _textController.text = result.recognizedWords;
          if (result.finalResult) {
            _isListening = false;
          }
        });
      },
      localeId: "fr_FR",
    );
  }

  void _stopListening() async {
    setState(() => _isListening = false); // Update UI immediately
    await _speech.stop();
  }

  void _handleSendMessage() async {
    // 1. Stop listening immediately to prevent text updates
    if (_isListening) {
      _stopListening();
    }

    final text = _textController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatProvider.notifier).sendMessage(text);
    _textController.clear();
    
    // Scroll to bottom immediately for user message
    _scrollToBottom();
  }
  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    // Limit Reached Modal Listener
    ref.listen(chatProvider.select((s) => s.isLimitReached), (previous, next) {
      if (next) {
        _showLimitReachedDialog(context);
      }
    });

    // Auto-scroll on new messages
    ref.listen(chatProvider.select((s) => s.messages.length), (previous, next) {
      if (next > (previous ?? 0)) {
        _scrollToBottom();
      }
    });
    
    // Auto-scroll when loading starts (to show typing bubble)
    ref.listen(chatProvider.select((s) => s.isLoading), (previous, next) {
      if (next) { // If started loading
         _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFFF601F),
              radius: 18,
              child: ClipOval(
                child: Image.asset('assets/images/petit_boo_logo.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Petit Boo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Assistant IA (Beta)',
                  style: TextStyle(fontSize: 12, color: Colors.green[700]),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      
                      // Title
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF601F).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.auto_awesome, color: Color(0xFFFF601F), size: 24),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              "À propos de Petit Boo",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF222222),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      const Text(
                        "Votre assistant personnel intelligent",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Petit Boo analyse vos envies pour vous dénicher les meilleures sorties autour de chez vous.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      const Text(
                        "Comment ça marche ?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildInfoStep(
                        icon: Icons.chat_bubble_outline_rounded,
                        text: "Posez une question simple :\n\"Je cherche un resto italien ce soir\"",
                      ),
                      _buildInfoStep(
                        icon: Icons.mic_none_rounded,
                        text: "Utilisez le micro pour parler naturellement",
                      ),
                      _buildInfoStep(
                        icon: Icons.lightbulb_outline_rounded,
                        text: "Recevez des suggestions personnalisées",
                      ),

                      const SizedBox(height: 24),
                      
                      // Beta Warning
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.amber[100]!),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Icon(Icons.warning_amber_rounded, color: Colors.amber[800]),
                             const SizedBox(width: 12),
                             Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(
                                     "Version Beta",
                                     style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       color: Colors.amber[900],
                                     ),
                                   ),
                                   const SizedBox(height: 4),
                                   Text(
                                     "Petit Boo apprend encore. Ses r\u00e9ponses peuvent \u00eatre parfois impr\u00e9cises.",
                                     style: TextStyle(
                                       fontSize: 13,
                                       color: Colors.amber[900],
                                       height: 1.4,
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF601F),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "C'est compris !",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Brain Button
          IconButton(
            icon: const Icon(Icons.psychology),
            tooltip: 'Mémoire de Petit Boo',
            onPressed: () {
               showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const AiBrainScreen(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: chatState.messages.isEmpty 
                  ? 1 
                  : chatState.messages.length + (chatState.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (chatState.messages.isEmpty) {
                   return _buildWelcomeBanner();
                }
                
                // If is loading and this is the last item
                if (chatState.isLoading && index == chatState.messages.length) {
                  return const TypingBubble();
                }
                
                final message = chatState.messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          
          // Limits Indicator (Optional visualization)
          if (!chatState.isLimitReached)
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
               child: Text(
                 "${(5 - chatState.messageCount).clamp(0, 5)} messages gratuits restants",
                 style: TextStyle(fontSize: 10, color: Colors.grey[400]),
               ),
             ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                 BoxShadow(
                   color: Colors.black.withOpacity(0.05),
                   blurRadius: 10,
                   offset: const Offset(0, -5),
                 ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: chatState.isLimitReached ? 'Limite atteinte (5/5)' : (_isListening ? 'Je vous écoute...' : 'Écrivez votre message...'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: chatState.isLimitReached ? Colors.grey[200] : (_isListening ? Colors.red[50] : const Color(0xFFF5F5F5)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        enabled: !chatState.isLimitReached,
                      ),
                      onSubmitted: (_) => _handleSendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Text is empty -> Mic, Text not empty -> Send
                  ValueListenableBuilder(
                    valueListenable: _textController,
                    builder: (context, value, child) {
                      final hasText = value.text.isNotEmpty;
                      final isLimitReached = ref.read(chatProvider).isLimitReached;
                      
                      return GestureDetector(
                        onTap: isLimitReached ? null : (hasText ? _handleSendMessage : _startListening),
                        child: CircleAvatar(
                          backgroundColor: isLimitReached 
                              ? Colors.grey[300] 
                              : (hasText ? const Color(0xFFFF601F) : (_isListening ? Colors.red : Colors.grey[200])),
                          radius: 24,
                          child: Icon(
                            hasText ? Icons.send : (_isListening ? Icons.stop : Icons.mic),
                            color: hasText || _isListening ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
           const Icon(Icons.waving_hand, size: 40, color: Color(0xFFFFD700)),
           const SizedBox(height: 10),
           const Text(
             "Bonjour ! Je suis Petit Boo.",
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
           ),
           const SizedBox(height: 5),
           Text(
             "Posez-moi une question pour commencer. Par exemple : \"Trouve-moi un concert de jazz ce soir\".",
             textAlign: TextAlign.center,
             style: TextStyle(color: Colors.grey[600]),
           ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final hasSuggestions = !isUser && message.activitySuggestions != null && message.activitySuggestions!.isNotEmpty;

    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // AI Avatar
            if (!isUser)
              Container(
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFFF601F),
                  radius: 16,
                  child: ClipOval(
                    child: Image.asset('assets/images/petit_boo_logo.png', fit: BoxFit.cover),
                  ),
                ),
              ),

            // Text Bubble
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(16),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.70),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFFFF601F) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
                  bottomRight: isUser ? Radius.zero : const Radius.circular(20),
                ),
                boxShadow: isUser ? [] : [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
                ],
              ),
              child: MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    color: isUser ? Colors.white : const Color(0xFF222222),
                    height: 1.4,
                    fontSize: 16,
                  ),
                  strong: TextStyle(
                     fontWeight: FontWeight.bold,
                     color: isUser ? Colors.white : const Color(0xFF222222),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        // Timestamp
        Padding(
          padding: EdgeInsets.only(
            left: isUser ? 0 : 48, // Indent for avatar
            right: isUser ? 0 : 0, 
            bottom: 8
          ),
          child: Text(
            // Format: 12 déc, 14:30
            "${message.timestamp.day} ${_getMonthName(message.timestamp.month)}, ${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
            style: TextStyle(fontSize: 10, color: Colors.grey[400]),
          ),
        ),

        // Suggestions Carousel (Full Width, outside bubble)
        if (hasSuggestions)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16, left: 40), // Align with text
            child: AiSuggestionCarousel(
              activities: message.activitySuggestions!,
              onMoreTap: () => _navigateToSearchWithContext(message),
            ),
          ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = ['janv', 'févr', 'mars', 'avril', 'mai', 'juin', 'juil', 'août', 'sept', 'oct', 'nov', 'déc'];
    return months[month - 1];
  }

  void _navigateToSearchWithContext(ChatMessage message) {
    // Extract context for pre-filling filters
    final contextMap = message.searchContext;
    final Map<String, String> queryParams = {};

    if (contextMap != null) {
      debugPrint("Deep Search Context: $contextMap");

      // Direct Mapping from V2 'searchParams'
      
      // 1. City
      if (contextMap['city'] != null) {
        queryParams['city'] = contextMap['city'];
      } else if (contextMap['location'] is Map && contextMap['location']['city'] != null) {
        // Fallback for userContext structure
        queryParams['city'] = contextMap['location']['city'];
      }

      // 2. Category
      if (contextMap['category'] != null) {
        queryParams['categorySlug'] = contextMap['category'];
      } else if (contextMap['activityType'] != null && contextMap['activityType'] != 'multi') {
        // Fallback
        queryParams['categorySlug'] = contextMap['activityType'];
      }

      // 3. Search Query (Tags)
      if (contextMap['tags'] is List && (contextMap['tags'] as List).isNotEmpty) {
        // Use the first tag as search query? Or pass all?
        // Let's us commas or just the first relevant one.
        queryParams['search'] = (contextMap['tags'] as List).first.toString();
      }

      // 4. Dates
      if (contextMap['dates'] != null) {
        // 'thisWeekend' -> 'weekend'
        String dateVal = contextMap['dates'].toString();
        if (dateVal == 'thisWeekend') dateVal = 'weekend';
        queryParams['dateFilter'] = dateVal;
      }

      // 5. Free Only
      if (contextMap['freeOnly'] == true) {
        queryParams['onlyFree'] = 'true';
      }
    }
    
    debugPrint("Navigating to search with: $queryParams");
    context.pushNamed('search', queryParameters: queryParams);
  }
  
  Widget _buildInfoStep({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFFF601F), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF444444),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLimitReachedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Image/Icon
              Container(
                height: 140,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF0EB), // Light orange bg
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                   // Glow effect
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF601F).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Main Icon/Image
                    ClipOval(
                      child: Image.asset(
                         'assets/images/petit_boo_logo.png', // Assuming this asset exists from previous steps
                         width: 80,
                         height: 80,
                         fit: BoxFit.cover,
                      ),
                    ),
                    // Lock icon badge
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: const Icon(Icons.lock, color: Color(0xFFFF601F), size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      "Oups, c'est déjà fini ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Petit Boo a besoin d'énergie pour continuer à chercher des pépites pour vous ! Rechargez son stock de Hibons pour débloquer la conversation.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // CTA Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                           // TODO: Navigate to store
                           Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF601F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0xFFFF601F).withOpacity(0.4),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.stars_rounded, color: Colors.amber),
                            SizedBox(width: 8),
                            Text(
                              "Obtenir des Hibons",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                     const SizedBox(height: 12),
                     // Secondary Button
                     TextButton(
                       onPressed: () => Navigator.of(context).pop(),
                       style: TextButton.styleFrom(
                         foregroundColor: Colors.grey[500],
                       ),
                       child: const Text("Peut-être plus tard"),
                     ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
