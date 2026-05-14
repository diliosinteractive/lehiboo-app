import 'package:flutter/material.dart';

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
          ? 'Aucune connexion internet'
          : 'Impossible de charger la conversation',
      message: isNetworkError
          ? 'Vérifiez votre connexion puis réessayez.'
          : ApiResponseHandler.extractError(error),
      onRetry: onRetry,
      icon: isNetworkError
          ? Icons.wifi_off_rounded
          : Icons.error_outline_rounded,
    );
  }
}
