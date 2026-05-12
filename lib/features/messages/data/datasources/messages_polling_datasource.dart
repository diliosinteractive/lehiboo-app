import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/conversation_dto.dart';
import 'messages_api_datasource.dart';

class MessagesPollingDatasource {
  final MessagesApiDataSource _api;
  MessagesPollingDatasource(this._api);

  Future<ConversationDto> getConversation(String uuid) {
    return _api.getConversation(uuid);
  }

  // Returns total unread count: subscriber conversations + support conversations.
  // Each source is isolated — a failure in one does not zero out the other.
  Future<int> getTotalUnreadCount() async {
    final results = await Future.wait([
      _api.getUnreadCount().catchError((_) => 0),
      _api.getSupportUnreadCount().catchError((_) => 0),
    ]);
    return results[0] + results[1];
  }

  Future<int> getVendorUnreadCount() => _api.getVendorUnreadCount();

  Future<int> getAdminUnreadCount() => _api.getAdminUnreadCount();
}

final messagesPollingDatasourceProvider = Provider<MessagesPollingDatasource>((ref) {
  return MessagesPollingDatasource(ref.read(messagesApiDataSourceProvider));
});
