import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_question_dto.freezed.dart';
part 'event_question_dto.g.dart';

/// Response pour la liste des questions
@freezed
class EventQuestionsResponseDto with _$EventQuestionsResponseDto {
  const factory EventQuestionsResponseDto({
    @Default([]) List<EventQuestionDto> data,
    MetaPaginationDto? meta,
  }) = _EventQuestionsResponseDto;

  factory EventQuestionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EventQuestionsResponseDtoFromJson(json);
}

/// Une question individuelle
@freezed
class EventQuestionDto with _$EventQuestionDto {
  const factory EventQuestionDto({
    required String uuid,
    @JsonKey(fromJson: _parseString) @Default('') String question,
    @JsonKey(fromJson: _parseString) @Default('pending') String status,
    @JsonKey(name: 'helpful_count', fromJson: _parseInt) @Default(0) int helpfulCount,
    @JsonKey(name: 'helpfulCount', fromJson: _parseInt) @Default(0) int helpfulCountCamel,
    @JsonKey(name: 'is_public', fromJson: _parseBool) @Default(true) bool isPublic,
    @JsonKey(name: 'isPublic', fromJson: _parseBool) @Default(true) bool isPublicCamel,
    @JsonKey(name: 'is_pinned', fromJson: _parseBool) @Default(false) bool isPinned,
    @JsonKey(name: 'isPinned', fromJson: _parseBool) @Default(false) bool isPinnedCamel,
    @JsonKey(name: 'is_answered', fromJson: _parseBool) @Default(false) bool isAnswered,
    @JsonKey(name: 'isAnswered', fromJson: _parseBool) @Default(false) bool isAnsweredCamel,
    @JsonKey(name: 'has_answer', fromJson: _parseBool) @Default(false) bool hasAnswer,
    @JsonKey(name: 'hasAnswer', fromJson: _parseBool) @Default(false) bool hasAnswerCamel,
    QuestionAuthorDto? author,
    QuestionAnswerDto? answer,
    @JsonKey(name: 'user_voted', fromJson: _parseBool) @Default(false) bool userVoted,
    @JsonKey(name: 'userVoted', fromJson: _parseBool) @Default(false) bool userVotedCamel,
    @JsonKey(name: 'created_at_formatted', fromJson: _parseString) @Default('') String createdAtFormatted,
    @JsonKey(name: 'createdAtFormatted', fromJson: _parseString) @Default('') String createdAtFormattedCamel,
  }) = _EventQuestionDto;

  factory EventQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$EventQuestionDtoFromJson(json);
}

/// Auteur d'une question
@freezed
class QuestionAuthorDto with _$QuestionAuthorDto {
  const factory QuestionAuthorDto({
    @JsonKey(fromJson: _parseString) @Default('') String name,
    @JsonKey(fromJson: _parseStringOrNull) String? avatar,
    @JsonKey(fromJson: _parseString) @Default('') String initials,
    @JsonKey(name: 'is_guest', fromJson: _parseBool) @Default(false) bool isGuest,
    @JsonKey(name: 'isGuest', fromJson: _parseBool) @Default(false) bool isGuestCamel,
  }) = _QuestionAuthorDto;

  factory QuestionAuthorDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionAuthorDtoFromJson(json);
}

/// Réponse officielle à une question
@freezed
class QuestionAnswerDto with _$QuestionAnswerDto {
  const factory QuestionAnswerDto({
    required String uuid,
    @JsonKey(fromJson: _parseString) @Default('') String answer,
    @JsonKey(name: 'is_official', fromJson: _parseBool) @Default(true) bool isOfficial,
    @JsonKey(name: 'isOfficial', fromJson: _parseBool) @Default(true) bool isOfficialCamel,
    @JsonKey(name: 'organization_id', fromJson: _parseStringOrNull) String? organizationId,
    @JsonKey(name: 'organizationId', fromJson: _parseStringOrNull) String? organizationIdCamel,
    @JsonKey(name: 'organization_name', fromJson: _parseString) @Default('') String organizationName,
    @JsonKey(name: 'organizationName', fromJson: _parseString) @Default('') String organizationNameCamel,
    @JsonKey(name: 'created_at_formatted', fromJson: _parseString) @Default('') String createdAtFormatted,
    @JsonKey(name: 'createdAtFormatted', fromJson: _parseString) @Default('') String createdAtFormattedCamel,
  }) = _QuestionAnswerDto;

  factory QuestionAnswerDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionAnswerDtoFromJson(json);
}

/// Metadata de pagination
@freezed
class MetaPaginationDto with _$MetaPaginationDto {
  const factory MetaPaginationDto({
    @JsonKey(name: 'current_page', fromJson: _parseInt) @Default(1) int currentPage,
    @JsonKey(name: 'last_page', fromJson: _parseInt) @Default(1) int lastPage,
    @JsonKey(name: 'per_page', fromJson: _parseInt) @Default(15) int perPage,
    @JsonKey(fromJson: _parseInt) @Default(0) int total,
  }) = _MetaPaginationDto;

  factory MetaPaginationDto.fromJson(Map<String, dynamic> json) =>
      _$MetaPaginationDtoFromJson(json);
}

// Parsing helpers
String _parseString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

String? _parseStringOrNull(dynamic value) {
  if (value == null) return null;
  if (value is String) return value.isEmpty ? null : value;
  return value.toString();
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

bool _parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) return value.toLowerCase() == 'true' || value == '1';
  return false;
}
