# Stories Video Playback — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** When a story has `mediaType == StoryMediaType.video`, play the video fullscreen in the story viewer instead of showing a static image.

**Architecture:** Add `video_player` package. Create a `StoryVideoPlayer` widget that manages `VideoPlayerController` lifecycle. In `_StoryContent`, branch on `story.mediaType` — image path unchanged, video path renders `StoryVideoPlayer`. The overlay passes a `ValueNotifier<bool>` for pause/resume sync with long-press. Videos auto-play muted, loop within the 5-second story timer.

**Tech Stack:** `video_player` (Flutter team official package)

---

## File Map

| Action | File | Responsibility |
|--------|------|---------------|
| Modify | `pubspec.yaml` | Add `video_player` dependency |
| Create | `lib/features/home/presentation/widgets/story_video_player.dart` | Self-contained video player widget with lifecycle management |
| Modify | `lib/features/home/presentation/widgets/event_stories.dart` | Pass `isPaused` notifier from overlay, branch on mediaType in `_StoryContent` |

---

## Task 1: Add video_player dependency

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add video_player to dependencies**

In `pubspec.yaml`, under the `# UI & Design` section (after `flutter_animate: ^4.5.0`), add:

```yaml
  video_player: ^2.9.2
```

- [ ] **Step 2: Install the dependency**

Run: `flutter pub get`
Expected: Resolves successfully with `video_player` added

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add video_player dependency for story videos"
```

---

## Task 2: Create StoryVideoPlayer widget

A self-contained StatefulWidget that manages `VideoPlayerController`. It initializes from a network URL, plays muted and looping, and responds to a `ValueNotifier<bool>` for pause/resume.

**Files:**
- Create: `lib/features/home/presentation/widgets/story_video_player.dart`

- [ ] **Step 1: Create the widget**

```dart
// lib/features/home/presentation/widgets/story_video_player.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:lehiboo/core/themes/colors.dart';

/// Fullscreen video player for story viewer.
/// Auto-plays muted, loops, and responds to pause/resume via [isPaused].
class StoryVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final ValueNotifier<bool> isPaused;

  const StoryVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.isPaused,
  });

  @override
  State<StoryVideoPlayer> createState() => _StoryVideoPlayerState();
}

class _StoryVideoPlayerState extends State<StoryVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..setVolume(0)
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
          if (!widget.isPaused.value) {
            _controller.play();
          }
        }
      }).catchError((e) {
        if (mounted) {
          setState(() => _hasError = true);
        }
      });

    widget.isPaused.addListener(_onPauseChanged);
  }

  void _onPauseChanged() {
    if (!_initialized) return;
    if (widget.isPaused.value) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  void dispose() {
    widget.isPaused.removeListener(_onPauseChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorPlaceholder();
    }

    if (!_initialized) {
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: CircularProgressIndicator(color: HbColors.brandPrimary),
        ),
      );
    }

    // Fill the screen while maintaining aspect ratio (crop to cover)
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
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
}
```

- [ ] **Step 2: Verify no syntax errors**

Run: `flutter analyze lib/features/home/presentation/widgets/story_video_player.dart`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add lib/features/home/presentation/widgets/story_video_player.dart
git commit -m "feat(stories): add StoryVideoPlayer widget"
```

---

## Task 3: Integrate video into story viewer

Wire up the `isPaused` notifier in `_StoryViewerOverlay` and branch on `mediaType` in `_StoryContent`.

**Files:**
- Modify: `lib/features/home/presentation/widgets/event_stories.dart`

- [ ] **Step 1: Add imports**

At the top of `event_stories.dart`, add:

```dart
import 'package:lehiboo/features/home/presentation/widgets/story_video_player.dart';
```

The `Story` entity import already exists (provides `StoryMediaType`).

- [ ] **Step 2: Add `_isPaused` ValueNotifier to `_StoryViewerOverlayState`**

In class `_StoryViewerOverlayState`, add a field after the existing fields:

```dart
  final ValueNotifier<bool> _isPaused = ValueNotifier(false);
```

In `dispose()`, add cleanup before existing dispose calls:

```dart
  @override
  void dispose() {
    _isPaused.dispose();
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }
```

- [ ] **Step 3: Toggle `_isPaused` in long-press handlers**

Update `_onLongPressStart`:

```dart
  void _onLongPressStart(LongPressStartDetails details) {
    _isPaused.value = true;
    _progressController.stop();
  }
```

Update `_onLongPressEnd`:

```dart
  void _onLongPressEnd(LongPressEndDetails details) {
    _isPaused.value = false;
    _progressController.forward();
  }
```

- [ ] **Step 4: Reset `_isPaused` on page change**

In `_onPageChanged`, add a reset at the beginning of the method:

```dart
  void _onPageChanged(int index) {
    _isPaused.value = false;
    setState(() {
      _currentIndex = index;
    });
    _markCurrentAsViewed();
    _recordCurrentImpression();
    _progressController.reset();
    _progressController.forward();
  }
```

- [ ] **Step 5: Pass `_isPaused` to `_StoryContent`**

In the `PageView.builder` inside the overlay's build method, change:

```dart
  return _StoryContent(story: widget.stories[index]);
```

To:

```dart
  return _StoryContent(
    story: widget.stories[index],
    isPaused: _isPaused,
  );
```

- [ ] **Step 6: Update `_StoryContent` to accept `isPaused` and branch on mediaType**

Change `_StoryContent` from `StatelessWidget` to accept the new parameter and branch on media type. Replace the entire class:

```dart
class _StoryContent extends StatelessWidget {
  final Story story;
  final ValueNotifier<bool> isPaused;

  const _StoryContent({
    required this.story,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background media: video or image
        if (story.mediaType == StoryMediaType.video)
          StoryVideoPlayer(
            videoUrl: story.mediaUrl,
            isPaused: isPaused,
          )
        else
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

        // Content overlay (category, title, location, date, swipe indicator)
        Positioned(
          bottom: 100,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

  String _buildCategoryLabel() {
    final category = story.categoryName ?? '';
    final mode = story.eventBookingMode == 'booking' ? 'Billetterie' : 'Découverte';
    if (category.isEmpty) return mode;
    return '$category \u00b7 $mode';
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

- [ ] **Step 7: Verify everything compiles**

Run: `flutter analyze lib/features/home/presentation/widgets/event_stories.dart lib/features/home/presentation/widgets/story_video_player.dart`
Expected: No errors

- [ ] **Step 8: Commit**

```bash
git add lib/features/home/presentation/widgets/event_stories.dart lib/features/home/presentation/widgets/story_video_player.dart
git commit -m "feat(stories): integrate video playback in story viewer"
```
