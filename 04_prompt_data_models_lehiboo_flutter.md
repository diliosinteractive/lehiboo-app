# 🧬 PROMPT_DATA_MODELS_LEHIBOO_FLUTTER.md
# Prompt complet pour générer tous les modèles de données & mappers Flutter pour LeHiboo

> À donner tel quel à **Google Gemini 3 Pro** pour générer :
> - les **Domain Models** (entités métier),
> - les **DTO** (pour l’API WordPress headless),
> - les **mappers** Domain ↔ DTO,
> - les **interfaces de repositories** et leurs **implémentations de base**.

---

# 🦉 1. CONTEXTE

Backend : **WordPress headless**, avec un plugin `lehiboo-core` exposant l’API REST :

- CPT : `activity`, `slot`, `booking`, `ticket`, `partner`, `city`, `editorial`.
- Taxonomies : `activity_category`, `activity_tag`, `age_range`, `audience`.
- Namespace REST : `/wp-json/lehiboo/v1/...`.

Frontend : **Application mobile Flutter** organisée par features (auth, home, search, events, booking, tickets, favorites, profile, calendar, editorial, partners).

Ce prompt doit permettre à Gemini de générer **toute la couche de modèles & mappers**.

---

# 🎯 2. OBJECTIFS

Gemini doit produire :

1. Des **Domain Models** (entités métier) avec **Freezed**.
2. Des **DTO** correspondant aux JSON renvoyés par l’API WordPress.
3. Des **extensions de mapping** DTO → Domain (et Domain → DTO si utile).
4. Des **interfaces de repositories** dans la couche `domain`.
5. Des **implémentations de base** dans la couche `data`, utilisant `dio`.
6. Quelques **tests unitaires** sur les mappers.

Le tout doit être **compilable**, propre, sans pseudo-code.

---

# 🧱 3. STRUCTURE DE DOSSIERS

Gemini doit utiliser cette structure :

```text
lib/
  domain/
    entities/
    repositories/
  data/
    models/       # DTO
    repositories/ # impl des repositories
    datasources/  # remote/local
```

Chaque feature pourra ensuite avoir sa propre déclinaison, mais la base est commune.

---

# 🧾 4. DOMAIN MODELS (ENTITÉS MÉTIER)

Tous les Domain Models doivent être définis avec **Freezed** + `equatable` implicite via Freezed, et générer **fromJson/toJson** si pertinent.

## 4.1. Utilisateur

```dart
@freezed
class HbUser with _$HbUser {
  const factory HbUser({
    required String id,
    required String email,
    String? name,
    String? avatarUrl,
    String? cityId,
    List<String>? interestsCategoryIds,
  }) = _HbUser;
}
```

---

## 4.2. Ville

```dart
@freezed
class City with _$City {
  const factory City({
    required String id,
    required String name,
    required String slug,
    double? lat,
    double? lng,
    String? region,
  }) = _City;
}
```

---

## 4.3. Partenaire

```dart
@freezed
class Partner with _$Partner {
  const factory Partner({
    required String id,
    required String name,
    String? description,
    String? logoUrl,
    String? cityId,
    String? website,
    String? email,
    String? phone,
    bool? verified,
  }) = _Partner;
}
```

---

## 4.4. Category, Tag, AgeRange, Audience

```dart
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
```

---

## 4.5. Activity & Slot (Créneaux)

```dart
enum IndoorOutdoor { indoor, outdoor, both }

enum ReservationMode {
  lehibooFree,
  lehibooPaid,
  externalUrl,
  phone,
  email,
}

@freezed
class Activity with _$Activity {
  const factory Activity({
    required String id,
    required String title,
    required String slug,
    required String description,
    String? excerpt,
    String? imageUrl,
    Category? category,
    List<Tag>? tags,
    AgeRange? ageRange,
    Audience? audience,
    bool? isFree,
    double? priceMin,
    double? priceMax,
    String? currency,
    IndoorOutdoor? indoorOutdoor,
    int? durationMinutes,
    City? city,
    Partner? partner,
    ReservationMode? reservationMode,
    String? externalBookingUrl,
    String? bookingPhone,
    String? bookingEmail,
    Slot? nextSlot,
  }) = _Activity;
}

@freezed
class Slot with _$Slot {
  const factory Slot({
    required String id,
    required String activityId,
    required DateTime startDateTime,
    required DateTime endDateTime,
    int? capacityTotal,
    int? capacityRemaining,
    double? priceMin,
    double? priceMax,
    String? currency,
    IndoorOutdoor? indoorOutdoor,
    String? status, // scheduled, cancelled, sold_out
  }) = _Slot;
}
```

