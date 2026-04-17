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
