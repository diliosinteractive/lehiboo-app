/// Petit Boo AI Chat Feature
///
/// This module provides the AI-powered chat assistant "Petit Boo"
/// for the LeHiboo mobile app. It uses Server-Sent Events (SSE)
/// for real-time streaming responses.
///
/// ## Features
/// - Real-time streaming chat with SSE
/// - 8 tool integrations (bookings, tickets, events, favorites, etc.)
/// - Conversation history management
/// - User quota tracking
///
/// ## Usage
/// ```dart
/// // Navigate to Petit Boo chat
/// context.push('/petit-boo');
///
/// // Or with an existing session
/// context.push('/petit-boo?session=$sessionUuid');
///
/// // View conversation history
/// context.push('/petit-boo/history');
/// ```
library petit_boo;

// Data Layer - Models
export 'data/models/chat_message_dto.dart';
export 'data/models/conversation_dto.dart';
export 'data/models/petit_boo_event_dto.dart';
export 'data/models/quota_dto.dart';
export 'data/models/tool_result_dto.dart';

// Data Layer - DataSources
export 'data/datasources/petit_boo_api_datasource.dart';
export 'data/datasources/petit_boo_context_storage.dart';
export 'data/datasources/petit_boo_sse_datasource.dart';

// Data Layer - Repositories
export 'data/repositories/petit_boo_repository_impl.dart';

// Domain Layer - Repositories
export 'domain/repositories/petit_boo_repository.dart';

// Presentation Layer - Providers
export 'presentation/providers/conversation_list_provider.dart';
export 'presentation/providers/engagement_provider.dart';
export 'presentation/providers/petit_boo_chat_provider.dart';

// Presentation Layer - Screens
export 'presentation/screens/conversation_list_screen.dart';
export 'presentation/screens/petit_boo_brain_screen.dart';
export 'presentation/screens/petit_boo_chat_screen.dart';

// Presentation Layer - Widgets
export 'presentation/widgets/chat_input_bar.dart';
export 'presentation/widgets/limit_reached_dialog.dart';
export 'presentation/widgets/message_bubble.dart';
export 'presentation/widgets/quota_indicator.dart';
export 'presentation/widgets/streaming_text.dart';
export 'presentation/widgets/tool_result_card.dart';
export 'presentation/widgets/typing_indicator.dart';

// Presentation Layer - Result Widgets
export 'presentation/widgets/results/alerts_result_card.dart';
export 'presentation/widgets/results/bookings_result_card.dart';
export 'presentation/widgets/results/event_detail_result_card.dart';
export 'presentation/widgets/results/event_search_result_card.dart';
export 'presentation/widgets/results/favorites_result_card.dart';
export 'presentation/widgets/results/notifications_result_card.dart';
export 'presentation/widgets/results/profile_result_card.dart';
export 'presentation/widgets/results/tickets_result_card.dart';
