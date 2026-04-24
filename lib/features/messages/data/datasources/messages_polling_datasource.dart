import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/conversation_dto.dart';
import 'messages_api_datasource.dart';

class MessagesPollingDatasource {
  final MessagesApiDataSource _api;
  MessagesPollingDatasource(this._api);

  Future<ConversationDto> getConversation(String uuid) {
    return _api.getConversation(uuid);
  }

  // Returns total unread count: vendor conversations + support conversations
  Future<int> getTotalUnreadCount() async {
    final results = await Future.wait([
      _api.getUnreadCount(),
      _api.getSupportUnreadCount(),
    ]);
    return results[0] + results[1];
  }
}

final messagesPollingDatasourceProvider = Provider<MessagesPollingDatasource>((ref) {
  return MessagesPollingDatasource(ref.read(messagesApiDataSourceProvider));
});
