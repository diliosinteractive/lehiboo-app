# Stories Module Migration — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate the stories feature from the deprecated trending events endpoint (`GET /events?orderby=views`) to the new dedicated Stories API (`GET /v1/stories/active` + `POST /v1/stories/{uuid}/impression`).

**Architecture:** New `lib/features/stories/` feature directory following the existing clean architecture pattern (data/domain/presentation layers). A dedicated `Story` domain entity replaces the reused `Activity` entity, since the new API has story-specific fields (mediaType, impressionsCount, organization, slotPosition). The UI widget (`event_stories.dart`) is updated in-place to consume `Story` objects. Video support is deferred — video stories render as images for now.

**Tech Stack:** Flutter/Dart, Riverpod (StateNotifier), Dio, manual DTOs (matching alerts/favorites pattern), GoRouter

**Migration spec:** `docs/MOBILE_STORIES_MIGRATION.md`

---

## File Map

### New files (stories feature — clean architecture)

| File | Responsibility |
|------|---------------|
| `lib/features/stories/domain/entities/story.dart` | `Story` domain entity + `StoryMediaType` enum |
| `lib/features/stories/domain/repositories/stories_repository.dart` | Abstract repository interface + Riverpod provider stub |
| `lib/features/stories/data/models/story_dto.dart` | `StoryDto` with nested `StoryEventDto`, `StoryOrganizationDto`, `StoryCategoryDto` — manual `fromJson` |
| `lib/features/stories/data/mappers/story_mapper.dart` | `StoryMapper.toStory(StoryDto) -> Story` |
| `lib/features/stories/data/datasources/stories_api_datasource.dart` | `getActiveStories()` + `recordImpression(uuid)` — Dio calls |
| `lib/features/stories/data/repositories/stories_repository_impl.dart` | Implements interface, wires datasource + mapper |
| `lib/features/stories/presentation/providers/stories_provider.dart` | `activeStoriesProvider` — AsyncNotifier for stories list |

### Modified files

| File | Change |
|------|--------|
| `lib/config/dio_client.dart` | Add `/stories` to public endpoints list |
| `lib/features/home/presentation/widgets/event_stories.dart` | Swap `Activity` for `Story`, add impression tracking, add loop behavior, update CTA navigation |
| `lib/features/home/presentation/screens/home_screen.dart` | Replace `featuredActivitiesProvider` with `activeStoriesProvider` in refresh |
| `lib/features/home/presentation/providers/home_providers.dart` | Remove `FeaturedActivitiesNotifier` + `featuredActivitiesProvider` |
| `lib/features/home/presentation/widgets/partner_highlight.dart` | Decouple from `featuredActivitiesProvider` (it still uses it as mock data) |

---

## Task 1: Story domain entity

**Files:**
- Create: `lib/features/stories/domain/entities/story.dart`

- [ ] **Step 1: Create the Story entity**

```dart
// lib/features/stories/domain/entities/story.dart
import 'package:equatable/equatable.dart';

enum StoryMediaType { image, video }

class Story extends Equatable {
  final String uuid;
  final String title;
  final String mediaUrl;
  final StoryMediaType mediaType;
  final String type; // "reserved" or "optional"
  final DateTime startDate;
  final DateTime endDate;
  final int slotPosition;
  final int impressionsCount;

  // Flattened from nested event object
  final String eventUuid;
  final String eventSlug;
  final String eventTitle;
  final String? eventFeaturedImage;
  final String? eventCity;
  final String? eventBookingMode;

  // Flattened from nested organization object
  final String? organizationName;

  // Flattened from nested category object
  final String? categoryName;

  const Story({
    required this.uuid,
    required this.title,
    required this.mediaUrl,
    required this.mediaType,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.slotPosition,
    required this.impressionsCount,
    required this.eventUuid,
    required this.eventSlug,
    required this.eventTitle,
    this.eventFeaturedImage,
    this.eventCity,
    this.eventBookingMode,
    this.organizationName,
    this.categoryName,
  });

  @override
  List<Object?> get props => [uuid];
}
```

- [ ] **Step 2: Verify no syntax errors**

