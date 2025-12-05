import 'package:freezed_annotation/freezed_annotation.dart';

part 'editorial.freezed.dart';

@freezed
class EditorialPost with _$EditorialPost {
  const factory EditorialPost({
    required String id,
    required String title,
    required String slug,
    required String excerpt,
    required String content,
    String? imageUrl,
    DateTime? publishedAt,
  }) = _EditorialPost;
}
