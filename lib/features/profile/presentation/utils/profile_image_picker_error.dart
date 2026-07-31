import 'package:flutter/services.dart';

enum ProfileImagePickerFailure {
  permissionDenied,
  pickerUnavailable,
}

/// Converts image_picker platform codes into stable, user-facing categories.
///
/// The original [PlatformException] message may contain SDK or device details,
/// so callers should localize this category instead of rendering that message.
ProfileImagePickerFailure classifyProfileImagePickerFailure(
  PlatformException exception,
) {
  final code = exception.code.toLowerCase();
  final isPermissionFailure = code == 'photo_access_denied' ||
      code == 'photo_access_restricted' ||
      code == 'camera_access_denied' ||
      code == 'access_denied' ||
      code == 'permission_denied' ||
      (code.contains('permission') &&
          (code.contains('denied') || code.contains('restricted')));

  return isPermissionFailure
      ? ProfileImagePickerFailure.permissionDenied
      : ProfileImagePickerFailure.pickerUnavailable;
}
