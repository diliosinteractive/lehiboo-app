import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // Utiliser les activités "featured" comme stories pour le mock
    final activitiesAsync = ref.watch(featuredActivitiesProvider);
    final viewedStories = ref.watch(viewedStoriesProvider);

    return activitiesAsync.when(
      data: (activities) {
        if (activities.isEmpty) return const SizedBox.shrink();

        // Limiter à 8 stories max
        final stories = activities.take(8).toList();

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
                        colors: [Color(0xFFFF601F), Color(0xFFFF8B5A)],
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
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Badge "NEW" si des stories non vues
                  if (stories.any((s) => !viewedStories.contains(s.id)))
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF601F),
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
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: stories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final story = stories[index];
                  final isViewed = viewedStories.contains(story.id);

                  return _StoryCircle(
                    activity: story,
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
            height: 120,
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

  void _openStoryViewer(BuildContext context, WidgetRef ref, List<Activity> stories, int initialIndex) {
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
  final Activity activity;
  final bool isViewed;
  final VoidCallback onTap;

  const _StoryCircle({
    required this.activity,
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
                              Color(0xFFFF601F),
                              Color(0xFFFF8B5A),
                              Color(0xFFFFB347),
                              Color(0xFFFF8B5A),
                              Color(0xFFFF601F),
                            ],
                          ),
                    border: widget.isViewed
                        ? Border.all(color: Colors.grey.shade300, width: 2)
                        : null,
                    boxShadow: widget.isViewed
                        ? null
                        : [
                            BoxShadow(
                              color: const Color(0xFFFF601F).withValues(alpha: 0.3),
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
                        child: widget.activity.imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: widget.activity.imageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => _buildPlaceholder(),
                                errorWidget: (context, url, error) => _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
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
                color: widget.isViewed ? Colors.grey[500] : const Color(0xFF2D3748),
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
    // Placeholder coloré avec initiale ou icône
    final firstLetter = widget.activity.title.isNotEmpty
        ? widget.activity.title[0].toUpperCase()
        : '?';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF601F).withValues(alpha: 0.8),
            const Color(0xFFFF8B5A).withValues(alpha: 0.8),
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
    final words = widget.activity.title.split(' ');
    if (words.length <= 2) {
      return widget.activity.title;
    }
    return '${words[0]} ${words[1]}';
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
  final List<Activity> stories;
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

    // Mark initial story as viewed and start progress
    _markCurrentAsViewed();
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
    ref.read(viewedStoriesProvider.notifier).markAsViewed(currentStory.id);
  }

  void _goToNextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
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
    // Swipe up = go to event detail
    if (details.velocity.pixelsPerSecond.dy < -500) {
      final currentStory = widget.stories[_currentIndex];
      Navigator.of(context).pop();
      context.push('/event/${currentStory.id}', extra: currentStory);
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
                return _StoryContent(activity: widget.stories[index]);
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
  final Activity activity;

  const _StoryContent({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        if (activity.imageUrl != null)
          CachedNetworkImage(
            imageUrl: activity.imageUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[900],
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF601F)),
              ),
            ),
            errorWidget: (context, url, error) => _buildPlaceholder(),
          )
        else
          _buildPlaceholder(),

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
              if (activity.category != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF601F),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    activity.category!.name,
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
                activity.title,
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
                    activity.city?.name ?? 'France',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  if (activity.nextSlot != null) ...[
                    const SizedBox(width: 12),
                    const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(activity.nextSlot!.startDateTime),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
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

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFF1E3A8A),
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
