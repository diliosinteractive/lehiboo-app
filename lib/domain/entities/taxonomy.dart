import 'package:freezed_annotation/freezed_annotation.dart';

part 'taxonomy.freezed.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String slug,
    required String name,
  }) = _Category;
}

@freezed
class Tag with _$Tag {
  const factory Tag({
    required String id,
    required String slug,
    required String name,
  }) = _Tag;
}

@freezed
class AgeRange with _$AgeRange {
  const factory AgeRange({
    required String id,
    required String label,
    int? minAge,
    int? maxAge,
  }) = _AgeRange;
}

@freezed
class Audience with _$Audience {
  const factory Audience({
    required String id,
    required String slug,
    required String name,
  }) = _Audience;
}
