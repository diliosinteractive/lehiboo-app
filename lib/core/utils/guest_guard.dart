import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/widgets/guest_restriction_dialog.dart';

class GuestGuard {
  static Future<bool> check({
    required BuildContext context,
    required WidgetRef ref,
    required String featureName,
  }) async {
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    
    if (isAuthenticated) {
      return true;
    }

    // Dialog returns `true` when the user signs in inline so the caller
    // can resume the gated action (favoriting, posting a review, etc.)
    // without losing in-flight UI state.
    return await GuestRestrictionDialog.show(context, featureName: featureName);
  }
}
