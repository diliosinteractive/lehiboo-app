import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/petit_boo/presentation/providers/conversation_list_provider.dart';

void main() {
  test('Petit Boo history keeps pagination errors separate and clearable', () {
    final state = const ConversationListState().copyWith(
      hasMore: true,
      loadMoreError: ConversationListError.loadFailed,
    );

    expect(state.error, isNull);
    expect(state.loadMoreError, ConversationListError.loadFailed);
    expect(state.hasMore, isTrue);
    expect(state.copyWith(loadMoreError: null).loadMoreError, isNull);
  });
}
