# 🎟️ PROMPT_BOOKING_LOGIC_LEHIBOO_FLUTTER.md
# Prompt complet pour générer la logique de réservation & billetterie Flutter de LeHiboo

> À donner tel quel à **Google Gemini 3 Pro** pour implémenter :
> - la **state machine** de réservation (gratuit & payant),
> - les **controllers Riverpod**,
> - les **écrans du flow de réservation**,
> - l’intégration aux **repositories** & à l’API WordPress,
> - la gestion des **tickets avec QR code**.

---

# 🦉 1. CONTEXTE

LeHiboo est une application mobile Flutter permettant de :
- découvrir des activités et créneaux locaux,
- filtrer selon de nombreux critères,
- **réserver** des créneaux (gratuits ou payants),
- générer des **billets** avec QR code.

Backend : **WordPress headless** (namespace `/lehiboo/v1`), avec plugin `lehiboo-core` qui gère :
- `activity`, `slot`, `booking`, `ticket`, `partner`, etc.

Ce prompt se concentre sur la **feature Flutter `booking/`**.

---

# 🎯 2. OBJECTIF DE LA FEATURE BOOKING

Gemini doit construire un module Flutter complet capable de :

1. Démarrer une réservation depuis une page **Activité** ou un deep-link.
2. Laisser l’utilisateur choisir un **créneau** (`Slot`) et une **quantité** de participants.
3. Récupérer les infos de l’acheteur + participants.
4. Gérer deux modes :
   - **`lehiboo_free`** : réservation gratuite (sans paiement).
   - **`lehiboo_paid`** : réservation payante (Stripe ou stub).
5. Créer & confirmer les **bookings** via l’API WordPress.
6. Récupérer & afficher les **tickets** avec QR code.
7. Afficher les **listes de réservations** et de **billets**.

Le tout avec **Riverpod**, **go_router**, **tests**, et un code propre.

---

# 🧱 3. STRUCTURE DU FEATURE BOOKING

Sous `lib/features/booking/` :

```text
lib/
  features/
    booking/
      domain/
        repositories/
          booking_repository.dart
        usecases/
          create_booking_usecase.dart
          confirm_booking_usecase.dart
          cancel_booking_usecase.dart
          get_my_bookings_usecase.dart
      data/
        datasources/
          booking_remote_data_source.dart
        models/
          booking_dto.dart
          ticket_dto.dart
        repositories/
          booking_repository_impl.dart
      presentation/
        controllers/
          booking_flow_controller.dart
          booking_list_controller.dart
        screens/
          booking_start_screen.dart
          booking_slot_selection_screen.dart
          booking_participant_screen.dart
          booking_payment_screen.dart
          booking_confirmation_screen.dart
          bookings_list_screen.dart
        widgets/
          booking_summary_card.dart
          booking_stepper_header.dart
          ticket_card.dart
```

Gemini doit générer **le code réel** pour ces éléments (ou leur sous-ensemble logique et cohérent).

---

# 🧬 4. STATE MACHINE DE RÉSERVATION

## 4.1. Étapes du flow

Créer un type `BookingStep` avec Freezed :

```dart
@freezed
class BookingStep with _$BookingStep {
  const factory BookingStep.selectSlot() = _SelectSlot;
  const factory BookingStep.participants() = _Participants;
  const factory BookingStep.payment() = _Payment;
  const factory BookingStep.confirmation() = _Confirmation;
}
```

## 4.2. Modèles de données du flow

```dart
@freezed
class ParticipantInfo with _$ParticipantInfo {
  const factory ParticipantInfo({
    String? firstName,
    String? lastName,
  }) = _ParticipantInfo;
}

@freezed
class BuyerInfo with _$BuyerInfo {
  const factory BuyerInfo({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) = _BuyerInfo;
}

@freezed
class BookingFlowState with _$BookingFlowState {
  const factory BookingFlowState({
    required BookingStep step,
    required Activity activity,
    Slot? selectedSlot,
    int quantity,
    BuyerInfo? buyerInfo,
    List<ParticipantInfo>? participants,
    double? totalPrice,
    String? currency,
    bool isFree,
    bool isSubmitting,
    String? errorMessage,
    Booking? confirmedBooking,
    List<Ticket>? tickets,
  }) = _BookingFlowState;
}
```

- `Activity`, `Slot`, `Booking`, `Ticket` viennent des Domain Models (autre prompt).
- `isFree` = dérivé de `Activity` / `ReservationMode` et prix total.

---

# 🌍 5. BOOKING REPOSITORY & DATA LAYER

## 5.1. Interface `BookingRepository`

Sous `booking/domain/repositories/booking_repository.dart` :

