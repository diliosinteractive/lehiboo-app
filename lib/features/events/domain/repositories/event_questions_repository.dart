import '../entities/event_question.dart';

/// Contrat du repository Q&A événement.
///
/// Toutes les méthodes qui modifient l'état nécessitent une authentification côté API.
/// La lecture (`getQuestions`) peut être faite sans token, mais le champ `userVoted`
/// de chaque question ne sera renseigné que si le token est présent.
abstract class EventQuestionsRepository {
  /// Liste paginée des questions visibles publiquement (approved + answered).
  /// Les questions épinglées remontent toujours en premier côté backend.
  Future<QuestionsPage> getQuestions(
    String eventSlug, {
    int page = 1,
    int perPage = 10,
  });

  /// Question de l'utilisateur authentifié sur cet événement (peut être pending).
  /// Retourne `null` si l'utilisateur n'a pas encore posé de question.
  Future<EventQuestion?> getMyQuestion(String eventSlug);

  /// Crée une question (status `pending` jusqu'à modération).
  /// Throw `DuplicateQuestionException` si l'utilisateur a déjà posé une question.
  /// Throw `QuestionValidationException` pour les erreurs 422 avec `errors.question`.
  Future<EventQuestion> createQuestion(String eventSlug, String text);

  /// Marque la question comme utile. Retourne le `helpful_count` du serveur
  /// (source de vérité).
  Future<int> markHelpful(String questionUuid);

  /// Retire le vote utile. Retourne le `helpful_count` du serveur.
  Future<int> unmarkHelpful(String questionUuid);
}

/// L'utilisateur a déjà soumis une question sur cet événement.
class DuplicateQuestionException implements Exception {
  final String message;
  const DuplicateQuestionException(this.message);

  @override
  String toString() => message;
}

/// Erreurs de validation du champ `question` (taille, contenu).
class QuestionValidationException implements Exception {
  final List<String> errors;
  const QuestionValidationException(this.errors);

  String get firstError => errors.isNotEmpty ? errors.first : 'Question invalide';

  @override
  String toString() => errors.join(', ');
}

/// Conflit optimiste : le vote "utile" a échoué (422).
/// Si `serverCount != null`, l'UI doit utiliser cette valeur plutôt que de
/// rollback à l'état précédent.
class HelpfulVoteException implements Exception {
  final String message;
  final int? serverCount;
  const HelpfulVoteException(this.message, {this.serverCount});

  @override
  String toString() => message;
}