Run: `dart analyze lib/features/stories/domain/entities/story.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/features/stories/domain/entities/story.dart
git commit -m "feat(stories): add Story domain entity"
```

---

## Task 2: Story DTO with JSON parsing

**Files:**
- Create: `lib/features/stories/data/models/story_dto.dart`

- [ ] **Step 1: Create StoryDto and nested DTOs**

The API response nests `event`, `organization`, and `event.primaryCategory` objects. We parse them into flat DTOs.

```dart
// lib/features/stories/data/models/story_dto.dart

class StoryCategoryDto {
  final int id;
  final String name;

  StoryCategoryDto({required this.id, required this.name});

  factory StoryCategoryDto.fromJson(Map<String, dynamic> json) {
    return StoryCategoryDto(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class StoryOrganizationDto {
  final String uuid;
  final String? organizationName;
  final String? displayName;

  StoryOrganizationDto({
    required this.uuid,
    this.organizationName,
    this.displayName,
  });

  factory StoryOrganizationDto.fromJson(Map<String, dynamic> json) {
    return StoryOrganizationDto(
      uuid: json['uuid'] as String? ?? '',
      organizationName: json['organizationName'] as String?,
      displayName: json['displayName'] as String?,
    );
  }
}

class StoryEventDto {
  final String uuid;
  final String slug;
  final String title;
  final String? featuredImage;
  final String? city;
  final String? bookingMode;
  final StoryCategoryDto? primaryCategory;

  StoryEventDto({
    required this.uuid,
    required this.slug,
    required this.title,
    this.featuredImage,
    this.city,
    this.bookingMode,
    this.primaryCategory,
  });

  factory StoryEventDto.fromJson(Map<String, dynamic> json) {
    return StoryEventDto(
      uuid: json['uuid'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      featuredImage: json['featuredImage'] as String?,
      city: json['city'] as String?,
      bookingMode: json['bookingMode'] as String?,
      primaryCategory: json['primaryCategory'] != null
          ? StoryCategoryDto.fromJson(json['primaryCategory'] as Map<String, dynamic>)
          : null,
    );
  }
}

class StoryDto {
  final String uuid;
  final String type;
  final String status;
  final String title;
  final String mediaUrl;
  final String mediaType;
  final String startDate;
  final String endDate;
  final int slotPosition;
  final int impressionsCount;
  final StoryOrganizationDto? organization;
  final StoryEventDto? event;

  StoryDto({
    required this.uuid,
    required this.type,
    required this.status,
    required this.title,
    required this.mediaUrl,
    required this.mediaType,
    required this.startDate,
    required this.endDate,
    required this.slotPosition,
    required this.impressionsCount,
    this.organization,
    this.event,
  });

  factory StoryDto.fromJson(Map<String, dynamic> json) {
    return StoryDto(
      uuid: json['uuid'] as String? ?? '',
      type: json['type'] as String? ?? 'optional',
      status: json['status'] as String? ?? 'active',
      title: json['title'] as String? ?? '',
      mediaUrl: json['mediaUrl'] as String? ?? '',
      mediaType: json['mediaType'] as String? ?? 'image',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      slotPosition: json['slotPosition'] as int? ?? 0,
      impressionsCount: json['impressionsCount'] as int? ?? 0,
      organization: json['organization'] != null
          ? StoryOrganizationDto.fromJson(json['organization'] as Map<String, dynamic>)
          : null,
      event: json['event'] != null
          ? StoryEventDto.fromJson(json['event'] as Map<String, dynamic>)
          : null,
    );
  }
}
```

- [ ] **Step 2: Verify no syntax errors**

Run: `dart analyze lib/features/stories/data/models/story_dto.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/features/stories/data/models/story_dto.dart
git commit -m "feat(stories): add StoryDto with JSON parsing"
```

---

## Task 3: Story mapper (DTO to entity)

**Files:**
- Create: `lib/features/stories/data/mappers/story_mapper.dart`

- [ ] **Step 1: Create StoryMapper**

