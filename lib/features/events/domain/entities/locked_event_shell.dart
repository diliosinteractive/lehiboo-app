import 'package:freezed_annotation/freezed_annotation.dart';

part 'locked_event_shell.freezed.dart';

@freezed
class LockedEventShell with _$LockedEventShell {
  const factory LockedEventShell({
    required String uuid,
    String? slug,
    required String title,
    String? excerpt,
    String? coverImage,
    String? visibility,
    @Default(true) bool isPasswordProtected,
  }) = _LockedEventShell;
}
