import '../../domain/entities/event_question.dart';
import '../models/event_question_dto.dart';

/// Mappe les DTO Q&A vers les entités du domaine.
///
/// Consolide les variantes snake_case / camelCase renvoyées par l'API
/// (le backend utilise parfois les deux pour la même valeur).
class EventQuestionMapper {
  const EventQuestionMapper._();

  static EventQuestion fromDto(EventQuestionDto dto) {
    return EventQuestion(
      uuid: dto.uuid,
      question: dto.question,
      status: QuestionStatus.fromString(dto.status),
      isPinned: dto.isPinned || dto.isPinnedCamel,
      helpfulCount: _pickInt(dto.helpfulCount, dto.helpfulCountCamel),
      userVoted: dto.userVoted || dto.userVotedCamel,
      createdAtFormatted: _pickString(
        dto.createdAtFormatted,
        dto.createdAtFormattedCamel,
      ),
      author: dto.author != null ? _authorFromDto(dto.author!) : null,
      answer: dto.answer != null ? _answerFromDto(dto.answer!) : null,
    );
  }

  static QuestionsPage pageFromDto(EventQuestionsResponseDto dto) {
    final items = dto.data.map(fromDto).toList(growable: false);
    final meta = dto.meta;
    return QuestionsPage(
      items: items,
      currentPage: meta?.currentPage ?? 1,
      lastPage: meta?.lastPage ?? 1,
      total: meta?.total ?? items.length,
    );
  }

  static QuestionAuthor _authorFromDto(QuestionAuthorDto dto) {
    return QuestionAuthor(
      name: dto.name.isNotEmpty ? dto.name : 'Anonyme',
      avatarUrl: dto.avatar,
      initials: dto.initials,
      isGuest: dto.isGuest || dto.isGuestCamel,
    );
  }

  static QuestionAnswer _answerFromDto(QuestionAnswerDto dto) {
    return QuestionAnswer(
      uuid: dto.uuid,
      text: dto.answer,
      isOfficial: dto.isOfficial || dto.isOfficialCamel,
      organizationName: _pickString(
        dto.organizationName,
        dto.organizationNameCamel,
      ),
      organizationLogo: null,
      createdAtFormatted: _pickString(
        dto.createdAtFormatted,
        dto.createdAtFormattedCamel,
      ),
    );
  }

  static int _pickInt(int snake, int camel) => snake != 0 ? snake : camel;
  static String _pickString(String snake, String camel) =>
      snake.isNotEmpty ? snake : camel;
}