```dart
// lib/features/stories/data/mappers/story_mapper.dart
import '../../domain/entities/story.dart';
import '../models/story_dto.dart';

class StoryMapper {
  static Story toStory(StoryDto dto) {
    return Story(
      uuid: dto.uuid,
      title: dto.title,
      mediaUrl: dto.mediaUrl,
      mediaType: dto.mediaType == 'video'
          ? StoryMediaType.video
          : StoryMediaType.image,
      type: dto.type,
      startDate: DateTime.tryParse(dto.startDate) ?? DateTime.now(),
      endDate: DateTime.tryParse(dto.endDate) ?? DateTime.now(),
      slotPosition: dto.slotPosition,
      impressionsCount: dto.impressionsCount,
      eventUuid: dto.event?.uuid ?? '',
      eventSlug: dto.event?.slug ?? '',
      eventTitle: dto.event?.title ?? dto.title,
      eventFeaturedImage: dto.event?.featuredImage,
      eventCity: dto.event?.city,
      eventBookingMode: dto.event?.bookingMode,
      organizationName: dto.organization?.organizationName ??
          dto.organization?.displayName,
      categoryName: dto.event?.primaryCategory?.name,
    );
  }

  static List<Story> toStories(List<StoryDto> dtos) {
    return dtos.map(toStory).toList();
  }
}
```

- [ ] **Step 2: Verify no syntax errors**

Run: `dart analyze lib/features/stories/data/mappers/story_mapper.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/features/stories/data/mappers/story_mapper.dart
git commit -m "feat(stories): add StoryMapper (DTO to entity)"
```

---

## Task 4: Repository interface

**Files:**
- Create: `lib/features/stories/domain/repositories/stories_repository.dart`

- [ ] **Step 1: Create abstract repository + provider stub**

```dart
// lib/features/stories/domain/repositories/stories_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/story.dart';

final storiesRepositoryProvider = Provider<StoriesRepository>((ref) {
  throw UnimplementedError('storiesRepositoryProvider not initialized');
});

abstract class StoriesRepository {
  Future<List<Story>> getActiveStories();
  void recordImpression(String storyUuid);
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/stories/domain/repositories/stories_repository.dart
git commit -m "feat(stories): add StoriesRepository interface"
```

---

## Task 5: API datasource

**Files:**
- Create: `lib/features/stories/data/datasources/stories_api_datasource.dart`
- Modify: `lib/config/dio_client.dart` (public endpoints list)

- [ ] **Step 1: Add `/stories` to public endpoints in `dio_client.dart`**

In `lib/config/dio_client.dart`, inside `JwtAuthInterceptor.onRequest`, add `'/stories'` to the `publicEndpoints` list:

```dart
    final publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/forgot-password',
      '/auth/reset-password',
      '/auth/refresh',
      '/auth/otp',
      '/auth/check-email',
      '/events',
      '/categories',
      '/thematiques',
      '/cities',
      '/filters',
      '/home-feed',
      '/mobile/config',
      '/posts',
      '/stories',  // <-- add this line
    ];
```

- [ ] **Step 2: Create StoriesApiDataSource**

```dart
// lib/features/stories/data/datasources/stories_api_datasource.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/story_dto.dart';

final storiesApiDataSourceProvider = Provider<StoriesApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return StoriesApiDataSource(dio);
});

class StoriesApiDataSource {
  final Dio _dio;

  StoriesApiDataSource(this._dio);

  /// Fetch active stories for today.
  /// Returns up to 8 stories ordered by: reserved first, then optional by slot_position.
  Future<List<StoryDto>> getActiveStories() async {
    final response = await _dio.get('/stories/active');

    if (response.statusCode == 200) {
      final data = response.data;

      // Standard API response: { "success": true, "data": [...] }
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final dataContent = data['data'];
        if (dataContent is List) {
          return dataContent
              .map((e) => StoryDto.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      // Fallback: direct list at root
      if (data is List) {
        return data
            .map((e) => StoryDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    throw Exception('Failed to fetch active stories');
  }

  /// Record an impression for a story. Fire-and-forget: no await needed by caller,
  /// errors are silently logged.
  void recordImpression(String storyUuid) {
    _dio.post('/stories/$storyUuid/impression').catchError((e) {
      if (kDebugMode) {
        debugPrint('Stories: impression failed for $storyUuid: $e');
      }
    });
  }
}
```

- [ ] **Step 3: Verify no syntax errors**

