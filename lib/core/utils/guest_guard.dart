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

    await GuestRestrictionDialog.show(context, featureName: featureName);
    return false;
  }
}
