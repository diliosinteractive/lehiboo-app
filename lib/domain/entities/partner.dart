import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner.freezed.dart';

@freezed
class Partner with _$Partner {
  const factory Partner({
    required String id,
    required String name,
    String? description,
    String? logoUrl,
    String? cityId,
    String? website,
    String? email,
    String? phone,
    bool? verified,
  }) = _Partner;
}