Run: `flutter analyze lib/features/stories/data/datasources/stories_api_datasource.dart lib/config/dio_client.dart`
Expected: No issues found (or only pre-existing warnings)

- [ ] **Step 4: Commit**

```bash
git add lib/features/stories/data/datasources/stories_api_datasource.dart lib/config/dio_client.dart
git commit -m "feat(stories): add API datasource + register public endpoint"
```

---

## Task 6: Repository implementation

**Files:**
- Create: `lib/features/stories/data/repositories/stories_repository_impl.dart`

- [ ] **Step 1: Create StoriesRepositoryImpl**

```dart
// lib/features/stories/data/repositories/stories_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/stories_repository.dart';
import '../datasources/stories_api_datasource.dart';
import '../mappers/story_mapper.dart';

final storiesRepositoryImplProvider = Provider<StoriesRepository>((ref) {
  final dataSource = ref.read(storiesApiDataSourceProvider);
  return StoriesRepositoryImpl(dataSource);
});

class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesApiDataSource _dataSource;

  StoriesRepositoryImpl(this._dataSource);

  @override
  Future<List<Story>> getActiveStories() async {
    final dtos = await _dataSource.getActiveStories();
    return StoryMapper.toStories(dtos);
  }

  @override
  void recordImpression(String storyUuid) {
    _dataSource.recordImpression(storyUuid);
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/stories/data/repositories/stories_repository_impl.dart
git commit -m "feat(stories): add StoriesRepositoryImpl"
```

---

## Task 7: Stories provider

**Files:**
- Create: `lib/features/stories/presentation/providers/stories_provider.dart`

- [ ] **Step 1: Create ActiveStoriesNotifier**

```dart
// lib/features/stories/presentation/providers/stories_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/stories_repository_impl.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/stories_repository.dart';

final activeStoriesProvider =
    AutoDisposeAsyncNotifierProvider<ActiveStoriesNotifier, List<Story>>(
  ActiveStoriesNotifier.new,
);

class ActiveStoriesNotifier extends AutoDisposeAsyncNotifier<List<Story>> {
  @override
  Future<List<Story>> build() async {
    final repository = ref.watch(storiesRepositoryImplProvider);

    final stories = await repository.getActiveStories();
    ref.keepAlive();
    return stories;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  /// Fire-and-forget impression recording.
  void recordImpression(String storyUuid) {
    final repository = ref.read(storiesRepositoryImplProvider);
    repository.recordImpression(storyUuid);
  }
}
```

- [ ] **Step 2: Verify no syntax errors**

Run: `flutter analyze lib/features/stories/presentation/providers/stories_provider.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/features/stories/presentation/providers/stories_provider.dart
git commit -m "feat(stories): add activeStoriesProvider"
```

---

## Task 8: Update the stories UI widget

This is the largest task. The widget `event_stories.dart` currently renders `List<Activity>` from `featuredActivitiesProvider`. We swap it to render `List<Story>` from `activeStoriesProvider`, add impression tracking, infinite loop, and update the content overlay.

**Files:**
- Modify: `lib/features/home/presentation/widgets/event_stories.dart`

- [ ] **Step 1: Update imports and `viewedStoriesProvider`**

