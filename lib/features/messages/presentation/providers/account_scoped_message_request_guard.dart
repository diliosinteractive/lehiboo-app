import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';

/// Prevents an async message-list request from publishing after its account or
/// query context has changed.
mixin AccountScopedMessageRequestGuard<T> on StateNotifier<T> {
  Ref get requestRef;
  String? get requestAccountId;
  AuthSessionKey get requestOwnerSession;

  int _requestGeneration = 0;

  bool get hasActiveRequestAccount {
    if (!mounted || requestAccountId == null) return false;
    return identical(
          requestRef.read(authSessionKeyProvider),
          requestOwnerSession,
        ) &&
        requestRef.read(authSessionUserIdProvider) == requestAccountId;
  }

  int? beginMessageListRequest() {
    if (!hasActiveRequestAccount) return null;
    return ++_requestGeneration;
  }

  bool canPublishMessageListRequest(int requestGeneration) {
    return hasActiveRequestAccount && requestGeneration == _requestGeneration;
  }
}
