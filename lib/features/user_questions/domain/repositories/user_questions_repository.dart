import '../../../events/domain/entities/event_question.dart';

/// Contrat du repository pour les questions de l'utilisateur connecté
/// (tous événements + tous statuts).
abstract class UserQuestionsRepository {
  Future<QuestionsPage> getMyQuestions({
    int page = 1,
    int perPage = 15,
  });
}
