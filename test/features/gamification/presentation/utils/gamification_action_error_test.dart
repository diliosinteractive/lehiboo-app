import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/gamification/presentation/utils/gamification_action_error.dart';

void main() {
  group('classifyDailyRewardFailure', () {
    test('recognizes a stable nested reason without reading translated copy',
        () {
      final error = _responseError({
        'message': 'This sentence can be translated independently.',
        'data': {'reason': 'already_today'},
      });

      expect(
        classifyDailyRewardFailure(error),
        GamificationActionFailure.dailyRewardAlreadyClaimed,
      );
    });

    test('does not infer state from a localized sentence', () {
      final error = _responseError({
        'message': 'Récompense déjà réclamée.',
      });

      expect(classifyDailyRewardFailure(error), isNull);
    });
  });

  group('classifyWheelSpinFailure', () {
    test('recognizes top-level API error codes', () {
      final error = _responseError({'error': 'already_spun_today'});

      expect(
        classifyWheelSpinFailure(error),
        GamificationActionFailure.wheelAlreadyUsed,
      );
    });

    test('normalizes hyphenated codes', () {
      final error = _responseError({'code': 'no-spin-available'});

      expect(
        classifyWheelSpinFailure(error),
        GamificationActionFailure.wheelAlreadyUsed,
      );
    });
  });

  group('dailyRewardSuccessMessage', () {
    test('uses a nonblank fallback when the API message is empty', () {
      expect(
        dailyRewardSuccessMessage('  ', 'Reward claimed: +20 Hibons!'),
        'Reward claimed: +20 Hibons!',
      );
    });

    test('preserves the API message after trimming surrounding whitespace', () {
      expect(
        dailyRewardSuccessMessage('  Bravo !  ', 'fallback'),
        'Bravo !',
      );
    });
  });
}

DioException _responseError(Map<String, dynamic> body) {
  final request = RequestOptions(path: '/mobile/hibons/action');
  return DioException.badResponse(
    statusCode: 422,
    requestOptions: request,
    response: Response<dynamic>(
      requestOptions: request,
      statusCode: 422,
      data: body,
    ),
  );
}
