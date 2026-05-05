# Audit complet — Feature Questions/Réponses aux événements

Date : 2026-04-20
Branche : `fix/home-page-reloading-state`

---

## 1. Localisation & Architecture

La feature est **intégrée dans le domaine events** (pas de dossier `qna/` dédié).

| Couche | Fichier | Lignes |
|--------|---------|--------|
| Data — DTOs | `lib/features/events/data/models/event_question_dto.dart` | 123 |
| Data — Datasource | `lib/features/events/data/datasources/event_social_api_datasource.dart` | 241 |
| Data — Repository | ❌ **ABSENT** (Q&A non intégrées dans `EventRepository`) | — |
| Domain — Entities | ❌ **ABSENT** (pas de `Question`, `Answer`, `QuestionAuthor`) | — |
| Domain — Repository interface | ❌ **ABSENT** | — |
| Presentation — Providers | `lib/features/events/presentation/providers/event_social_providers.dart` | 273 |
| Presentation — Widgets | `lib/features/events/presentation/widgets/detail/event_qa_section.dart` | 988 |
| Intégration | `lib/features/events/presentation/screens/event_detail_screen.dart` | 870+ |

**Architecture mixte** : les DTOs sont utilisés directement par la couche presentation, contournant la séparation Clean Architecture utilisée ailleurs dans le projet.

---

## 2. Data Layer

### 2.1 DTOs (`event_question_dto.dart`)

- **EventQuestionsResponseDto** : `data: List<EventQuestionDto>` + `meta: MetaPaginationDto?`
- **EventQuestionDto** : `uuid`, `question`, `status`, `helpfulCount`, `isPublic`, `isPinned`, `isAnswered`, `hasAnswer`, `author`, `answer`, `userVoted`, `createdAtFormatted`
- **QuestionAuthorDto** : `name`, `avatar?`, `initials`, `isGuest`
- **QuestionAnswerDto** : `uuid`, `answer`, `isOfficial`, `organizationId?`, `organizationName`, `createdAtFormatted`
- **MetaPaginationDto** : `currentPage`, `lastPage`, `perPage`, `total`

⚠️ **Double déclaration camelCase/snake_case** pour presque chaque champ booléen (`helpfulCount` + `helpfulCountCamel`, `isPublic` + `isPublicCamel`, etc.) — le backend renvoie inconsistamment les deux formats.

✅ **Parsing helpers robustes** : `_parseString`, `_parseStringOrNull`, `_parseInt`, `_parseBool`.

### 2.2 Datasource API (`event_social_api_datasource.dart`)

| Méthode | Endpoint | Gestion d'erreur |
|---------|----------|------------------|
| `getEventQuestions()` | `GET /events/{slug}/questions` | ✅ logging |
| `createQuestion()` | `POST /events/{slug}/questions` | ✅ |
| `markQuestionHelpful()` | `POST /questions/{uuid}/helpful` | ❌ **aucune** |
| `unmarkQuestionHelpful()` | `DELETE /questions/{uuid}/helpful` | ❌ **aucune** |
| `getMyQuestion()` | `GET /events/{slug}/my-question` | ✅ try/catch, retourne `null` |

Paramètres `getEventQuestions()` : `page=1`, `perPage=15`, `answeredOnly=false`, `unansweredOnly=false`.

`createQuestion()` supporte les paramètres `guestName` / `guestEmail` pour les utilisateurs non connectés.

⚠️ **15 `debugPrint()`** présents — à nettoyer avant prod.

### 2.3 Couche Repository

❌ **Absent pour Q&A**. Les Q&A ne sont pas dans `EventRepository` ni `EventRepositoryImpl`. Les providers appellent directement le datasource.

---

## 3. Domain Layer

❌ **Entièrement absent**.

- Aucune entité (`Question`, `Answer`, `QuestionAuthor`)
- Aucune interface de repository
- Aucun use case
- Aucun mapper DTO → Entity

**Implications** : pas de validation métier, pas d'abstraction, couplage direct presentation ↔ API.

---

## 4. Presentation Layer

### 4.1 Providers Riverpod (`event_social_providers.dart`)

