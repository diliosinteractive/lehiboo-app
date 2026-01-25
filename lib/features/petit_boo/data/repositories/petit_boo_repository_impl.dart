import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/petit_boo_repository.dart';
import '../datasources/petit_boo_api_datasource.dart';
import '../datasources/petit_boo_sse_datasource.dart';
import '../models/conversation_dto.dart';
import '../models/petit_boo_event_dto.dart';
import '../models/quota_dto.dart';

/// Provider for the repository implementation
final petitBooRepositoryImplProvider = Provider<PetitBooRepository>((ref) {
  final sseDataSource = ref.read(petitBooSseDataSourceProvider);
  final apiDataSource = ref.read(petitBooApiDataSourceProvider);

  return PetitBooRepositoryImpl(
    sseDataSource: sseDataSource,
    apiDataSource: apiDataSource,
  );
});

/// Implementation of PetitBooRepository
class PetitBooRepositoryImpl implements PetitBooRepository {
  final PetitBooSseDataSource _sseDataSource;
  final PetitBooApiDataSource _apiDataSource;

  PetitBooRepositoryImpl({
    required PetitBooSseDataSource sseDataSource,
    required PetitBooApiDataSource apiDataSource,
  })  : _sseDataSource = sseDataSource,
        _apiDataSource = apiDataSource;

  @override
  Stream<PetitBooEventDto> sendMessage({
    String? sessionUuid,
    required String message,
  }) {
    return _sseDataSource.sendMessage(
      sessionUuid: sessionUuid,
      message: message,
    );
  }

  @override
  Future<ConversationsResult> getConversations({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _apiDataSource.getConversations(
      page: page,
      perPage: perPage,
    );

    final meta = response.meta;

    return ConversationsResult(
      conversations: response.data,
      currentPage: meta?.page ?? page,
      totalPages: meta?.lastPage ?? 1,
      totalItems: meta?.total ?? response.data.length,
    );
  }

  @override
  Future<ConversationDto> getConversation(String uuid) {
    return _apiDataSource.getConversation(uuid);
  }

  @override
  Future<ConversationDto> createConversation({String? title}) {
    return _apiDataSource.createConversation(title: title);
  }

  @override
  Future<void> deleteConversation(String uuid) {
    return _apiDataSource.deleteConversation(uuid);
  }

  @override
  Future<QuotaDto> getQuota() {
    return _apiDataSource.getQuota();
  }

  @override
  Future<bool> isServiceAvailable() {
    return _sseDataSource.healthCheck();
  }

  @override
  void setAuthToken(String token) {
    _apiDataSource.setAuthToken(token);
  }

  @override
  void clearAuthToken() {
    _apiDataSource.clearAuthToken();
  }
}
