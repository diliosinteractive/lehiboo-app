import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:lehiboo/core/themes/colors.dart';

/// Fullscreen video player for story viewer.
/// Auto-plays with audio and responds to pause/resume via [isPaused].
/// Reports the actual media duration via [onDurationLoaded] and signals
/// natural end-of-playback via [onCompleted] so the parent can drive
/// per-story timing off the real video length.
class StoryVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final ValueNotifier<bool> isPaused;
  final ValueChanged<Duration>? onDurationLoaded;
  final VoidCallback? onCompleted;

  const StoryVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.isPaused,
    this.onDurationLoaded,
    this.onCompleted,
  });

  @override
  State<StoryVideoPlayer> createState() => _StoryVideoPlayerState();
}

class _StoryVideoPlayerState extends State<StoryVideoPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;
  bool _completedNotified = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..setVolume(1.0)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _initialized = true);
        widget.onDurationLoaded?.call(_controller.value.duration);
        if (!widget.isPaused.value) {
          _controller.play();
        }
      }).catchError((e) {
        if (mounted) {
          setState(() => _hasError = true);
        }
      });

    _controller.addListener(_onControllerTick);
    widget.isPaused.addListener(_onPauseChanged);
  }

  void _onControllerTick() {
    if (!_initialized || _completedNotified) return;
    final value = _controller.value;
    final duration = value.duration;
    if (duration <= Duration.zero) return;
    // VideoPlayerController flips `isPlaying` to false at the end and the
    // position reaches duration. Fire onCompleted exactly once.
    if (!value.isPlaying && value.position >= duration) {
      _completedNotified = true;
      widget.onCompleted?.call();
    }
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
    _controller.removeListener(_onControllerTick);
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