| Provider | Type | Paramètres |
|----------|------|------------|
| `eventQuestionsProvider` | `FutureProvider.autoDispose.family` | `EventQuestionsParams` |
| `myQuestionProvider` | `FutureProvider.autoDispose.family` | `eventSlug: String` |
| `eventQuestionsNotifierProvider` | `StateNotifierProvider` | — |

`EventQuestionsParams` : `eventSlug`, `page=1`, `perPage=15`, `answeredOnly`, `unansweredOnly` — implémente correctement `==` et `hashCode`.

`EventQuestionsNotifier` :
- `createQuestion()` → invalide `eventQuestionsProvider` + `myQuestionProvider`
- `markHelpful()` → invalide `eventQuestionsProvider`
- `unmarkHelpful()` → invalide `eventQuestionsProvider`

✅ Invalidation systématique après mutation.

### 4.2 Widgets (`event_qa_section.dart`)

| Widget | Rôle |
|--------|------|
| `EventQASection` (`ConsumerWidget`) | Section Q&A sur détail event, fetch 10 questions, affiche max 5 répondues |
| `QACard` (`StatefulWidget`) | Question + réponse expandables, badges, vote "Utile" |
| `AskQuestionDialog` (`StatefulWidget`) | Modal bottom sheet, textarea 10-500 chars |

### 4.3 Intégration `EventDetailScreen`

```dart
EventQASection(
  eventSlug: event.slug,
  eventTitle: event.title,
  onViewAll: () => _showAllQuestions(event),
),
```

⚠️ `_showAllQuestions()` n'est qu'un `SnackBar` avec TODO — **navigation non implémentée**.

---

## 5. Flux utilisateur

### 5.1 Poser une question

1. Clic "Poser" → `AskQuestionDialog.show()`
2. Saisie 10-500 chars
3. Submit → `createQuestion()` → `POST /events/{slug}/questions`
4. Succès : SnackBar "Votre question a été envoyée" + invalidation providers
5. Erreur : SnackBar "Erreur lors de l'envoi"

⚠️ Les champs `guestName` / `guestEmail` existent côté datasource mais **ne sont jamais capturés dans l'UI**.

### 5.2 Consulter les réponses

- Question avec réponse → chevron expandable
- Affiche texte, organisation, date, badge "Réponse officielle"
- Bouton "Utile" avec compteur

### 5.3 Voter "utile"

