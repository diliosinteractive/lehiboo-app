import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class HbUser with _$HbUser {
  const factory HbUser({
    required String id,
    required String email,
    String? name,
    String? avatarUrl,
    String? cityId,
    List<String>? interestsCategoryIds,
  }) = _HbUser;
}
