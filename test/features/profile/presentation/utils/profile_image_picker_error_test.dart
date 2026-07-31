import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/profile/presentation/utils/profile_image_picker_error.dart';

void main() {
  group('classifyProfileImagePickerFailure', () {
    for (final code in [
      'photo_access_denied',
      'photo_access_restricted',
      'permission_denied',
      'gallery_permission_restricted',
    ]) {
      test('classifies $code as a permission failure', () {
        final result = classifyProfileImagePickerFailure(
          PlatformException(code: code, message: 'technical SDK details'),
        );

        expect(result, ProfileImagePickerFailure.permissionDenied);
      });
    }

    test('classifies an unrelated platform failure as picker unavailable', () {
      final result = classifyProfileImagePickerFailure(
        PlatformException(code: 'already_active'),
      );

      expect(result, ProfileImagePickerFailure.pickerUnavailable);
    });
  });
}