Replace the imports block and leave `ViewedStoriesNotifier` as-is (it tracks by string ID — now we'll use `story.uuid`):

Replace old imports:
```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
```

With:
```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/stories/domain/entities/story.dart';
import 'package:lehiboo/features/stories/presentation/providers/stories_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
```

- [ ] **Step 2: Update `EventStories` widget to use `activeStoriesProvider`**

Replace the `build` method body in `EventStories`. Change `ref.watch(featuredActivitiesProvider)` to `ref.watch(activeStoriesProvider)`, and replace all `Activity` references with `Story`:

```dart
class EventStories extends ConsumerWidget {
  const EventStories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(activeStoriesProvider);
    final viewedStories = ref.watch(viewedStoriesProvider);

    return storiesAsync.when(
      data: (stories) {
        if (stories.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header "À la une"
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [HbColors.brandPrimary, HbColors.brandPrimaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'À la une',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: HbColors.textSlate,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (stories.any((s) => !viewedStories.contains(s.uuid)))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: HbColors.brandPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Stories list
            SizedBox(
              height: 124,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: stories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final story = stories[index];
                  final isViewed = viewedStories.contains(story.uuid);

                  return _StoryCircle(
                    story: story,
                    isViewed: isViewed,
                    onTap: () => _openStoryViewer(context, ref, stories, index),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 124,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) => const _StoryCircleSkeleton(),
            ),
          ),
        ],
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _openStoryViewer(BuildContext context, WidgetRef ref, List<Story> stories, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: _StoryViewerOverlay(
              stories: stories,
              initialIndex: initialIndex,
            ),
          );
        },
      ),
    );
  }
}
```

- [ ] **Step 3: Update `_StoryCircle` to use `Story`**

Replace `_StoryCircle` class entirely:

```dart
class _StoryCircle extends StatefulWidget {
  final Story story;
  final bool isViewed;
  final VoidCallback onTap;

  const _StoryCircle({
    required this.story,
    required this.isViewed,
    required this.onTap,
  });

  @override
  State<_StoryCircle> createState() => _StoryCircleState();
}

class _StoryCircleState extends State<_StoryCircle> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (!widget.isViewed) {
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(_StoryCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isViewed && !oldWidget.isViewed) {
      _shimmerController.stop();
    } else if (!widget.isViewed && oldWidget.isViewed) {
      _shimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: widget.isViewed
                        ? null
                        : SweepGradient(
                            startAngle: _shimmerController.value * 2 * 3.14159,
                            colors: const [
                              HbColors.brandPrimary,
                              HbColors.brandPrimaryLight,
                              Color(0xFFFFB347),
                              HbColors.brandPrimaryLight,
                              HbColors.brandPrimary,
                            ],
                          ),
                    border: widget.isViewed
                        ? Border.all(color: Colors.grey.shade300, width: 2)
                        : null,
                    boxShadow: widget.isViewed
                        ? null
                        : [
                            BoxShadow(
                              color: HbColors.brandPrimary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                          ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      child: ClipOval(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: widget.story.mediaUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => _buildPlaceholder(),
                              errorWidget: (context, url, error) => _buildPlaceholder(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.25),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: HbColors.brandPrimary,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            Text(
              _getShortLabel(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: widget.isViewed ? FontWeight.w400 : FontWeight.w600,
                color: widget.isViewed ? Colors.grey[500] : HbColors.textSlate,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    final firstLetter = widget.story.title.isNotEmpty
        ? widget.story.title[0].toUpperCase()
        : '?';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            HbColors.brandPrimary.withValues(alpha: 0.8),
            HbColors.brandPrimaryLight.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          firstLetter,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getShortLabel() {
    final words = widget.story.title.split(' ');
    if (words.length <= 2) return widget.story.title;
    return '${words[0]} ${words[1]}';
  }
}
```

- [ ] **Step 4: Update `_StoryViewerOverlay` — Story type, impressions, infinite loop**

Replace `_StoryViewerOverlay` and its state class entirely. Key changes:
- Takes `List<Story>` instead of `List<Activity>`
- Calls `recordImpression` on each story view
- Loops back to first story instead of closing after the last one

```dart
class _StoryViewerOverlay extends ConsumerStatefulWidget {
  final List<Story> stories;
  final int initialIndex;

  const _StoryViewerOverlay({
    required this.stories,
    required this.initialIndex,
  });

  @override
  ConsumerState<_StoryViewerOverlay> createState() => _StoryViewerOverlayState();
}

class _StoryViewerOverlayState extends ConsumerState<_StoryViewerOverlay>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  int _currentIndex = 0;

  static const _storyDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    _progressController = AnimationController(
      vsync: this,
      duration: _storyDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _goToNextStory();
        }
      });

    _markCurrentAsViewed();
    _recordCurrentImpression();
    _progressController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _markCurrentAsViewed() {
    final currentStory = widget.stories[_currentIndex];
    ref.read(viewedStoriesProvider.notifier).markAsViewed(currentStory.uuid);
  }

  void _recordCurrentImpression() {
    final currentStory = widget.stories[_currentIndex];
    ref.read(activeStoriesProvider.notifier).recordImpression(currentStory.uuid);
  }

  void _goToNextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Loop back to first story
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _markCurrentAsViewed();
    _recordCurrentImpression();
    _progressController.reset();
    _progressController.forward();
  }

  void _onTapDown(TapDownDetails details, double screenWidth) {
    final x = details.globalPosition.dx;
    if (x < screenWidth / 3) {
      _goToPreviousStory();
    } else if (x > screenWidth * 2 / 3) {
      _goToNextStory();
    }
  }

  void _onLongPressStart(LongPressStartDetails details) {
    _progressController.stop();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _progressController.forward();
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dy < -500) {
      // Swipe up → navigate to event detail via event UUID
      final currentStory = widget.stories[_currentIndex];
      Navigator.of(context).pop();
      context.push('/event/${currentStory.eventUuid}');
    } else if (details.velocity.pixelsPerSecond.dy > 500) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, screenWidth),
        onLongPressStart: _onLongPressStart,
        onLongPressEnd: _onLongPressEnd,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                return _StoryContent(story: widget.stories[index]);
              },
            ),

            // Progress indicators
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: List.generate(widget.stories.length, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 3,
                        child: AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) {
                            double progress;
                            if (index < _currentIndex) {
                              progress = 1.0;
                            } else if (index == _currentIndex) {
                              progress = _progressController.value;
                            } else {
                              progress = 0.0;
                            }

                            return LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Close button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 12,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Update `_StoryContent` — use Story fields, update overlay text**

Replace `_StoryContent` entirely. Uses `story.mediaUrl` for background, shows category + booking mode label, uses `story.eventCity`, and formats `story.startDate`:

```dart
class _StoryContent extends StatelessWidget {
  final Story story;

  const _StoryContent({required this.story});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image (video stories show mediaUrl as fallback image for now)
        CachedNetworkImage(
          imageUrl: story.mediaUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[900],
            child: const Center(
              child: CircularProgressIndicator(color: HbColors.brandPrimary),
            ),
          ),
          errorWidget: (context, url, error) => _buildPlaceholder(),
        ),

        // Gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),
        ),

        // Content
        Positioned(
          bottom: 100,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category badge + booking mode
              if (story.categoryName != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: HbColors.brandPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _buildCategoryLabel(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Title (story title, not event title)
              Text(
                story.title,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Location & Date
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    story.eventCity ?? 'France',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(story.startDate),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Swipe up indicator
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.keyboard_arrow_up, color: Colors.white70, size: 28),
                    Text(
                      'Swipe pour voir',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build "Catégorie · Billetterie" or "Catégorie · Découverte" label.
  String _buildCategoryLabel() {
    final category = story.categoryName ?? '';
    final mode = story.eventBookingMode == 'booking' ? 'Billetterie' : 'Découverte';
    if (category.isEmpty) return mode;
    return '$category · $mode';
  }

  Widget _buildPlaceholder() {
    return Container(
      color: HbColors.accentBlue,
      child: Center(
        child: Image.asset(
          'assets/images/logo_picto_lehiboo.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Aujourd\'hui';
    } else if (dateOnly == tomorrow) {
      return 'Demain';
    } else {
      final weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      return '${weekdays[date.weekday - 1]} ${date.day}/${date.month}';
    }
  }
}
```

- [ ] **Step 6: Keep `_StoryCircleSkeleton` as-is**

The skeleton widget has no dependency on `Activity` — it's pure UI. No changes needed.

- [ ] **Step 7: Verify the full file compiles**

Run: `flutter analyze lib/features/home/presentation/widgets/event_stories.dart`
Expected: No errors

- [ ] **Step 8: Commit**

```bash
git add lib/features/home/presentation/widgets/event_stories.dart
git commit -m "feat(stories): migrate stories widget to new Story API"
```

---

## Task 9: Update home screen integration

**Files:**
- Modify: `lib/features/home/presentation/screens/home_screen.dart`

- [ ] **Step 1: Add stories import, replace featuredActivitiesProvider in refresh**

Add to imports section of `home_screen.dart`:
```dart
import 'package:lehiboo/features/stories/presentation/providers/stories_provider.dart';
```

In `_refreshData()`, replace:
```dart
ref.read(featuredActivitiesProvider.notifier).refresh(),
```
with:
```dart
ref.read(activeStoriesProvider.notifier).refresh(),
```

- [ ] **Step 2: Verify no syntax errors**

Run: `flutter analyze lib/features/home/presentation/screens/home_screen.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add lib/features/home/presentation/screens/home_screen.dart
git commit -m "feat(stories): use activeStoriesProvider in home screen refresh"
```

---

## Task 10: Decouple partner_highlight and remove dead code

**Files:**
- Modify: `lib/features/home/presentation/widgets/partner_highlight.dart`
- Modify: `lib/features/home/presentation/providers/home_providers.dart`

- [ ] **Step 1: Update partner_highlight.dart to use activeStoriesProvider as mock source**

`partner_highlight.dart` currently uses `featuredActivitiesProvider` as mock data. Since that provider is being removed, update it to use `activeStoriesProvider` or the home feed as its mock data source. Since partner_highlight renders `Activity` objects from its mock, and our stories are `Story` objects, the simplest fix is to switch it to use `homeActivitiesProvider` (recommended activities) which also returns `List<Activity>`:

In `partner_highlight.dart`, replace:
```dart
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
```
(No change needed to imports since `homeActivitiesProvider` is in the same file.)

Replace:
```dart
final activitiesAsync = ref.watch(featuredActivitiesProvider);
```
with:
```dart
final activitiesAsync = ref.watch(homeActivitiesProvider);
```

- [ ] **Step 2: Remove `FeaturedActivitiesNotifier` and `featuredActivitiesProvider` from `home_providers.dart`**

Delete lines 109-141 in `home_providers.dart` — the entire block:

```dart
// DELETE THIS BLOCK:

// ──────────────────────────────────────────────────────────────────────────────
// Featured / Promoted Activities
// ──────────────────────────────────────────────────────────────────────────────

final featuredActivitiesProvider = AutoDisposeAsyncNotifierProvider<FeaturedActivitiesNotifier, List<Activity>>(
  FeaturedActivitiesNotifier.new,
);

class FeaturedActivitiesNotifier extends AutoDisposeAsyncNotifier<List<Activity>> {
  @override
  Future<List<Activity>> build() async {
    final eventRepository = ref.watch(eventRepositoryProvider);

    try {
      final result = await eventRepository.getEvents(
        page: 1,
        perPage: 5,
        orderBy: 'views',
        order: 'desc',
      );

      ref.keepAlive();
      return EventToActivityMapper.toActivities(result.events);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}
```

- [ ] **Step 3: Verify no remaining references to `featuredActivitiesProvider`**

Run: `grep -r "featuredActivitiesProvider" lib/`
Expected: No matches (or only in docs, not in `.dart` files)

- [ ] **Step 4: Verify everything compiles**

Run: `flutter analyze lib/features/home/`
Expected: No errors

- [ ] **Step 5: Commit**

```bash
git add lib/features/home/presentation/widgets/partner_highlight.dart lib/features/home/presentation/providers/home_providers.dart
git commit -m "refactor(stories): remove deprecated featuredActivitiesProvider"
```

---

## Task 11: Full build verification

- [ ] **Step 1: Run full project analysis**

Run: `flutter analyze`
Expected: No errors (warnings OK if pre-existing)

- [ ] **Step 2: Run existing tests**

Run: `flutter test`
Expected: All existing tests pass

- [ ] **Step 3: Verify stories feature directory structure**

Run: `find lib/features/stories -type f | sort`
Expected:
```
lib/features/stories/data/datasources/stories_api_datasource.dart
lib/features/stories/data/mappers/story_mapper.dart
lib/features/stories/data/models/story_dto.dart
lib/features/stories/data/repositories/stories_repository_impl.dart
lib/features/stories/domain/entities/story.dart
lib/features/stories/domain/repositories/stories_repository.dart
lib/features/stories/presentation/providers/stories_provider.dart
```

- [ ] **Step 4: Final commit (if any remaining changes)**

```bash
git status
# If clean, nothing to commit. If leftover changes:
git add -A && git commit -m "chore(stories): final cleanup after migration"
```