1. Clic "Utile" → `markHelpful(questionUuid)`
2. `POST /questions/{uuid}/helpful`
3. Invalidation → **refetch complet de la liste** (pas d'optimistic update)

---

## 6. Problèmes critiques

| Sévérité | Problème | Fichier:ligne |
|----------|----------|---------------|
| 🔴 CRITIQUE | "Voir toutes les questions" = simple `SnackBar`, aucune route/écran dédié | `event_detail_screen.dart` (`_showAllQuestions`) |
| 🔴 CRITIQUE | Champs `guestName`/`guestEmail` passés à l'API mais **aucune UI** ne les capture | `event_qa_section.dart:700-987` |
| 🟡 MAJEUR | Pas de couche domain (Clean Architecture violée) | `domain/` |
| 🟡 MAJEUR | `markHelpful`/`unmarkHelpful` sans try/catch — erreurs silencieuses | `event_social_api_datasource.dart:212-223` |
| 🟡 MAJEUR | Pas d'optimistic update sur vote (refetch full liste) | `event_social_providers.dart:248` |
| 🟠 MOYEN | Magic number `take(5)` couplé à `perPage=10` | `event_qa_section.dart:269` |
| 🟠 MOYEN | Pattern `\|\|` camelCase répété 5× (`hasAnswer`, `helpfulCount`, `userVoted`, `isOfficial`, `orgName`) | `event_qa_section.dart:268+` |
| 🟠 MOYEN | Pas de suppression/édition de question (endpoints absents) | — |
| 🟠 MOYEN | Zéro tests (unit/widget/integration) | — |
| 🔵 MINEUR | 15× `debugPrint()` à nettoyer prod | `event_social_api_datasource.dart` |
| 🔵 MINEUR | Pas de Semantics / dark mode dans `QACard` | `event_qa_section.dart` |

---

## 7. Points forts

- ✅ **UUID respecté** partout (conforme règle CLAUDE.md)
- ✅ DTOs robustes avec parsing helpers tolérants
- ✅ Invalidation systématique des providers après mutations
- ✅ Pagination API supportée (`page`, `perPage`)
- ✅ Validation formulaire (min 10, max 500 chars)
- ✅ Haptic feedback, empty state, loading, gestion d'erreur de base
- ✅ Distinction visuelle réponse officielle (badge + fond vert)
- ✅ `getMyQuestion()` sécurisé (try/catch → `null`)

---

## 8. Flux API complet

```
┌──────────────────────────────────────────────────────────────┐
│ GET /events/{slug}/questions?page=1&per_page=10              │
│ → EventQuestionsResponseDto { data[], meta }                 │
└──────────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────────┐
│ Affiche max 5 questions répondues (take(5))                  │
│ Bouton "Voir toutes..." → SnackBar (navigation KO!)          │
└──────────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────────┐
│ Clic "Poser une question"                                    │
│ → AskQuestionDialog (pas de champ guestName/Email en UI!)    │
│ → POST /events/{slug}/questions                              │
│ → Invalidate eventQuestionsProvider + myQuestionProvider     │
└──────────────────────────────────────────────────────────────┘
                          ↓
┌──────────────────────────────────────────────────────────────┐
│ Clic "Utile"                                                 │
│ → POST /questions/{uuid}/helpful (NO error handling!)        │
│ → Invalidate → full refetch (NO optimistic update!)          │
└──────────────────────────────────────────────────────────────┘
```

---

## 9. Recommandations priorisées

### Court terme (bloquants UX)

1. **Implémenter la navigation "Voir toutes les questions"**
   - Créer `AllQuestionsScreen` avec pagination/infinite scroll
   - Ajouter route `/event/{slug}/questions`
   - Brancher `_showAllQuestions()` dessus

2. **UI guest name/email**
   - Ajouter deux champs optionnels dans `AskQuestionDialog` visibles si user non connecté
   - Sinon récupérer l'identité depuis le provider d'auth

3. **Gestion d'erreur des votes**
   - Wrapper try/catch dans `markHelpful()`/`unmarkHelpful()`
   - SnackBar d'erreur utilisateur

### Moyen terme (qualité architecturale)

4. **Créer la couche domain**
   - `domain/entities/question.dart`, `answer.dart`, `question_author.dart`
   - `domain/repositories/question_repository.dart` + implémentation
   - Mapper DTO → Entity

5. **Optimistic update**
   - Incrémenter `helpfulCount` localement avant l'appel
   - Rollback en cas d'erreur

6. **Refactor double camelCase**
   - Extension `EventQuestionDtoX` avec getters normalisés (`effectiveHasAnswer`, `effectiveHelpfulCount`...)
   - Éliminer les `||` répétés dans les widgets

### Long terme

7. **Tests**
   - Unit : `EventQuestionsNotifier`, datasource
   - Widget : `QACard`, `AskQuestionDialog`, `EventQASection`
   - Integration : flux création + vote

8. **Pagination UI complète** dans `AllQuestionsScreen` (infinite scroll ou pages)

9. **Suppression/édition** de question (si auteur) — nécessite endpoints backend

10. **Accessibilité**
    - `Semantics` sur `QACard`, boutons vote
    - Support dark mode
    - Keyboard navigation

---

## 10. Conclusion

La feature Q&A est **fonctionnelle pour les cas d'usage basiques** (lecture, création, vote) mais souffre de **deux défauts bloquants UX** :

- Navigation "Voir toutes" non implémentée
- UI guest non exposée (fonctionnalité API inutilisable)

Elle est également **non-conforme à l'architecture Clean** du reste du projet (pas de domain layer). **Zéro test**.

**Backlog immédiat recommandé** : 3 tickets
1. Écran liste complète des questions
2. UI capture guest name/email
3. Gestion d'erreur des votes + optimistic update
