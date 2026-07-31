import 'package:dio/dio.dart';

/// Stable, operation-specific failures returned by the Hibons API.
///
/// The API has used both top-level codes and nested `data.reason` values over
/// time. Keeping that compatibility here avoids coupling user-facing copy to
/// a translated backend sentence.
enum GamificationActionFailure {
  dailyRewardAlreadyClaimed,
  wheelAlreadyUsed,
}

GamificationActionFailure? classifyDailyRewardFailure(Object error) {
  final code = _gamificationErrorCode(error);
  if (_dailyRewardAlreadyClaimedCodes.contains(code)) {
    return GamificationActionFailure.dailyRewardAlreadyClaimed;
  }
  return null;
}

GamificationActionFailure? classifyWheelSpinFailure(Object error) {
  final code = _gamificationErrorCode(error);
  if (_wheelAlreadyUsedCodes.contains(code)) {
    return GamificationActionFailure.wheelAlreadyUsed;
  }
  return null;
}

/// Prefer the localized API success message, with a guaranteed non-blank
/// fallback for older responses where `message` is absent or empty.
String dailyRewardSuccessMessage(String apiMessage, String fallback) {
  final message = apiMessage.trim();
  return message.isEmpty ? fallback : message;
}

const _dailyRewardAlreadyClaimedCodes = <String>{
  'already_today',
  'already_claimed',
  'daily_already_claimed',
  'daily_reward_already_claimed',
  'reward_already_claimed',
};

const _wheelAlreadyUsedCodes = <String>{
  'already_today',
  'already_spun',
  'already_spun_today',
  'wheel_already_used',
  'wheel_already_used_today',
  'wheel_spin_already_used',
  'no_spin_available',
  'spin_unavailable',
};

String? _gamificationErrorCode(Object error) {
  if (error is! DioException) return null;

  final body = error.response?.data;
  if (body is! Map) return null;

  final root = Map<String, dynamic>.from(body);
  final candidates = <Object?>[
    root['code'],
    root['error_code'],
    root['reason'],
    if (root['error'] is String) root['error'],
    if (root['error'] is Map) (root['error'] as Map)['code'],
    if (root['error'] is Map) (root['error'] as Map)['error_code'],
    if (root['error'] is Map) (root['error'] as Map)['reason'],
    if (root['data'] is Map) (root['data'] as Map)['code'],
    if (root['data'] is Map) (root['data'] as Map)['error_code'],
    if (root['data'] is Map) (root['data'] as Map)['reason'],
  ];

  for (final candidate in candidates) {
    if (candidate is! String) continue;
    final normalized = candidate.trim().toLowerCase().replaceAll('-', '_');
    if (_dailyRewardAlreadyClaimedCodes.contains(normalized) ||
        _wheelAlreadyUsedCodes.contains(normalized)) {
      return normalized;
    }
  }
  return null;
}
