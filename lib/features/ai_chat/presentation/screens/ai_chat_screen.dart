import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import '../providers/chat_provider.dart';
import '../../domain/models/chat_message.dart';
import '../widgets/ai_suggestion_carousel.dart';

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
        setState(() {
          _textController.text = result.recognizedWords;
          if (result.finalResult) {
            _isListening = false;
            // Optional: Auto-send? Let's wait for user to confirm
          }
        });
      },
      localeId: "fr_FR",
    );
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  void _handleSendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    ref.read(chatProvider.notifier).sendMessage(text);
    _textController.clear();
    
    // Scroll to bottom
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
          // Debug Brain Button
          IconButton(
            icon: const Icon(Icons.psychology_outlined),
            tooltip: 'Debug Cerveau IA',
            onPressed: () => _showDebugContext(context),
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
              itemCount: chatState.messages.isEmpty ? 1 : chatState.messages.length, // +1 for Empty Welcome
              itemBuilder: (context, index) {
                if (chatState.messages.isEmpty) {
                   // Initial Welcome visual
                   return _buildWelcomeBanner();
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
                 "${5 - chatState.messageCount} messages gratuits restants",
                 style: TextStyle(fontSize: 10, color: Colors.grey[400]),
               ),
             ),

          // Loading Indicator
          if (chatState.isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(color: Color(0xFFFF601F), backgroundColor: Colors.white),
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
                        hintText: _isListening ? 'Je vous écoute...' : 'Écrivez votre message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: _isListening ? Colors.red[50] : const Color(0xFFF5F5F5),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                      return GestureDetector(
                        onTap: hasText ? _handleSendMessage : _startListening,
                        child: CircleAvatar(
                          backgroundColor: hasText ? const Color(0xFFFF601F) : (_isListening ? Colors.red : Colors.grey[200]),
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
        // Text Bubble
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
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
                fontSize: 16, // Consistent font size
              ),
              strong: TextStyle( // Bold text
                 fontWeight: FontWeight.bold,
                 color: isUser ? Colors.white : const Color(0xFF222222),
              ),
            ),
          ),
        ),

        // Suggestions Carousel (Full Width, outside bubble)
        if (hasSuggestions)
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: AiSuggestionCarousel(
              activities: message.activitySuggestions!,
              onMoreTap: () => _navigateToSearchWithContext(message),
            ),
          ),
      ],
    );
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
      builder: (context) => AlertDialog(
        title: const Text("Oups, limite atteinte !"),
        content: const Text(
          "Vous avez utilisé vos 5 échanges gratuits. Créez un compte ou connectez-vous pour continuer à discuter avec Petit Boo.",
        ),
        actions: [
          TextButton(
             onPressed: () => Navigator.of(context).pop(), 
             child: const Text("Fermer"), 
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF601F)),
            onPressed: () {
               Navigator.of(context).pop();
            },
            child: const Text("Se connecter", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDebugContext(BuildContext context) {
     final aiService = ref.read(chatProvider.notifier).aiService; // Get public getter or expose it
     // Note: chatProvider exposes ChatState, not Notifier. 
     // We need to access the underlying service via provider reference if possible, 
     // or expose context via ChatState.
     // Better approach: Expose userContext in ChatState or just read it from the Notifier for debug.
  
     // Assuming we can get it from the notifier for now (requires notifier to be public or have getter)
     // Actually, ref.read(chatProvider.notifier) returns ChatNotifier. 
     // We need to add a getter in ChatNotifier first to access internal AiChatService safely.
     
     final chatNotifier = ref.read(chatProvider.notifier);
     final contextMap = chatNotifier.userContext; // We need to add this getter to ChatNotifier

     showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text("🧠 Cerveau de l'IA", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                   IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
             ),
             const Divider(),
             Expanded(
               child: SingleChildScrollView(
                 child: SelectableText(
                   contextMap.toString(), // Todo: Pretty print this
                   style: const TextStyle(fontFamily: 'Courier', fontSize: 12),
                 ),
               ),
             ),
          ],
        ),
      ),
    );
  }
}
