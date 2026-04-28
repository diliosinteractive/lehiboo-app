import 'package:equatable/equatable.dart';

enum QuestionStatus {
  pending,
  approved,
  answered,
  rejected;

  static QuestionStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'approved':
        return QuestionStatus.approved;
      case 'answered':
        return QuestionStatus.answered;
      case 'rejected':
        return QuestionStatus.rejected;
      case 'pending':
      default:
        return QuestionStatus.pending;
    }
  }

  bool get isPublic =>
      this == QuestionStatus.approved || this == QuestionStatus.answered;
}

class QuestionAuthor extends Equatable {
  final String name;
  final String? avatarUrl;
  final String initials;
  final bool isGuest;

  const QuestionAuthor({
    required this.name,
    this.avatarUrl,
    this.initials = '',
    this.isGuest = false,
  });

  @override
  List<Object?> get props => [name, avatarUrl, initials, isGuest];
}

class QuestionAnswer extends Equatable {
  final String uuid;
  final String text;
  final bool isOfficial;
  final String organizationName;
  final String? organizationLogo;
  final String createdAtFormatted;

  const QuestionAnswer({
    required this.uuid,
    required this.text,
    this.isOfficial = true,
    this.organizationName = '',
    this.organizationLogo,
    this.createdAtFormatted = '',
  });

  @override
  List<Object?> get props => [
        uuid,
        text,
        isOfficial,
        organizationName,
        organizationLogo,
        createdAtFormatted,
      ];
}

class QuestionEvent extends Equatable {
  final String uuid;
  final String title;
  final String slug;
  final bool isDeleted;

  const QuestionEvent({
    required this.uuid,
    required this.title,
    required this.slug,
    this.isDeleted = false,
  });

  @override
  List<Object?> get props => [uuid, title, slug, isDeleted];
}

class EventQuestion extends Equatable {
  final String uuid;
  final String question;
  final QuestionStatus status;
  final bool isPinned;
  final int helpfulCount;
  final bool userVoted;
  final String createdAtFormatted;
  final QuestionAuthor? author;
  final QuestionAnswer? answer;
  final QuestionEvent? event;

  const EventQuestion({
    required this.uuid,
    required this.question,
    this.status = QuestionStatus.pending,
    this.isPinned = false,
    this.helpfulCount = 0,
    this.userVoted = false,
    this.createdAtFormatted = '',
    this.author,
    this.answer,
    this.event,
  });

  bool get hasAnswer => answer != null;
  bool get isAnswered => status == QuestionStatus.answered;

  EventQuestion copyWith({
    String? uuid,
    String? question,
    QuestionStatus? status,
    bool? isPinned,
    int? helpfulCount,
    bool? userVoted,
    String? createdAtFormatted,
    QuestionAuthor? author,
    QuestionAnswer? answer,
    QuestionEvent? event,
  }) {
    return EventQuestion(
      uuid: uuid ?? this.uuid,
      question: question ?? this.question,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      userVoted: userVoted ?? this.userVoted,
      createdAtFormatted: createdAtFormatted ?? this.createdAtFormatted,
      author: author ?? this.author,
      answer: answer ?? this.answer,
      event: event ?? this.event,
    );
  }

  @override
  List<Object?> get props => [
        uuid,
        question,
        status,
        isPinned,
        helpfulCount,
        userVoted,
        createdAtFormatted,
        author,
        answer,
        event,
      ];
}

class QuestionsPage extends Equatable {
  final List<EventQuestion> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const QuestionsPage({
    this.items = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  bool get hasMore => currentPage < lastPage;

  QuestionsPage copyWith({
    List<EventQuestion>? items,
    int? currentPage,
    int? lastPage,
    int? total,
  }) {
    return QuestionsPage(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [items, currentPage, lastPage, total];
}