---

## 4.6. Booking & Ticket

```dart
@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String userId,
    required String slotId,
    required String activityId,
    int? quantity,
    double? totalPrice,
    String? currency,
    String? status, // pending, confirmed, cancelled, refunded
    String? paymentProvider,
    String? paymentReference,
    DateTime? createdAt,
  }) = _Booking;
}

@freezed
class Ticket with _$Ticket {
  const factory Ticket({
    required String id,
    required String bookingId,
    required String userId,
    required String slotId,
    String? ticketType,
    String? qrCodeData,
    String? status, // active, used, refunded
  }) = _Ticket;
}
```

---

## 4.7. EditorialPost

```dart
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
```

---

## 4.8. SearchFilters & Paginated

```dart
@freezed
class SearchFilters with _$SearchFilters {
  const factory SearchFilters({
    String? query,
    String? cityId,
    String? categoryId,
    List<String>? ageRangeIds,
    bool? freeOnly,
    bool? indoorOnly,
    bool? outdoorOnly,
    int? durationBucket,
    DateTime? dateFrom,
    DateTime? dateTo,
    double? maxDistanceKm,
  }) = _SearchFilters;
}

@freezed
class Paginated<T> with _$Paginated<T> {
  const factory Paginated({
    required List<T> items,
    required int page,
    required int totalPages,
    required int totalItems,
  }) = _Paginated<T>;
}
```

---

# 🌐 5. DTO (DATA TRANSFER OBJECTS)

Gemini doit créer, sous `lib/data/models/`, des DTO reflétant les JSON WordPress.

## 5.1. ActivityDto

```dart
@freezed
class ActivityDto with _$ActivityDto {
  const factory ActivityDto({
    required int id,
    required String title,
    required String slug,
    String? excerpt,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    ActivityCategoryDto? category,
    List<TagDto>? tags,
    AgeRangeDto? ageRange,
    AudienceDto? audience,
    @JsonKey(name: 'is_free') bool? isFree,
    PriceDto? price,
    @JsonKey(name: 'indoor_outdoor') String? indoorOutdoor,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    CityDto? city,
    PartnerDto? partner,
    @JsonKey(name: 'reservation_mode') String? reservationMode,
    @JsonKey(name: 'external_booking_url') String? externalBookingUrl,
    @JsonKey(name: 'booking_phone') String? bookingPhone,
    @JsonKey(name: 'booking_email') String? bookingEmail,
    @JsonKey(name: 'next_slot') SlotDto? nextSlot,
  }) = _ActivityDto;

  factory ActivityDto.fromJson(Map<String, dynamic> json) => _$ActivityDtoFromJson(json);
}
```

Créer les DTO auxiliaires :

```dart
@freezed
class PriceDto with _$PriceDto {
  const factory PriceDto({
    double? min,
    double? max,
    String? currency,
  }) = _PriceDto;

  factory PriceDto.fromJson(Map<String, dynamic> json) => _$PriceDtoFromJson(json);
}

@freezed
class CityDto with _$CityDto { ... }
@freezed
class PartnerDto with _$PartnerDto { ... }
@freezed
class TagDto with _$TagDto { ... }
@freezed
class CategoryDto with _$CategoryDto { ... }
@freezed
class AgeRangeDto with _$AgeRangeDto { ... }
@freezed
class AudienceDto with _$AudienceDto { ... }
@freezed
class SlotDto with _$SlotDto { ... }
```

Même principe pour :
- `BookingDto`
- `TicketDto`
- `EditorialPostDto`

---

# 🔁 6. MAPPERS DTO ↔ DOMAIN

Gemini doit créer des **extensions** pour convertir DTO → Domain.

## 6.1. ActivityDtoX