```dart
abstract class BookingRepository {
  Future<Booking> createBooking({
    required String activityId,
    required String slotId,
    required int quantity,
    required BuyerInfo buyer,
    required List<ParticipantInfo> participants,
  });

  Future<Booking> confirmBooking({
    required String bookingId,
    String? paymentIntentId,
  });

  Future<void> cancelBooking(String bookingId);

  Future<List<Booking>> getMyBookings();

  Future<List<Ticket>> getTicketsByBooking(String bookingId);
}
```

## 5.2. Remote Data Source

Sous `booking/data/datasources/booking_remote_data_source.dart` :

- Utiliser `Dio`.
- Appeler les endpoints WordPress :
  - `POST /lehiboo/v1/bookings`
  - `POST /lehiboo/v1/bookings/{id}/confirm`
  - `POST /lehiboo/v1/bookings/{id}/cancel`
  - `GET /lehiboo/v1/me/bookings`
  - `GET /lehiboo/v1/me/tickets`

Créer des DTO (`BookingDto`, `TicketDto`) + mappers vers Domain (`Booking`, `Ticket`).

## 5.3. Implémentation `BookingRepositoryImpl`

Sous `booking/data/repositories/booking_repository_impl.dart` :

- Injecter `BookingRemoteDataSource`.
- Implémenter les méthodes de `BookingRepository`.

---

# 🧠 6. BOOKING FLOW CONTROLLER (RIVERPOD)

Sous `booking/presentation/controllers/booking_flow_controller.dart` :

## 6.1. Provider principal

Créer un provider Riverpod family, ex :

```dart
final bookingFlowControllerProvider = StateNotifierProvider.autoDispose
    .family<BookingFlowController, BookingFlowState, Activity>((ref, activity) {
  final repo = ref.watch(bookingRepositoryProvider);
  return BookingFlowController(
    bookingRepository: repo,
    activity: activity,
  );
});
```

## 6.2. Classe `BookingFlowController`

```dart
class BookingFlowController extends StateNotifier<BookingFlowState> {
  BookingFlowController({
    required this.bookingRepository,
    required Activity activity,
  }) : super(
          BookingFlowState(
            step: const BookingStep.selectSlot(),
            activity: activity,
            quantity: 1,
            isFree: activity.isFree ?? false,
            isSubmitting: false,
          ),
        );

  final BookingRepository bookingRepository;

  void selectSlot(Slot slot);
  void updateQuantity(int quantity);
  void updateBuyerInfo(BuyerInfo info);
  void updateParticipants(List<ParticipantInfo> participants);

  Future<void> goToParticipantsStep();
  Future<void> goToPaymentStep();
  Future<void> goToConfirmationStep();

  Future<void> submitFreeBooking();
  Future<void> submitPaidBooking({required String paymentIntentId});
}
```

### Règles métier :

- `goToParticipantsStep()` :
  - slot obligatoire
  - quantité > 0

- `goToPaymentStep()` :
  - buyerInfo complété (email valide, prénom, nom)
  - participants cohérents avec `quantity`
  - si activité `lehiboo_free` : on peut bypasser la PaymentStep et aller vers `submitFreeBooking()`.

- `submitFreeBooking()` :
  - appelle `createBooking` puis `confirmBooking` si backend le requiert (ou un seul endpoint selon design exact),
  - récupère `Booking` + `tickets`,
  - met à jour `BookingFlowState` avec `step = BookingStep.confirmation()`.

- `submitPaidBooking()` :
  - suppose qu’un `paymentIntentId` valide a été obtenu via Stripe,
  - appelle `confirmBooking` avec ce `paymentIntentId`,
  - met à jour l’état de la même façon.

---

# 💳 7. ÉCRAN DE PAIEMENT & STRIPE

Même si l’intégration Stripe complète est traitée ailleurs, Gemini doit prévoir une structure :

Sous `booking/presentation/screens/booking_payment_screen.dart` :

- Récupération du `BookingFlowState`.
- Si `isFree == true` :
  - afficher un message "Cette activité est gratuite, aucune information bancaire n'est requise".
  - bouton "Confirmer la réservation" qui appelle `submitFreeBooking()`.

- Si `isFree == false` et `reservationMode == lehibooPaid` :
  - intégrer (ou stubber) `flutter_stripe` via un service:
    - initialiser un PaymentSheet avec un `clientSecret` obtenu via backend,
    - ouvrir le PaymentSheet,
    - en cas de succès → fournir `paymentIntentId` à `submitPaidBooking()`.

