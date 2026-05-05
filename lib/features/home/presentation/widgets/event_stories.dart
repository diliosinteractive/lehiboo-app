import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lehiboo/core/services/volume_routing.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/home/presentation/widgets/story_video_player.dart';
import 'package:lehiboo/features/stories/domain/entities/story.dart';
import 'package:lehiboo/features/stories/presentation/providers/stories_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

/// Provider pour suivre les stories vues
final viewedStoriesProvider = StateNotifierProvider<ViewedStoriesNotifier, Set<String>>((ref) {
  return ViewedStoriesNotifier();
});

class ViewedStoriesNotifier extends StateNotifier<Set<String>> {
  ViewedStoriesNotifier() : super({}) {
    _loadViewedStories();
  }

  static const _storageKey = 'viewed_stories';

  Future<void> _loadViewedStories() async {
    final prefs = await SharedPreferences.getInstance();
    final viewed = prefs.getStringList(_storageKey) ?? [];
    state = viewed.toSet();
  }

  Future<void> markAsViewed(String storyId) async {
    if (state.contains(storyId)) return;

    state = {...state, storyId};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, state.toList());
  }

  bool isViewed(String storyId) => state.contains(storyId);
}

/// Stories d'événements trending, style Instagram
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
                  // Icône avec fond gradient
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
                  // Badge "NEW" si des stories non vues
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
          // Skeleton header
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
          // Skeleton stories
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

/// Cercle d'une story avec bordure gradient animée
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
    // Animation de shimmer pour les stories non vues
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
            // Circle with animated gradient border
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
                            // Thumbnail: image→mediaUrl, video+poster→posterUrl, video→first frame
                            _buildThumbnail(),
                            // Overlay sombre
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.25),
                              ),
                            ),
                            // Bouton play
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

            // Label - titre court de l'événement
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

  Widget _buildThumbnail() {
    // Image story → use mediaUrl directly
    if (widget.story.mediaType == StoryMediaType.image) {
      return CachedNetworkImage(
        imageUrl: widget.story.mediaUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }

    // Video story with posterUrl → use poster image
    if (widget.story.posterUrl != null) {
      return CachedNetworkImage(
        imageUrl: widget.story.posterUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }

    // Video story without posterUrl → extract first frame
    return _VideoThumbnail(
      videoUrl: widget.story.mediaUrl,
      placeholder: _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    // Placeholder coloré avec initiale ou icône
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
    // Afficher les 2 premiers mots du titre
    final words = widget.story.title.split(' ');
    if (words.length <= 2) {
      return widget.story.title;
    }
    return '${words[0]} ${words[1]}';
  }
}

/// Extracts the first frame of a video for use as a thumbnail.
/// Used when posterUrl is null (async generation pending or failed).
class _VideoThumbnail extends StatefulWidget {
  final String videoUrl;
  final Widget placeholder;

  const _VideoThumbnail({
    required this.videoUrl,
    required this.placeholder,
  });

  @override
  State<_VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..setVolume(0)
      ..initialize().then((_) {
        if (mounted) setState(() => _initialized = true);
      }).catchError((_) {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _controller == null) return widget.placeholder;

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: _controller!.value.size.width,
        height: _controller!.value.size.height,
        child: VideoPlayer(_controller!),
      ),
    );
  }
}

/// Skeleton pour le chargement
class _StoryCircleSkeleton extends StatelessWidget {
  const _StoryCircleSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Overlay plein écran pour visualiser les stories
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
  final ValueNotifier<bool> _isPaused = ValueNotifier(false);

  /// When the current story started displaying. Used to re-anchor the progress
  /// bar when a video reports its actual duration mid-playback.
  DateTime? _currentStoryStart;

  /// Guards against advancing twice when the timer and the video's
  /// onCompleted callback fire near-simultaneously.
  bool _isAdvancing = false;

