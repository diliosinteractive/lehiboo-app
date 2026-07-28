import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/locked_event_shell.dart';

part 'locked_event_shell_dto.freezed.dart';
part 'locked_event_shell_dto.g.dart';

/// Locked-shell preview returned by `GET /events/{id}` when the event is
/// password-protected (spec §2.1). The server emits dual snake/camel field
/// names (`excerpt`/`short_description`, `cover_image`/`featured_image`);
/// we keep both and prefer the canonical one via [toEntity].
@freezed
class LockedEventShellDto with _$LockedEventShellDto {
  const factory LockedEventShellDto({
    @JsonKey(fromJson: _string) @Default('') String uuid,
    @JsonKey(fromJson: _stringOrNull) String? slug,
    @JsonKey(fromJson: _string) @Default('') String title,
    @JsonKey(fromJson: _stringOrNull) String? excerpt,
    @JsonKey(name: 'short_description', fromJson: _stringOrNull)
    String? shortDescription,
    @JsonKey(name: 'cover_image', fromJson: _stringOrNull) String? coverImage,
    @JsonKey(name: 'featured_image', fromJson: _stringOrNull)
    String? featuredImage,
    @JsonKey(fromJson: _stringOrNull) String? visibility,
    @JsonKey(name: 'is_password_protected', fromJson: _bool)
    @Default(true)
    bool isPasswordProtected,
  }) = _LockedEventShellDto;

  factory LockedEventShellDto.fromJson(Map<String, dynamic> json) =>
      _$LockedEventShellDtoFromJson(json);
}

extension LockedEventShellDtoX on LockedEventShellDto {
  LockedEventShell toEntity() {
    return LockedEventShell(
      uuid: uuid,
      slug: slug,
      title: title,
      excerpt: _firstNonEmpty(excerpt, shortDescription),
      coverImage: _firstNonEmpty(coverImage, featuredImage),
      visibility: visibility,
      isPasswordProtected: isPasswordProtected,
    );
  }
}

String? _firstNonEmpty(String? a, String? b) {
  if (a != null && a.isNotEmpty) return a;
  if (b != null && b.isNotEmpty) return b;
  return null;
}

String _string(dynamic v) => v?.toString() ?? '';

String? _stringOrNull(dynamic v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

bool _bool(dynamic v) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) return v == 'true' || v == '1';
  return false;
}