```dart
extension ActivityDtoX on ActivityDto {
  Activity toDomain() {
    return Activity(
      id: id.toString(),
      title: title,
      slug: slug,
      description: description ?? '',
      excerpt: excerpt,
      imageUrl: imageUrl,
      category: category?.toDomain(),
      tags: tags?.map((t) => t.toDomain()).toList(),
      ageRange: ageRange?.toDomain(),
      audience: audience?.toDomain(),
      isFree: isFree,
      priceMin: price?.min,
      priceMax: price?.max,
      currency: price?.currency,
      indoorOutdoor: _mapIndoorOutdoor(indoorOutdoor),
      durationMinutes: durationMinutes,
      city: city?.toDomain(),
      partner: partner?.toDomain(),
      reservationMode: _mapReservationMode(reservationMode),
      externalBookingUrl: externalBookingUrl,
      bookingPhone: bookingPhone,
      bookingEmail: bookingEmail,
      nextSlot: nextSlot?.toDomain(),
    );
  }
}
```

Avec des helpers :

```dart
IndoorOutdoor? _mapIndoorOutdoor(String? value) { ... }
ReservationMode? _mapReservationMode(String? value) { ... }
```

Même principe pour :
- `SlotDtoX`
- `CityDtoX`
- `PartnerDtoX`
- `BookingDtoX`
- `TicketDtoX`
- `EditorialPostDtoX`

Si nécessaire, créer également des mappings Domain → DTO.

---

# 📚 7. REPOSITORIES (INTERFACES DOMAIN)

Sous `lib/domain/repositories/`, créer :

## 7.1. ActivityRepository

```dart
abstract class ActivityRepository {
  Future<Paginated<Activity>> searchActivities(SearchFilters filters);
  Future<Activity> getActivity(String id);
}
```

## 7.2. SlotRepository

```dart
abstract class SlotRepository {
  Future<List<Slot>> getSlotsByActivity(String activityId, {DateTime? from, DateTime? to});
}
```

## 7.3. BookingRepository

```dart
abstract class BookingRepository {
  Future<Booking> createBooking(Booking bookingDraft);
  Future<Booking> confirmBooking(String bookingId, {String? paymentIntentId});
  Future<void> cancelBooking(String bookingId);
  Future<List<Booking>> getMyBookings();
  Future<List<Ticket>> getMyTickets();
}
```

## 7.4. EditorialRepository, PartnerRepository, CityRepository

Définir des interfaces similaires et minimalistes.

---

# 🌍 8. IMPLÉMENTATIONS DATA (DIO)

Sous `lib/data/repositories/`, créer des impls :

- `ActivityRepositoryImpl`
- `SlotRepositoryImpl`
- `BookingRepositoryImpl`
- `EditorialRepositoryImpl`
- `PartnerRepositoryImpl`
- `CityRepositoryImpl`

Chaque impl doit :
- recevoir un `Dio` en dépendance,
- appeler les bons endpoints `/lehiboo/v1/...`,
- parser les JSON en DTO (`fromJson`),
- mapper en Domain via les extensions.

Exemple :

```dart
class ActivityRepositoryImpl implements ActivityRepository {
  ActivityRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<Paginated<Activity>> searchActivities(SearchFilters filters) async {
    final response = await _dio.get('/lehiboo/v1/activities', queryParameters: _mapFilters(filters));
    final data = response.data as Map<String, dynamic>;
    final items = (data['items'] as List)
        .map((e) => ActivityDto.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
    return Paginated<Activity>(
      items: items,
      page: data['page'] as int,
      totalPages: data['total_pages'] as int,
      totalItems: data['total_items'] as int,
    );
  }
}
```

---

# 🧪 9. TESTS UNITAIRES

Gemini doit générer des tests :

- tests de mapping :
  - `ActivityDto -> Activity`
  - `SlotDto -> Slot`
  - `BookingDto -> Booking`
  - `TicketDto -> Ticket`

- tests simples de repository avec `Dio` mocké (ex: `ActivityRepositoryImpl.searchActivities`).

---

# 🛠️ 10. DÉPENDANCES & BUILD

Gemini doit s’appuyer sur :

- `freezed`
- `freezed_annotation`
- `json_serializable`
- `json_annotation`
- `build_runner`
- `dio`

Et produire les commandes à lancer :

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

# 🎯 11. OBJECTIF FINAL

À l’issue de ce prompt, Gemini doit avoir généré :

- tous les Domain Models Freezed,
- tous les DTO correspondants,
- tous les mappers DTO ↔ Domain,
- les interfaces de repositories,
- les implémentations de base avec `dio`,
- un minimum de tests.

L’ensemble doit être **cohérent avec l’API WordPress LeHiboo** et prêt à être utilisé par le reste de l’application Flutter (features UI, logique de réservation, etc.).

