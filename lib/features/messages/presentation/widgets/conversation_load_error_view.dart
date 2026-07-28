import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../../core/widgets/feedback/hb_feedback.dart';

class ConversationLoadErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ConversationLoadErrorView({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isNetworkError = ApiResponseHandler.isNetworkError(error);

    return HbErrorView(
      title: isNetworkError
          ? context.l10n.commonNoInternetTitle
          : context.l10n.messagesConversationLoadError,
      message: isNetworkError
          ? context.l10n.commonCheckConnectionRetry
          : ApiResponseHandler.extractError(error),
      onRetry: onRetry,
      icon: isNetworkError
          ? Icons.wifi_off_rounded
          : Icons.error_outline_rounded,
    );
  }
}