  static const _imageStoryDuration = Duration(seconds: 5);
  static const _videoFallbackCapSeconds = 30;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    _progressController = AnimationController(
      vsync: this,
      duration: _durationFor(widget.stories[widget.initialIndex]),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _goToNextStory();
        }
      });

    // Route hardware volume buttons to media stream while the viewer is open.
    VolumeRouting.useMediaStream();

    // Mark initial story as viewed, record impression, and start progress
    _markCurrentAsViewed();
    _recordCurrentImpression();
    _currentStoryStart = DateTime.now();
    _progressController.forward();
  }

  /// Backend-configured cap for video stories, with a safe fallback when the
  /// mobile config hasn't loaded yet.
  int get _videoCapSeconds {
    final config = ref.read(mobileAppConfigProvider).valueOrNull;
    return config?.media.storyVideoMaxSeconds ?? _videoFallbackCapSeconds;
  }

  /// Initial timer duration for [story]. For videos this is the cap — it gets
  /// refined by [_onVideoDurationLoaded] once the player initializes.
  Duration _durationFor(Story story) {
    if (story.mediaType == StoryMediaType.image) {
      return _imageStoryDuration;
    }
    return Duration(seconds: _videoCapSeconds);
  }

  void _onVideoDurationLoaded(String storyUuid, Duration actualDuration) {
    if (!mounted) return;
    // Adjacent pages may also build a StoryVideoPlayer; ignore their callbacks.
    if (widget.stories[_currentIndex].uuid != storyUuid) return;
    if (actualDuration <= Duration.zero) return;

    final cap = Duration(seconds: _videoCapSeconds);
    final newDuration = actualDuration < cap ? actualDuration : cap;

    // Keep the progress bar in sync with elapsed real time so it doesn't snap
    // backwards when the duration shrinks.
    final elapsed = _currentStoryStart != null
        ? DateTime.now().difference(_currentStoryStart!)
        : Duration.zero;
    final newValue = newDuration.inMilliseconds == 0
        ? 0.0
        : (elapsed.inMilliseconds / newDuration.inMilliseconds).clamp(0.0, 1.0);

    _progressController.stop();
    _progressController.duration = newDuration;
    _progressController.value = newValue;
    if (!_isPaused.value && _progressController.value < 1.0) {
      _progressController.forward();
    }
  }

  void _onVideoCompleted(String storyUuid) {
    if (!mounted) return;
    if (widget.stories[_currentIndex].uuid != storyUuid) return;
    _goToNextStory();
  }

  @override
  void dispose() {
    VolumeRouting.restoreDefault();
    _isPaused.dispose();
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
    // Both the progress timer and the video's onCompleted can race to advance
    // the same story — guard so we only schedule one page transition.
    if (_isAdvancing) return;
    _isAdvancing = true;
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
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
    _isPaused.value = false;
    setState(() {
      _currentIndex = index;
    });
    _markCurrentAsViewed();
    _recordCurrentImpression();
    _progressController.stop();
    _progressController.duration = _durationFor(widget.stories[index]);
    _progressController.reset();
    _currentStoryStart = DateTime.now();
    _isAdvancing = false;
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
    _isPaused.value = true;
    _progressController.stop();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _isPaused.value = false;
    _progressController.forward();
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    // Swipe up = go to event detail
    if (details.velocity.pixelsPerSecond.dy < -500) {
      final currentStory = widget.stories[_currentIndex];
      Navigator.of(context).pop();
      context.push('/event/${currentStory.eventSlug}');
    }
    // Swipe down = close
    else if (details.velocity.pixelsPerSecond.dy > 500) {
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
            // Story content
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                return _StoryContent(
                  story: widget.stories[index],
                  isPaused: _isPaused,
                  onVideoDurationLoaded: _onVideoDurationLoaded,
                  onVideoCompleted: _onVideoCompleted,
                );
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

/// Contenu d'une story
class _StoryContent extends StatelessWidget {
  final Story story;
  final ValueNotifier<bool> isPaused;
  final void Function(String storyUuid, Duration duration)?
      onVideoDurationLoaded;
  final void Function(String storyUuid)? onVideoCompleted;

  const _StoryContent({
    required this.story,
    required this.isPaused,
    this.onVideoDurationLoaded,
    this.onVideoCompleted,
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
            onDurationLoaded: (d) => onVideoDurationLoaded?.call(story.uuid, d),
            onCompleted: () => onVideoCompleted?.call(story.uuid),
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

        // Content
        Positioned(
          bottom: 100,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category badge
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

              // Title
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
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(story.startDate),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // CTA button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/event/${story.eventSlug}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HbColors.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Voir l\'activité',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _buildCategoryLabel() {
    final parts = <String>[];
    if (story.categoryName != null && story.categoryName!.isNotEmpty) {
      parts.add(story.categoryName!);
    }
    if (story.eventTagName != null && story.eventTagName!.isNotEmpty) {
      parts.add(story.eventTagName!);
    }
    parts.add(story.eventBookingMode == 'booking' ? 'Billetterie' : 'Découverte');
    return parts.join(' \u00b7 ');
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
      final year = (date.year % 100).toString().padLeft(2, '0');
      return '${weekdays[date.weekday - 1]} ${date.day}/${date.month}/$year';
    }
  }
}