Gemini peut **stubber** Stripe (création d'un `FakeStripeService`), mais doit laisser des **TODO(lehiboo)** et une architecture claire.

---

# 🧑‍💻 8. ÉCRANS DU FLOW DE RÉSERVATION

## 8.1. `BookingSlotSelectionScreen`

Responsabilités :
- afficher les informations principales de l’`Activity` (titre, image, résumé),
- lister les `Slot` à venir (provenant d’un provider `slotsByActivityProvider`),
- permettre la sélection d’un slot,
- permettre le choix de la quantité (Stepper),
- bouton **"Continuer"** → `goToParticipantsStep()`.


## 8.2. `BookingParticipantScreen`

Responsabilités :
- formulaire acheteur (BuyerInfo) : prénom, nom, email, téléphone,
- si `quantity > 1` : un formulaire simplifié pour participants (ou une liste de noms),
- validations (email format, champs obligatoires),
- boutons :
  - "Retour" (vers sélection slot),
  - "Continuer" → soit Payment, soit Confirmation si gratuit.


## 8.3. `BookingPaymentScreen`

- voir section Stripe ci-dessus.


## 8.4. `BookingConfirmationScreen`

Responsabilités :
- afficher un message de succès,
- résumé : activité, créneau, participants, montant,
- liste de tickets sous forme de `TicketCard` :
  - QR code,
  - statut,
  - actions : "Ajouter au calendrier", "Partager".


## 8.5. `BookingsListScreen`

Liste des réservations de l’utilisateur :
- utilise un `BookingListController` (voir section suivante),
- sections : "À venir" vs "Passées".

---

# 📋 9. BOOKING LIST CONTROLLER

Sous `booking/presentation/controllers/booking_list_controller.dart` :

Créer un `StateNotifier<AsyncValue<List<Booking>>>` ou `AsyncNotifier<List<Booking>>` :

```dart
final bookingsListControllerProvider =
    StateNotifierProvider<BookingListController, AsyncValue<List<Booking>>>(
  (ref) {
    final repo = ref.watch(bookingRepositoryProvider);
    return BookingListController(bookingRepository: repo)..load();
  },
);

class BookingListController extends StateNotifier<AsyncValue<List<Booking>>> {
  BookingListController({required this.bookingRepository})
      : super(const AsyncValue.loading());

  final BookingRepository bookingRepository;

  Future<void> load() async {
    try {
      final bookings = await bookingRepository.getMyBookings();
      state = AsyncValue.data(bookings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
```

---

# 🧾 10. WIDGETS SPÉCIFIQUES : BOOKING & TICKETS

## 10.1. `BookingSummaryCard`

- récapitulatif : activité, créneau, quantité, prix.

## 10.2. `BookingStepperHeader`

- indicateur d’étape (1/4 Sélection, 2/4 Infos, 3/4 Paiement, 4/4 Confirmation).

## 10.3. `TicketCard`

- titre activité,
- date & heure du slot,
- QR code via `qr_flutter` (`qrCodeData`),
- statut,
- bouton pour afficher le QR en plein écran.

---

# 🧭 11. INTÉGRATION AVEC `go_router`

Gemini doit définir des routes, par ex. :

```dart
'/booking/:activityId',
'/booking/:activityId/slots',
'/booking/:activityId/participants',
'/booking/:activityId/payment',
'/booking/:activityId/confirmation',
'/bookings',
'/ticket/:ticketId',
```

Le flow doit être **piloté par le state** du `BookingFlowController`, mais la navigation doit rester gérée par `go_router`.

---

# 🧪 12. TESTS À GÉNÉRER

Gemini doit créer des tests :

## 12.1. Tests unitaires

- sur `BookingFlowController` :
  - passage normal : selectSlot → participants → payment → confirmation,
  - cas `lehiboo_free` (skip paiement),
  - validations (slot obligatoire, email invalide…).

- sur `BookingRepositoryImpl` :
  - mapping correct des réponses JSON en `Booking` & `Ticket`.

## 12.2. Tests widget

- `BookingSlotSelectionScreen` :
  - affiche la liste des slots,
  - sélection + clic Continuer → navigation vers Participants.

- `BookingParticipantScreen` :
  - validation du formulaire,
  - affichage des erreurs.

- `BookingConfirmationScreen` :
  - affiche les tickets.

---

# 🛠️ 13. DÉPENDANCES & UTILITAIRES

Gemini doit s’appuyer sur :

- `flutter_riverpod`
- `go_router`
- `dio`
- `freezed` + `json_serializable`
- `qr_flutter`
- `flutter_stripe` (ou stub provisoire)

Les services auxiliaires (ex : `CalendarService`, `StripeService`) peuvent être créés dans un dossier `core/services/`.

---

# 🎯 14. OBJECTIF FINAL

À l’issue de ce prompt, Gemini doit fournir un **module complet de réservation & billetterie** pour LeHiboo :

- flow multi-écrans,
- contrôleurs Riverpod,
- appels API WordPress pour bookings & tickets,
- gestion des activités gratuites vs payantes,
- gestion des tickets avec QR code,
- tests de base.

Le tout doit être **compilable, structuré, et prêt à être branché** avec le reste de l’application Flutter LeHiboo.

