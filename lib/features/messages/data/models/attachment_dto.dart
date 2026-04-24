import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment_dto.freezed.dart';
part 'attachment_dto.g.dart';

@freezed
class AttachmentDto with _$AttachmentDto {
  const factory AttachmentDto({
    required String uuid,
    required String url,
    @JsonKey(name: 'original_name') required String originalName,
    @JsonKey(name: 'mime_type') required String mimeType,
    required int size,
    @JsonKey(name: 'is_image') @Default(false) bool isImage,
    @JsonKey(name: 'is_pdf') @Default(false) bool isPdf,
  }) = _AttachmentDto;

  factory AttachmentDto.fromJson(Map<String, dynamic> json) =>
      _$AttachmentDtoFromJson(json);
}
